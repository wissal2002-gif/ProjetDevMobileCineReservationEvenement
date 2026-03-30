import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AvisEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Vérifie si l'utilisateur a une réservation confirmée pour ce film
  Future<bool> _aReserveFilm(Session session, int utilisateurId, int filmId) async {
    final seances = await Seance.db.find(
      session,
      where: (s) => s.filmId.equals(filmId),
    );
    if (seances.isEmpty) return false;
    final seanceIds = seances.map((s) => s.id!).toSet();

    final reservations = await Reservation.db.find(
      session,
      where: (r) =>
      r.utilisateurId.equals(utilisateurId) &
      r.seanceId.inSet(seanceIds) &
      r.statut.equals('confirmee'),
    );
    return reservations.isNotEmpty;
  }

  // Soumettre ou mettre à jour un avis
  Future<Avis?> soumettreAvis(Session session, int filmId, int note) async {
    if (note < 1 || note > 5) return null;

    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    // Vérifier que l'utilisateur a réservé ce film
    final aReserve = await _aReserveFilm(session, utilisateurId, filmId);
    if (!aReserve) {
      throw Exception("Vous ne pouvez noter que des films que vous avez réservés.");
    }

    final existants = await Avis.db.find(
      session,
      where: (a) => a.utilisateurId.equals(utilisateurId) & a.filmId.equals(filmId),
    );

    if (existants.isNotEmpty) {
      final avis = existants.first;
      avis.note = note;
      avis.dateAvis = DateTime.now().toUtc();
      return await Avis.db.updateRow(session, avis);
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

  // Note de l'utilisateur connecté pour un film
  Future<int?> getMonAvis(Session session, int filmId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final avis = await Avis.db.find(
      session,
      where: (a) => a.utilisateurId.equals(utilisateurId) & a.filmId.equals(filmId),
    );
    return avis.isEmpty ? null : avis.first.note;
  }

  // Note moyenne + nombre d'avis pour un film
  Future<Map<String, dynamic>> getStatsFilm(Session session, int filmId) async {
    final avis = await Avis.db.find(
      session,
      where: (a) => a.filmId.equals(filmId),
    );

    if (avis.isEmpty) {
      return {'moyenne': 0.0, 'total': 0};
    }

    final total = avis.length;
    final somme = avis.fold<int>(0, (s, a) => s + a.note);
    final moyenne = somme / total;
    return {'moyenne': double.parse(moyenne.toStringAsFixed(1)), 'total': total};
  }

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