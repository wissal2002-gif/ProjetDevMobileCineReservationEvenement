import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FaqEndpoint extends Endpoint {
  Future<List<Faq>> getAllFaqs(Session session) async {
    return await Faq.db.find(
      session,
      where: (t) => t.actif.equals(true),
      orderBy: (t) => t.ordre,
    );
  }
}