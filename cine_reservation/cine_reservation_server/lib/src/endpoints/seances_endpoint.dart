import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SeancesEndpoint extends Endpoint {
  Future<List<Seance>> getSeancesByFilm(Session session, int filmId) async {
    return await Seance.db.find(
      session,
      where: (t) => t.filmId.equals(filmId),
    );
  }

  /// Retourne les séances correspondant à une liste d'IDs.
  /// Utilisé par la HomePage pour personnaliser les recommandations :
  /// Reservation.seanceId → getSeancesByIds → Seance.filmId → Film.genre
  Future<List<Seance>> getSeancesByIds(
      Session session, List<int> ids) async {
    if (ids.isEmpty) return [];
    return await Seance.db.find(
      session,
      where: (t) => t.id.inSet(ids.toSet()),
    );
  }
}