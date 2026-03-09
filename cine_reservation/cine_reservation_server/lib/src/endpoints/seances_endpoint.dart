import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SeancesEndpoint extends Endpoint {
  Future<List<Seance>> getSeancesByFilm(Session session, int filmId) async {
    // On simplifie la requête pour voir si le générateur passe
    return await Seance.db.find(
      session,
      where: (t) => t.filmId.equals(filmId),
    );
  }
}