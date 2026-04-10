import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class EvenementsEndpoint extends Endpoint {
  // Récupérer tous les événements actifs
  Future<List<Evenement>> getEvenements(Session session) async {
    return await Evenement.db.find(
      session,
      where: (t) => t.statut.equals('actif'),
      orderBy: (t) => t.dateDebut,
    );
  }

  // Détails d'un événement
  Future<Evenement?> getEvenementById(Session session, int id) async {
    return await Evenement.db.findById(session, id);
  }

  // Rechercher des événements par titre ou ville
  Future<List<Evenement>> searchEvenements(Session session, String query) async {
    return await Evenement.db.find(
      session,
      where: (t) => t.titre.ilike('%$query%') | t.ville.ilike('%$query%'),
    );
  }

  // Événements par cinéma
  Future<List<Evenement>> getEvenementsByCinema(Session session, int cinemaId) async {
    return await Evenement.db.find(
      session,
      where: (t) => t.cinemaId.equals(cinemaId) & t.statut.equals('actif'),
      orderBy: (t) => t.dateDebut,
    );
  }
}