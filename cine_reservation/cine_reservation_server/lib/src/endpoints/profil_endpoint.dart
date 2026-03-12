import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ProfilEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Utilisateur?> getProfil(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return null;

    final utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.userIdentifier),
    );

    if (utilisateur == null) return null;

    // Vérification de la suspension
    if (utilisateur.statut == 'suspendu') {
      throw Exception('ACCOUNT_SUSPENDED');
    }

    return utilisateur;
  }

  Future<Utilisateur?> updateProfil(
    Session session,
    String nom,
    String? telephone,
    DateTime? dateNaissance,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return null;

    final utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.userIdentifier),
    );

    if (utilisateur == null) return null;

    final updated = utilisateur.copyWith(
      nom: nom,
      telephone: telephone,
      dateNaissance: dateNaissance,
    );

    return await Utilisateur.db.updateRow(session, updated);
  }
}
