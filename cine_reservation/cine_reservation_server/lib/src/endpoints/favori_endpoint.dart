import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FavoriEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Utilisateur?> _getUser(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    return await Utilisateur.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.userIdentifier),
    );
  }

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

  // Ajouter un film aux favoris
  Future<bool> ajouterFilm(Session session, int filmId) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return false;

    // Vérifier que l'utilisateur a réservé ce film
    final aReserve = await _aReserveFilm(session, user.id!, filmId);
    if (!aReserve) {
      throw Exception("Vous ne pouvez ajouter en favori que des films que vous avez réservés.");
    }

    final existants = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.filmId.equals(filmId),
    );
    if (existants.isNotEmpty) return true;

    await Favori.db.insertRow(
      session,
      Favori(utilisateurId: user.id!, filmId: filmId, cinemaId: null),
    );
    return true;
  }

  // Retirer un film des favoris
  Future<bool> retirerFilm(Session session, int filmId) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return false;

    final existants = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.filmId.equals(filmId),
    );
    if (existants.isEmpty) return false;
    await Favori.db.deleteRow(session, existants.first);
    return true;
  }

  // Ajouter un cinéma aux favoris (pas de restriction de réservation)
  Future<bool> ajouterCinema(Session session, int cinemaId) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return false;

    final existants = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.cinemaId.equals(cinemaId),
    );
    if (existants.isNotEmpty) return true;

    await Favori.db.insertRow(
      session,
      Favori(utilisateurId: user.id!, filmId: null, cinemaId: cinemaId),
    );
    return true;
  }

  // Retirer un cinéma des favoris
  Future<bool> retirerCinema(Session session, int cinemaId) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return false;

    final existants = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.cinemaId.equals(cinemaId),
    );
    if (existants.isEmpty) return false;
    await Favori.db.deleteRow(session, existants.first);
    return true;
  }

  // IDs des films favoris
  Future<List<int>> getMesFilmsFavoris(Session session) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return [];

    final favoris = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.filmId.notEquals(null),
    );
    return favoris.where((f) => f.filmId != null).map((f) => f.filmId!).toList();
  }

  // IDs des cinémas favoris
  Future<List<int>> getMesCinemasFavoris(Session session) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return [];

    final favoris = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.cinemaId.notEquals(null),
    );
    return favoris.where((f) => f.cinemaId != null).map((f) => f.cinemaId!).toList();
  }

  // Vérifier si un film est favori
  Future<bool> estFilmFavori(Session session, int filmId) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return false;

    final existants = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.filmId.equals(filmId),
    );
    return existants.isNotEmpty;
  }

  // Vérifier si un cinéma est favori
  Future<bool> estCinemaFavori(Session session, int cinemaId) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return false;

    final existants = await Favori.db.find(
      session,
      where: (f) => f.utilisateurId.equals(user.id!) & f.cinemaId.equals(cinemaId),
    );
    return existants.isNotEmpty;
  }
}