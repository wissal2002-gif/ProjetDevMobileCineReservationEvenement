import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SupportEndpoint extends Endpoint {

  // ── ADMIN LOCAL crée une demande avec son cinemaId ──────────────
  Future<bool> creerDemande(
      Session session,
      String sujet,
      String message,
      int utilisateurId,
      int? cinemaId,          // ← AJOUTER
      ) async {
    try {
      final demande = DemandeSupport(
        utilisateurId: utilisateurId,
        cinemaId: cinemaId,   // ← AJOUTER
        sujet: sujet,
        message: message,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        statut: 'ouvert',
      );
      await DemandeSupport.db.insertRow(session, demande);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── SUPER ADMIN récupère TOUTES les demandes ────────────────────
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

  // ── SUPER ADMIN filtre par cinéma ───────────────────────────────
  Future<List<DemandeSupport>> getDemandesByCinema(
      Session session,
      int cinemaId,
      ) async {
    try {
      return await DemandeSupport.db.find(
        session,
        where: (t) => t.cinemaId.equals(cinemaId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
    } catch (e) {
      return [];
    }
  }
}