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

    // ✅ FIX: On récupère l'utilisateur réel en base de données via son identifiant d'auth
    final user = await Utilisateur.db.findFirstRow(session,
        where: (t) => t.authUserId.equals(authInfo.userIdentifier));
    
    if (user == null || user.id == null) {
      print('❌ Erreur Paiement: Utilisateur non trouvé en base.');
      return null;
    }

    final reservation = await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != user.id) {
      print('❌ Erreur Paiement: La réservation n\'appartient pas à cet utilisateur.');
      return null;
    }

    // ── Créer le paiement ────────────────────────────────────────────────
    final paiement = Paiement(
      reservationId: reservationId,
      montant: montant,
      methode: methode,
      statut: 'complete',
      createdAt: DateTime.now().toUtc(),
    );
    final paiementInsere = await Paiement.db.insertRow(session, paiement);

    // ── Confirmer la réservation ─────────────────────────────────────────
    reservation.statut = 'confirmee';
    await Reservation.db.updateRow(session, reservation);

    // ── Créer le billet ──────────────────────────────────────────────────
    final billet = Billet(
      reservationId: reservationId,
      typeReservation: reservation.typeReservation,
      dateEmission: DateTime.now().toUtc(),
      estValide: true,
      typeBillet: 'standard',
      qrCode: 'CINEEVENT-$reservationId-${DateTime.now().millisecondsSinceEpoch}',
    );
    await Billet.db.insertRow(session, billet);

    // ── Points fidélité (1pt / 10 MAD) ──────────────────────────────────
    user.pointsFidelite = (user.pointsFidelite ?? 0) + (montant / 10).floor();
    await Utilisateur.db.updateRow(session, user);

    // ── Envoyer email de confirmation ────────────────────────────────────
    try {
        // Infos séance ou événement
        String titreFilm = 'Votre réservation';
        String dateSeance = DateFormat('dd/MM/yyyy HH:mm')
            .format(reservation.dateReservation.toLocal());
        String cinema = 'CinéEvent';

        if (reservation.seanceId != null) {
          final seance = await Seance.db.findById(session, reservation.seanceId!);
          if (seance != null) {
            dateSeance = DateFormat('dd/MM/yyyy HH:mm').format(seance.dateHeure.toLocal());
            final film = await Film.db.findById(session, seance.filmId);
            if (film != null) titreFilm = film.titre;
            final salle = await Salle.db.findById(session, seance.salleId);
            if (salle != null) {
              final cin = await Cinema.db.findById(session, salle.cinemaId);
              if (cin != null) cinema = cin.nom;
            }
          }
        } else if (reservation.evenementId != null) {
          final evenement = await Evenement.db.findById(session, reservation.evenementId!);
          if (evenement != null) {
            titreFilm = evenement.titre;
            dateSeance = DateFormat('dd/MM/yyyy HH:mm').format(evenement.dateDebut.toLocal());
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
          qrCode: billet.qrCode ?? 'CINEEVENT-$reservationId',
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

    final reservation = await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != user.id) {
      return false;
    }

    reservation.statut = 'remboursement_demande';
    await Reservation.db.updateRow(session, reservation);
    return true;
  }
}
