import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SallesEndpoint extends Endpoint {
  Future<List<Salle>> getSalles(Session session) async {
    return await Salle.db.find(session);
  }
}