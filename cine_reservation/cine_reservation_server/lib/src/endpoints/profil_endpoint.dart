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

  // ─── Sauvegarder photo de profil (base64) ───
  Future<Utilisateur?> updatePhotoProfil(
      Session session,
      String photoBase64,
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
      photoProfil: photoBase64,
    );
    return await Utilisateur.db.updateRow(session, utilisateur);
  }

  // ─── Désactiver le compte temporairement ───
  Future<bool> desactiverCompte(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurs = await Utilisateur.db.find(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
      limit: 1,
    );
    if (utilisateurs.isEmpty) return false;
    final utilisateur = utilisateurs.first.copyWith(statut: 'inactif');
    await Utilisateur.db.updateRow(session, utilisateur);
    return true;
  }

  // ─── Supprimer le compte définitivement ───
  Future<bool> supprimerCompte(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurs = await Utilisateur.db.find(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
      limit: 1,
    );
    if (utilisateurs.isEmpty) return false;
    await Utilisateur.db.deleteRow(session, utilisateurs.first);
    return true;
  }
}
