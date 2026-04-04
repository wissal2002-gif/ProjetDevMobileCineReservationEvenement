import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class OptionsEndpoint extends Endpoint {

  // Toutes les options (sans filtre) — utilisé par l'admin global
  Future<List<OptionSupplementaire>> getOptions(Session session) async {
    return await OptionSupplementaire.db.find(session);
  }

  // Options filtrées par cinéma — utilisé dans le panier client
  Future<List<OptionSupplementaire>> getOptionsByCinema(
      Session session, int cinemaId) async {
    return await OptionSupplementaire.db.find(
      session,
      where: (t) => t.cinemaId.equals(cinemaId),
    );
  }
}