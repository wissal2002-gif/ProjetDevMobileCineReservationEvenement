import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FilmsEndpoint extends Endpoint {
  // Récupérer tous les films (pour la grille de la Home Page)
  Future<List<Film>> getFilms(Session session) async {
    return await Film.db.find(
      session,
      orderBy: (t) => t.id,
    );
  }

  // Récupérer un film par son ID (pour la page de détails)
  Future<Film?> getFilmById(Session session, int id) async {
    return await Film.db.findById(session, id);
  }

  // Rechercher des films par titre, genre ou réalisateur
  Future<List<Film>> searchFilms(Session session, String query) async {
    return await Film.db.find(
      session,
      where: (t) => t.titre.ilike('%$query%') | t.genre.ilike('%$query%') | t.realisateur.ilike('%$query%'),
    );
  }
}