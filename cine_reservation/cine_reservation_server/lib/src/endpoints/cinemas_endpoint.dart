import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class CinemasEndpoint extends Endpoint {
  Future<List<Cinema>> getCinemas(Session session) async {
    return await Cinema.db.find(session);
  }

  Future<Cinema?> getCinemaById(Session session, int id) async {
    return await Cinema.db.findById(session, id);
  }
}