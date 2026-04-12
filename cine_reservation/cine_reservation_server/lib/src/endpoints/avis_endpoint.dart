import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AvisEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ── Vérifier si l'utilisateur a réservé ce film ─────────
  Future<bool> _aReserveFilm(
      Session session, int utilisateurId, int filmId) async {
    // Chercher toutes les séances du film
    final seances = await Seance.db.find(
      session,
      where: (s) => s.filmId.equals(filmId),
    );

    if (seances.isEmpty) return false;

    final seanceIds = seances.map((s) => s.id!).toSet();

    // Chercher une réservation confirmée pour une de ces séances
    final reservations = await Reservation.db.find(
      session,
      where: (r) =>
      r.utilisateurId.equals(utilisateurId) &
      r.statut.equals('confirmee'),
    );

    // Vérifier qu'au moins une réservation concerne ce film
    for (final reservation in reservations) {
      if (reservation.seanceId != null &&
          seanceIds.contains(reservation.seanceId)) {
        return true;
      }
    }

    return false;
  }

  // ── Soumettre ou mettre à jour un avis ──────────────────
  Future<Avis?> soumettreAvis(
      Session session, int filmId, int note) async {
    if (note < 1 || note > 5) return null;

    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    // Récupérer l'utilisateur
    final user = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );
    if (user == null || user.id == null) return null;

    final utilisateurId = user.id!;

    // ✅ Vérifier que l'utilisateur a bien réservé ce film
    final aReserve = await _aReserveFilm(session, utilisateurId, filmId);
    if (!aReserve) {
      // Retourner null avec un message clair loggé
      session.log(
        'Utilisateur $utilisateurId a tenté de noter le film $filmId sans réservation confirmée.',
        level: LogLevel.info,
      );
      return null;
    }

    // Chercher un avis existant
    final existants = await Avis.db.find(
      session,
      where: (a) =>
      a.utilisateurId.equals(utilisateurId) &
      a.filmId.equals(filmId),
    );

    if (existants.isNotEmpty) {
      final avis = existants.first;
      avis.note = note;
      avis.dateAvis = DateTime.now().toUtc();
      final updated = await Avis.db.updateRow(session, avis);
      await _updateNoteMoyenne(session, filmId);
      return updated;
    } else {
      final avis = Avis(
        utilisateurId: utilisateurId,
        filmId: filmId,
        note: note,
        dateAvis: DateTime.now().toUtc(),
      );
      final inserted = await Avis.db.insertRow(session, avis);
      await _updateNoteMoyenne(session, filmId);
      return inserted;
    }
  }

  // ── Vérifier si l'utilisateur PEUT noter ce film ────────
  // Appelé depuis Flutter pour afficher/masquer le widget notation
  Future<bool> peutNoter(Session session, int filmId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;

    final user = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );
    if (user == null || user.id == null) return false;

    return await _aReserveFilm(session, user.id!, filmId);
  }

  // ── Note de l'utilisateur connecté pour un film ─────────
  Future<int?> getMonAvis(Session session, int filmId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final user = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );
    if (user == null || user.id == null) return null;

    final avis = await Avis.db.find(
      session,
      where: (a) =>
      a.utilisateurId.equals(user.id!) & a.filmId.equals(filmId),
    );

    return avis.isEmpty ? null : avis.first.note;
  }

  // ── Note moyenne + nombre d'avis pour un film ───────────
  Future<Map<String, dynamic>> getStatsFilm(
      Session session, int filmId) async {
    final avis = await Avis.db.find(
      session,
      where: (a) => a.filmId.equals(filmId),
    );

    if (avis.isEmpty) return {'moyenne': 0.0, 'total': 0};

    final total = avis.length;
    final somme = avis.fold<int>(0, (s, a) => s + a.note);
    final moyenne = somme / total;

    return {
      'moyenne': double.parse(moyenne.toStringAsFixed(1)),
      'total': total,
    };
  }

  // ── Mise à jour de noteMoyenne dans la table Film ───────
  Future<void> _updateNoteMoyenne(Session session, int filmId) async {
    final avis = await Avis.db.find(
      session,
      where: (a) => a.filmId.equals(filmId),
    );
    if (avis.isEmpty) return;

    final somme = avis.fold<int>(0, (s, a) => s + a.note);
    final moyenne = somme / avis.length;

    final film = await Film.db.findById(session, filmId);
    if (film == null) return;

    film.noteMoyenne = double.parse(moyenne.toStringAsFixed(1));
    await Film.db.updateRow(session, film);
  }
}