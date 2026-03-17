import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AvisEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ── Soumettre ou mettre à jour un avis ──────────────────
  // Grâce à l'index unique (utilisateurId, filmId),
  // un utilisateur ne peut noter qu'une seule fois par film.
  // Si un avis existe déjà, on le met à jour.
  Future<Avis?> soumettreAvis(
      Session session, int filmId, int note) async {
    // Validation de la note
    if (note < 1 || note > 5) return null;

    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final utilisateurId =
        int.tryParse(authInfo.userIdentifier) ?? 0;

    // Chercher un avis existant pour cet utilisateur + film
    final existants = await Avis.db.find(
      session,
      where: (a) =>
      a.utilisateurId.equals(utilisateurId) &
      a.filmId.equals(filmId),
    );

    if (existants.isNotEmpty) {
      // Mettre à jour l'avis existant
      final avis = existants.first;
      avis.note = note;
      avis.dateAvis = DateTime.now().toUtc();
      return await Avis.db.updateRow(session, avis);
    } else {
      // Créer un nouvel avis
      final avis = Avis(
        utilisateurId: utilisateurId,
        filmId: filmId,
        note: note,
        dateAvis: DateTime.now().toUtc(),
      );
      final inserted = await Avis.db.insertRow(session, avis);

      // Mettre à jour la note moyenne du film
      await _updateNoteMoyenne(session, filmId);

      return inserted;
    }
  }

  // ── Note de l'utilisateur connecté pour un film ─────────
  Future<int?> getMonAvis(Session session, int filmId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final utilisateurId =
        int.tryParse(authInfo.userIdentifier) ?? 0;

    final avis = await Avis.db.find(
      session,
      where: (a) =>
      a.utilisateurId.equals(utilisateurId) &
      a.filmId.equals(filmId),
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

    if (avis.isEmpty) {
      return {'moyenne': 0.0, 'total': 0};
    }

    final total = avis.length;
    final somme = avis.fold<int>(0, (s, a) => s + a.note);
    final moyenne = somme / total;

    return {'moyenne': double.parse(moyenne.toStringAsFixed(1)), 'total': total};
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