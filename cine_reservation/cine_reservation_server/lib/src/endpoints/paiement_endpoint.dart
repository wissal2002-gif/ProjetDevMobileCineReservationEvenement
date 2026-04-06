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

    final reservation =
    await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != user.id) {
      return null;
    }

    // Si déjà confirmée, retourner le paiement existant
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

    if (reservation.statut != 'en_attente') return null;

    // Récupérer les sièges
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

    // Décrémenter places séance
    if (reservation.seanceId != null) {
      final seance =
      await Seance.db.findById(session, reservation.seanceId!);
      if (seance != null) {
        seance.placesDisponibles =
            ((seance.placesDisponibles ?? 0) - siegeRelations.length)
                .clamp(0, seance.placesDisponibles ?? 0);
        await Seance.db.updateRow(session, seance);
      }
    }

    // ✅ FIX 2 : décrémenter places événement avec le bon nombre
    if (reservation.evenementId != null) {
      final evenement =
      await Evenement.db.findById(session, reservation.evenementId!);
      if (evenement != null) {
        final nbPlaces =
        siegeRelations.isNotEmpty ? siegeRelations.length : 1;
        evenement.placesDisponibles =
            ((evenement.placesDisponibles ?? 0) - nbPlaces)
                .clamp(0, evenement.placesTotales ?? 999);
        await Evenement.db.updateRow(session, evenement);
      }
    }

    // Créer les billets
    List<Billet> billetsCrees = [];
    for (var rs in siegeRelations) {
      final billet = Billet(
        reservationId: reservationId,
        siegeId: rs.siegeId > 0 ? rs.siegeId : null,
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

    // ✅ FIX 3 : Points fidélité + mise à jour table fidelite
    final pointsGagnes = (montant / 10).floor();
    user.pointsFidelite = (user.pointsFidelite ?? 0) + pointsGagnes;
    await Utilisateur.db.updateRow(session, user);

    // Mettre à jour ou créer l'entrée dans la table fidelite
    await _mettreAJourFidelite(session, user.id!, pointsGagnes, montant);

    // Email de confirmation
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
          final salle =
          await Salle.db.findById(session, seance.salleId);
          if (salle != null) {
            final cin =
            await Cinema.db.findById(session, salle.cinemaId);
            if (cin != null) cinema = cin.nom;
          }
        }
      } else if (reservation.evenementId != null) {
        final evenement = await Evenement.db
            .findById(session, reservation.evenementId!);
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

  // ✅ FIX 3 : créer ou mettre à jour la table fidelite
  Future<void> _mettreAJourFidelite(
      Session session,
      int utilisateurId,
      int pointsGagnes,
      double montant,
      ) async {
    try {
      // Chercher l'entrée existante
      final fideliteExistante = await Fidelite.db.findFirstRow(
        session,
        where: (f) => f.utilisateurId.equals(utilisateurId),
      );

      if (fideliteExistante != null) {
        // Mettre à jour les points et le total dépensé
        final nouveauxPoints =
            (fideliteExistante.points ?? 0) + pointsGagnes;
        final nouveauTotal =
            (fideliteExistante.totalDepense ?? 0) + montant;
        final nouveauNiveau = _calculerNiveau(nouveauxPoints);

        final updated = fideliteExistante.copyWith(
          points: nouveauxPoints,
          totalDepense: nouveauTotal,
          niveau: nouveauNiveau,
        );
        await Fidelite.db.updateRow(session, updated);
      } else {
        // Créer une nouvelle entrée fidélité
        final niveau = _calculerNiveau(pointsGagnes);
        final nouvelleFidelite = Fidelite(
          utilisateurId: utilisateurId,
          points: pointsGagnes,
          niveau: niveau,
          totalDepense: montant,
          dateAdhesion: DateTime.now().toUtc(),
        );
        await Fidelite.db.insertRow(session, nouvelleFidelite);
      }
    } catch (e) {
      // Ne pas bloquer le paiement si la fidélité échoue
      print('Erreur mise à jour fidélité: $e');
    }
  }

  // Calcul du niveau selon les points
  String _calculerNiveau(int points) {
    if (points >= 500) return 'or';
    if (points >= 200) return 'argent';
    return 'bronze';
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