import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SupportEndpoint extends Endpoint {
  Future<bool> creerDemande(Session session, String sujet, String message) async {
    try {
      final demande = DemandeSupport(
        utilisateurId: 1,
        sujet: sujet,
        message: message,
        createdAt: DateTime.now(),
        statut: 'ouvert',
      );
      await DemandeSupport.db.insertRow(session, demande);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<DemandeSupport>> getDemandes(Session session) async {
    try {
      return await DemandeSupport.db.find(
        session,
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
    } catch (e) {
      return [];
    }
  }
}