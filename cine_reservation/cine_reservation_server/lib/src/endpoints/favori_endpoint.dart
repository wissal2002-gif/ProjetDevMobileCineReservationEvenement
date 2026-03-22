import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FavoriEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ── Ajouter un film aux favoris ──────────────────────
  Future<bool> ajouterFilm(Session session, int filmId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final existants = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.filmId.equals(filmId),
    );
    if (existants.isNotEmpty) return true;

    await Favori.db.insertRow(
      session,
      Favori(utilisateurId: utilisateurId, filmId: filmId, cinemaId: null),
    );
    return true;
  }

  // ── Retirer un film des favoris ──────────────────────
  Future<bool> retirerFilm(Session session, int filmId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final existants = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.filmId.equals(filmId),
    );
    if (existants.isEmpty) return false;
    await Favori.db.deleteRow(session, existants.first);
    return true;
  }

  // ── Ajouter un cinéma aux favoris ────────────────────
  Future<bool> ajouterCinema(Session session, int cinemaId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final existants = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.cinemaId.equals(cinemaId),
    );
    if (existants.isNotEmpty) return true;

    await Favori.db.insertRow(
      session,
      Favori(utilisateurId: utilisateurId, filmId: null, cinemaId: cinemaId),
    );
    return true;
  }

  // ── Retirer un cinéma des favoris ────────────────────
  Future<bool> retirerCinema(Session session, int cinemaId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final existants = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.cinemaId.equals(cinemaId),
    );
    if (existants.isEmpty) return false;
    await Favori.db.deleteRow(session, existants.first);
    return true;
  }

  // ── IDs des films favoris ────────────────────────────
  Future<List<int>> getMesFilmsFavoris(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final favoris = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.filmId.notEquals(null),
    );
    return favoris.where((f) => f.filmId != null).map((f) => f.filmId!).toList();
  }

  // ── IDs des cinémas favoris ──────────────────────────
  Future<List<int>> getMesCinemasFavoris(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final favoris = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.cinemaId.notEquals(null),
    );
    return favoris.where((f) => f.cinemaId != null).map((f) => f.cinemaId!).toList();
  }

  // ── Vérifier si un film est favori ───────────────────
  Future<bool> estFilmFavori(Session session, int filmId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final existants = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.filmId.equals(filmId),
    );
    return existants.isNotEmpty;
  }

  // ── Vérifier si un cinéma est favori ─────────────────
  Future<bool> estCinemaFavori(Session session, int cinemaId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;

    final existants = await Favori.db.find(
      session,
      where: (f) =>
      f.utilisateurId.equals(utilisateurId) &
      f.cinemaId.equals(cinemaId),
    );
    return existants.isNotEmpty;
  }
}