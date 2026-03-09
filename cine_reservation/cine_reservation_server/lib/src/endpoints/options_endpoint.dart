import 'package:serverpod/serverpod.dart'
;
import '../generated/protocol.dart';

class OptionsEndpoint extends Endpoint {
  Future<List<OptionSupplementaire>> getOptions(Session session) async {
    return await OptionSupplementaire.db.find(session);
  }
}