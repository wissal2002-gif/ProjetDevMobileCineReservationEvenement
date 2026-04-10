import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FilmsEndpoint extends Endpoint {
  Future<List<Film>> getFilms(Session session) async {
    return await Film.db.find(
      session,
      orderBy: (t) => t.id,
    );
  }

  Future<Film?> getFilmById(Session session, int id) async {
    return await Film.db.findById(session, id);
  }

  Future<List<Film>> searchFilms(Session session, String query) async {
    return await Film.db.find(
      session,
      where: (t) =>
      t.titre.ilike('%$query%') |
      t.genre.ilike('%$query%') |
      t.realisateur.ilike('%$query%'),
    );
  }

  Future<List<Film>> getFilmsByCinema(Session session, int cinemaId) async {
    final salles = await Salle.db.find(session,
        where: (t) => t.cinemaId.equals(cinemaId));
    final salleIds = salles.map((s) => s.id!).toSet();
    if (salleIds.isEmpty) return [];
    final seances = await Seance.db.find(session,
        where: (t) => t.salleId.inSet(salleIds));
    final filmIds = seances.map((s) => s.filmId).toSet();
    if (filmIds.isEmpty) return [];
    return await Film.db.find(session,
        where: (t) => t.id.inSet(filmIds),
        orderBy: (t) => t.titre);
  }
}