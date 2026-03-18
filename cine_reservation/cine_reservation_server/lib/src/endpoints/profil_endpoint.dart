import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ProfilEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ─── Récupérer le profil ───────────────────────────────
  Future<Utilisateur?> getProfil(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );

    if (utilisateur == null) return null;

    // Vérification suspension — ajouté depuis version Imane
    if (utilisateur.statut == 'suspendu') {
      throw Exception('ACCOUNT_SUSPENDED');
    }

    return utilisateur;
  }

  // ─── Modifier le profil ───────────────────────────────
  Future<Utilisateur?> updateProfil(
      Session session,
      String nom,
      String? telephone,
      DateTime? dateNaissance,
      ) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );
    if (utilisateur == null) return null;

    final updated = utilisateur.copyWith(
      nom: nom,
      telephone: telephone,
      dateNaissance: dateNaissance,
    );
    return await Utilisateur.db.updateRow(session, updated);
  }

  // ─── Sauvegarder photo de profil (base64) ─────────────
  Future<Utilisateur?> updatePhotoProfil(
      Session session,
      String photoBase64,
      ) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );
    if (utilisateur == null) return null;

    final updated = utilisateur.copyWith(photoProfil: photoBase64);
    return await Utilisateur.db.updateRow(session, updated);
  }

  // ─── Désactiver le compte temporairement ──────────────
  Future<bool> desactiverCompte(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;

    final utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );
    if (utilisateur == null) return false;

    final updated = utilisateur.copyWith(statut: 'inactif');
    await Utilisateur.db.updateRow(session, updated);
    return true;
  }

  // ─── Supprimer le compte définitivement ───────────────
  Future<bool> supprimerCompte(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;

    final utilisateur = await Utilisateur.db.findFirstRow(
      session,
      where: (u) => u.authUserId.equals(authInfo.userIdentifier),
    );
    if (utilisateur == null) return false;

    await Utilisateur.db.deleteRow(session, utilisateur);
    return true;
  }
}