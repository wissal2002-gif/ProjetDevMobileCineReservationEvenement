import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ProfilEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ─── Récupérer le profil ───
  Future<Utilisateur?> getProfil(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final utilisateurs = await Utilisateur.db.find(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
      limit: 1,
    );

    return utilisateurs.isEmpty ? null : utilisateurs.first;
  }

  // ─── Modifier le profil ───
  Future<Utilisateur?> updateProfil(
      Session session,
      String nom,
      String? telephone,
      DateTime? dateNaissance,
      ) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final utilisateurs = await Utilisateur.db.find(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
      limit: 1,
    );

    if (utilisateurs.isEmpty) return null;

    final utilisateur = utilisateurs.first.copyWith(
      nom: nom,
      telephone: telephone,
      dateNaissance: dateNaissance,
    );

    return await Utilisateur.db.updateRow(session, utilisateur);
  }
}