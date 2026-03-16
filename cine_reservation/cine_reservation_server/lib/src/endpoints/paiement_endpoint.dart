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
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final reservation = await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != utilisateurId) {
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
    final points = (montant / 10).floor();
    if (points > 0) {
      final utilisateurs = await Utilisateur.db.find(
        session,
        where: (u) => u.authUserId.equals(authInfo.userIdentifier),
      );
      if (utilisateurs.isNotEmpty) {
        final u = utilisateurs.first;
        u.pointsFidelite = (u.pointsFidelite ?? 0) + points;
        await Utilisateur.db.updateRow(session, u);
      }
    }

    // ── Envoyer email de confirmation ────────────────────────────────────
    try {
      // Récupérer l'utilisateur pour son email et nom
      final utilisateurs = await Utilisateur.db.find(
        session,
        where: (u) => u.authUserId.equals(authInfo.userIdentifier),
        limit: 1,
      );

      if (utilisateurs.isNotEmpty) {
        final utilisateur = utilisateurs.first;

        // Infos séance ou événement
        String titreFilm = 'Votre réservation';
        String dateSeance = DateFormat('dd/MM/yyyy HH:mm')
            .format(reservation.dateReservation.toLocal());
        String cinema = 'CinéEvent';

        if (reservation.seanceId != null) {
          final seances = await Seance.db.find(
            session,
            where: (s) => s.id.equals(reservation.seanceId!),
            limit: 1,
          );
          if (seances.isNotEmpty) {
            final seance = seances.first;
            dateSeance = DateFormat('dd/MM/yyyy HH:mm')
                .format(seance.dateHeure.toLocal());

            // Récupérer le film
            final films = await Film.db.find(
              session,
              where: (f) => f.id.equals(seance.filmId),
              limit: 1,
            );
            if (films.isNotEmpty) titreFilm = films.first.titre;

            // Récupérer la salle et le cinéma
            final salles = await Salle.db.find(
              session,
              where: (s) => s.id.equals(seance.salleId),
              limit: 1,
            );
            if (salles.isNotEmpty) {
              final cinemas = await Cinema.db.find(
                session,
                where: (c) => c.id.equals(salles.first.cinemaId),
                limit: 1,
              );
              if (cinemas.isNotEmpty) cinema = cinemas.first.nom;
            }
          }
        } else if (reservation.evenementId != null) {
          final evenements = await Evenement.db.find(
            session,
            where: (e) => e.id.equals(reservation.evenementId!),
            limit: 1,
          );
          if (evenements.isNotEmpty) {
            final ev = evenements.first;
            titreFilm = ev.titre;
            dateSeance = DateFormat('dd/MM/yyyy HH:mm')
                .format(ev.dateDebut.toLocal());
            cinema = ev.lieu ?? ev.ville ?? 'CinéEvent';
          }
        }

        // Envoyer l'email
        await EmailService.sendReservationConfirmation(
          toEmail: utilisateur.email,
          nomUtilisateur: utilisateur.nom,
          titreFilm: titreFilm,
          dateSeance: dateSeance,
          cinema: cinema,
          montant: montant,
          qrCode: billet.qrCode ?? 'CINEEVENT-$reservationId',
          referenceReservation: '#$reservationId',
          methodePaiement: methode,
        );
      }
    } catch (e) {
      // Email non bloquant — la réservation reste valide
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
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final reservation = await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != utilisateurId) {
      return false;
    }

    reservation.statut = 'remboursement_demande';
    await Reservation.db.updateRow(session, reservation);
    return true;
  }
}