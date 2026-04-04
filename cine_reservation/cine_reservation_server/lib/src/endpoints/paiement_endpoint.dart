import 'package:serverpod/serverpod.dart';
import 'package:intl/intl.dart';
import '../generated/protocol.dart';
import '../services/email_service.dart';

class PaiementEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Paiement?> effectuerPaiement(
      Session session,
      int reservationId,
      double montant,
      String methode,
      ) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final user = await Utilisateur.db.findFirstRow(session,
        where: (t) => t.authUserId.equals(authInfo.userIdentifier));

    if (user == null || user.id == null) return null;

    final reservation = await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != user.id) {
      return null;
    }

    // ✅ FIX : si la réservation est déjà confirmée, retourner le paiement existant
    // sans recréer un nouveau paiement (évite l'erreur au 2ème appel)
    if (reservation.statut == 'confirmee') {
      final paiementsExistants = await Paiement.db.find(
        session,
        where: (t) => t.reservationId.equals(reservationId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      if (paiementsExistants.isNotEmpty) {
        return paiementsExistants.first;
      }
    }

    // ✅ FIX : vérifier que la réservation est bien en attente avant de payer
    if (reservation.statut != 'en_attente') {
      return null;
    }

    // Récupérer les sièges de la réservation
    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (t) => t.reservationId.equals(reservationId),
    );

    // Créer le paiement
    final paiement = Paiement(
      reservationId: reservationId,
      montant: montant,
      methode: methode,
      statut: 'complete',
      createdAt: DateTime.now().toUtc(),
    );
    final paiementInsere = await Paiement.db.insertRow(session, paiement);

    // Confirmer la réservation
    reservation.statut = 'confirmee';
    await Reservation.db.updateRow(session, reservation);

    // Décrémenter les places disponibles pour une séance
    if (reservation.seanceId != null) {
      final seance =
      await Seance.db.findById(session, reservation.seanceId!);
      if (seance != null) {
        final nbSieges = siegeRelations.length;
        seance.placesDisponibles =
            (seance.placesDisponibles ?? 0) - nbSieges;
        await Seance.db.updateRow(session, seance);
      }
    }

    // Décrémenter les places disponibles pour un événement
    if (reservation.evenementId != null) {
      final evenement =
      await Evenement.db.findById(session, reservation.evenementId!);
      if (evenement != null) {
        evenement.placesDisponibles =
            (evenement.placesDisponibles ?? 0) - 1;
        await Evenement.db.updateRow(session, evenement);
      }
    }

    // Créer un billet pour chaque siège
    List<Billet> billetsCrees = [];
    for (var rs in siegeRelations) {
      final billet = Billet(
        reservationId: reservationId,
        siegeId: rs.siegeId,
        typeReservation: reservation.typeReservation,
        dateEmission: DateTime.now().toUtc(),
        estValide: true,
        typeBillet: rs.typeTarif ?? 'standard',
        qrCode:
        'CINEEVENT-$reservationId-${rs.siegeId}-${DateTime.now().millisecondsSinceEpoch}',
      );
      final billetInsere = await Billet.db.insertRow(session, billet);
      billetsCrees.add(billetInsere);
    }

    // S'il n'y a pas de sièges (événement), créer un billet générique
    if (siegeRelations.isEmpty) {
      final billet = Billet(
        reservationId: reservationId,
        siegeId: null,
        typeReservation: reservation.typeReservation,
        dateEmission: DateTime.now().toUtc(),
        estValide: true,
        typeBillet: 'evenement',
        qrCode:
        'CINEEVENT-$reservationId-${DateTime.now().millisecondsSinceEpoch}',
      );
      final billetInsere = await Billet.db.insertRow(session, billet);
      billetsCrees.add(billetInsere);
    }

    // Points fidélité (1pt / 10 MAD)
    user.pointsFidelite =
        (user.pointsFidelite ?? 0) + (montant / 10).floor();
    await Utilisateur.db.updateRow(session, user);

    // Envoyer email de confirmation
    try {
      String titreFilm = 'Votre réservation';
      String dateSeance = DateFormat('dd/MM/yyyy HH:mm')
          .format(reservation.dateReservation.toLocal());
      String cinema = 'CinéEvent';

      if (reservation.seanceId != null) {
        final seance =
        await Seance.db.findById(session, reservation.seanceId!);
        if (seance != null) {
          dateSeance = DateFormat('dd/MM/yyyy HH:mm')
              .format(seance.dateHeure.toLocal());
          final film = await Film.db.findById(session, seance.filmId);
          if (film != null) titreFilm = film.titre;
          final salle = await Salle.db.findById(session, seance.salleId);
          if (salle != null) {
            final cin =
            await Cinema.db.findById(session, salle.cinemaId);
            if (cin != null) cinema = cin.nom;
          }
        }
      } else if (reservation.evenementId != null) {
        final evenement =
        await Evenement.db.findById(session, reservation.evenementId!);
        if (evenement != null) {
          titreFilm = evenement.titre;
          dateSeance = DateFormat('dd/MM/yyyy HH:mm')
              .format(evenement.dateDebut.toLocal());
          cinema = evenement.lieu ?? evenement.ville ?? 'CinéEvent';
        }
      }

      await EmailService.sendReservationConfirmation(
        toEmail: user.email,
        nomUtilisateur: user.nom,
        titreFilm: titreFilm,
        dateSeance: dateSeance,
        cinema: cinema,
        montant: montant,
        qrCode: billetsCrees.isNotEmpty
            ? billetsCrees.first.qrCode ?? 'CINEEVENT-$reservationId'
            : 'CINEEVENT-$reservationId',
        referenceReservation: '#$reservationId',
        methodePaiement: methode,
      );
    } catch (e) {
      print('Erreur envoi email confirmation: $e');
    }

    return paiementInsere;
  }

  Future<bool> demanderRemboursement(
      Session session,
      int reservationId,
      String raison,
      ) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;

    final user = await Utilisateur.db.findFirstRow(session,
        where: (t) => t.authUserId.equals(authInfo.userIdentifier));
    if (user == null) return false;

    final reservation =
    await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != user.id) {
      return false;
    }

    reservation.statut = 'remboursement_demande';
    await Reservation.db.updateRow(session, reservation);
    return true;
  }
}