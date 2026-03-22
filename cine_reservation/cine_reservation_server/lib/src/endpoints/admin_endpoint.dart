import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/email_service.dart';

class AdminEndpoint extends Endpoint {
  // Helper pour récupérer l'utilisateur connecté de manière sécurisée
  Future<Utilisateur> _getRequiredUser(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');
    var user = await Utilisateur.db.findFirstRow(session,
        where: (t) => t.authUserId.equals(authInfo.userIdentifier));
    if (user == null) {
      user = await Utilisateur.db.findFirstRow(session,
          where: (t) => t.email.equals(authInfo.userIdentifier));
    }
    if (user == null) throw Exception('Utilisateur non trouvé en base.');
    return user;
  }

  // --- DASHBOARD ---
  Future<String> getDashboardTitle(Session session) async {
    try {
      final user = await _getRequiredUser(session);
      if (user.role == 'super_admin') return "ADMINISTRATION GLOBALE";
      if (user.role == 'resp_evenements') return "GESTION ÉVÉNEMENTS";
      if (user.role == 'admin_local' && user.cinemaId != null) {
        final cinema = await Cinema.db.findById(session, user.cinemaId!);
        return "ADMIN CINÉVENT ${cinema?.nom ?? 'LOCAL'}".toUpperCase();
      }
      return "ESPACE ADMINISTRATION";
    } catch (_) { return "ADMINISTRATION"; }
  }

  Future<Map<String, dynamic>> getDashboardData(Session session) async {
    final user = await _getRequiredUser(session);
    return {
      'adminTitle': await getDashboardTitle(session),
      'stats': await getAdminStats(session),
      'actions': await getDashboardActions(session),
      'role': user.role,
    };
  }

  Future<Map<String, int>> getDashboardActions(Session session) async {
    final user = await _getRequiredUser(session);
    final pendingSupport = await DemandeSupport.db.count(session, where: (t) => t.statut.notEquals('traité'));
    int cancelledRes = 0;
    if (user.role == 'super_admin' || user.role == 'resp_evenements') {
      cancelledRes = await Reservation.db.count(session, where: (t) => t.statut.equals('annule'));
    } else if (user.cinemaId != null) {
      final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      final sIds = salles.map((s) => s.id!).toSet();
      if (sIds.isNotEmpty) {
        final seances = await Seance.db.find(session, where: (t) => t.salleId.inSet(sIds));
        final seanceIds = seances.map((s) => s.id!).toSet();
        if (seanceIds.isNotEmpty) {
          cancelledRes = await Reservation.db.count(session, where: (t) => (t.seanceId.inSet(seanceIds)) & t.statut.equals('annule'));
        }
      }
    }
    return {'pendingSupport': pendingSupport, 'cancelledReservations': cancelledRes, 'totalItems': pendingSupport + cancelledRes};
  }

  Future<Map<String, int>> getAdminStats(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin' || user.role == 'resp_evenements') {
      return {
        'totalFilms': await Film.db.count(session),
        'totalEvents': await Evenement.db.count(session),
        'totalUsers': await Utilisateur.db.count(session),
        'totalReservations': await Reservation.db.count(session)
      };
    } else {
      final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      final sIds = salles.map((s) => s.id!).toSet();
      int resCount = 0;
      if (sIds.isNotEmpty) {
        final seances = await Seance.db.find(session, where: (t) => t.salleId.inSet(sIds));
        final seanceIds = seances.map((s) => s.id!).toSet();
        if (seanceIds.isNotEmpty) {
          resCount = await Reservation.db.count(session, where: (t) => t.seanceId.inSet(seanceIds));
        }
      }
      final eventCount = await Evenement.db.count(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      final userCount = await Utilisateur.db.count(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      
      int filmCount = 0;
      try {
        filmCount = await Film.db.count(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      } catch (e) {
        filmCount = await Film.db.count(session); 
      }
      
      return {
        'totalFilms': filmCount, 
        'totalEvents': eventCount,
        'totalUsers': userCount,
        'totalReservations': resCount,
      };
    }
  }

  // --- RÉSERVATIONS & REMBOURSEMENT ---
  Future<List<Reservation>> getAllReservations(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') return await Reservation.db.find(session, orderBy: (t) => t.dateReservation, orderDescending: true);
    if (user.role == 'resp_evenements') return await Reservation.db.find(session, where: (t) => t.evenementId.notEquals(null), orderBy: (t) => t.dateReservation, orderDescending: true);
    if (user.cinemaId != null) {
      final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      final sIds = salles.map((s) => s.id!).toSet();
      if (sIds.isEmpty) return [];
      final seances = await Seance.db.find(session, where: (t) => t.salleId.inSet(sIds));
      final seanceIds = seances.map((s) => s.id!).toSet();
      if (seanceIds.isEmpty) return [];
      return await Reservation.db.find(session, where: (t) => t.seanceId.inSet(seanceIds), orderBy: (t) => t.dateReservation, orderDescending: true);
    }
    return [];
  }

  Future<void> rembourserReservation(Session session, int resId, double amt, String raison) async {
    final res = await Reservation.db.findById(session, resId);
    if (res != null) {
      res.statut = 'rembourse';
      res.montantApresReduction = amt;
      await Reservation.db.updateRow(session, res);
      try {
        final user = await Utilisateur.db.findById(session, res.utilisateurId);
        if (user != null) {
          String titre = "Votre réservation";
          if (res.evenementId != null) {
            final ev = await Evenement.db.findById(session, res.evenementId!);
            titre = ev?.titre ?? "Événement";
          } else if (res.seanceId != null) {
            final seance = await Seance.db.findById(session, res.seanceId!);
            if (seance != null) {
              final film = await Film.db.findById(session, seance.filmId);
              titre = film?.titre ?? "Séance Cinéma";
            }
          }
          await EmailService.sendRefundNotification(
            toEmail: user.email, 
            nomUtilisateur: user.nom, 
            titre: titre, 
            montantRembourse: amt, 
            raison: raison
          );
        }
      } catch (e) {
        print("Erreur envoi email remboursement: $e");
      }
    }
  }

  // --- AUTRES MÉTHODES (POUR LE FONCTIONNEMENT GLOBAL) ---
  Future<List<Cinema>> getAllCinemas(Session session) async => await Cinema.db.find(session);
  Future<Cinema> ajouterCinema(Session session, Cinema c) async => await Cinema.db.insertRow(session, c);
  Future<Cinema> modifierCinema(Session session, Cinema c) async => await Cinema.db.updateRow(session, c);
  Future<void> supprimerCinema(Session session, int id) async {
    await Salle.db.deleteWhere(session, where: (t) => t.cinemaId.equals(id));
    await Cinema.db.deleteWhere(session, where: (t) => t.id.equals(id));
  }
  Future<List<Salle>> getAllSalles(Session session) async {
    final user = await _getRequiredUser(session);
    return await Salle.db.find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
  }
  Future<List<Salle>> getSalles(Session session) async => await Salle.db.find(session);
  Future<List<Salle>> getSallesByCinema(Session session, int cinemaId) async => await Salle.db.find(session, where: (t) => t.cinemaId.equals(cinemaId));
  Future<Salle> ajouterSalle(Session session, Salle s) async => await Salle.db.insertRow(session, s);
  Future<Salle> modifierSalle(Session session, Salle s) async => await Salle.db.updateRow(session, s);
  Future<void> supprimerSalle(Session session, int id) async => await Salle.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Siege>> getSiegesBySalle(Session session, int salleId) async => await Siege.db.find(session, where: (t) => t.salleId.equals(salleId), orderBy: (t) => t.numero);
  Future<void> genererSiegesPourSalle(Session session, int salleId, int rows, int cols) async {
    await Siege.db.deleteWhere(session, where: (t) => t.salleId.equals(salleId));
    List<Siege> list = [];
    final abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
    for (int i = 0; i < rows; i++) {
      for (int j = 1; j <= cols; j++) {
        list.add(Siege(salleId: salleId, rangee: abc[i], numero: "${abc[i]}$j", type: 'standard'));
      }
    }
    await Siege.db.insert(session, list);
  }
  Future<void> genererSiegesAutomatique(Session session, {required int salleId, required int nbRangees, required int nbColonnes}) async => await genererSiegesPourSalle(session, salleId, nbRangees, nbColonnes);
  Future<List<Seance>> getAllSeances(Session session) async => await Seance.db.find(session, orderBy: (t) => t.dateHeure);
  Future<Seance> ajouterSeance(Session session, Seance s) async => await Seance.db.insertRow(session, s);
  Future<Seance> modifierSeance(Session session, Seance s) async => await Seance.db.updateRow(session, s);
  Future<void> supprimerSeance(Session session, int id) async => await Seance.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Seance>> getSeancesByFilm(Session session, int filmId) async => await Seance.db.find(session, where: (t) => t.filmId.equals(filmId));
  Future<List<Seance>> getSeancesByCinema(Session session, int id) async {
    final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(id));
    final sIds = salles.map((s) => s.id!).toSet();
    if (sIds.isEmpty) return [];
    return await Seance.db.find(session, where: (t) => t.salleId.inSet(sIds));
  }
  Future<List<Film>> getAllFilms(Session session) async => await Film.db.find(session, orderBy: (t) => t.titre);
  Future<Film> ajouterFilm(Session session, Film f) async => await Film.db.insertRow(session, f);
  Future<Film> modifierFilm(Session session, Film f) async => await Film.db.updateRow(session, f);
  Future<void> supprimerFilm(Session session, int id) async => await Film.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Evenement>> getAllEvenements(Session session) async => await Evenement.db.find(session);
  Future<Evenement> ajouterEvenement(Session session, Evenement ev) async => await Evenement.db.insertRow(session, ev);
  Future<Evenement> modifierEvenement(Session session, Evenement ev) async => await Evenement.db.updateRow(session, ev);
  Future<void> supprimerEvenement(Session session, int id) async => await Evenement.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Utilisateur>> getAllUtilisateurs(Session session) async => await Utilisateur.db.find(session);
  Future<List<Utilisateur>> getManagedUsers(Session session) async => await Utilisateur.db.find(session);
  Future<void> activerUtilisateur(Session session, int id) async {
    final u = await Utilisateur.db.findById(session, id);
    if (u != null) { u.statut = 'actif'; await Utilisateur.db.updateRow(session, u); }
  }
  Future<void> suspendreUtilisateur(Session session, int id) async {
    final u = await Utilisateur.db.findById(session, id);
    if (u != null) { u.statut = 'suspendu'; await Utilisateur.db.updateRow(session, u); }
  }
  Future<void> supprimerUtilisateur(Session session, int id) async => await Utilisateur.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Reservation>> getHistoriqueUtilisateur(Session session, int userId) async => await Reservation.db.find(session, where: (t) => t.utilisateurId.equals(userId));
  Future<void> modifierUtilisateurRole(Session session, int userId, String newRole) async {
    final u = await Utilisateur.db.findById(session, userId);
    if (u != null) { u.role = newRole; await Utilisateur.db.updateRow(session, u); }
  }
  Future<void> traiterRemboursement(Session session, int resId) async => await rembourserReservation(session, resId, 0, "Remboursement traité");
  Future<List<Siege>> getSiegesByReservation(Session session, int resId) async {
    final relations = await ReservationSiege.db.find(session, where: (t) => t.reservationId.equals(resId));
    final ids = relations.map((r) => r.siegeId).toSet();
    if (ids.isEmpty) return [];
    return await Siege.db.find(session, where: (t) => t.id.inSet(ids));
  }
  Future<double> getTauxRemplissageSeance(Session session, int sId) async => 0.0;
  Future<List<DemandeSupport>> getAllDemandesSupport(Session session) async => await DemandeSupport.db.find(session);
  Future<void> repondreDemande(Session session, int id, String resp) async {
    final d = await DemandeSupport.db.findById(session, id);
    if (d != null) { d.reponse = resp; d.statut = 'traité'; await DemandeSupport.db.updateRow(session, d); }
  }
  Future<List<Faq>> getAdminFaqs(Session session) async => await Faq.db.find(session);
  Future<Faq> ajouterFaq(Session session, Faq f) async => await Faq.db.insertRow(session, f);
  Future<Faq> modifierFaq(Session session, Faq f) async => await Faq.db.updateRow(session, f);
  Future<void> supprimerFaq(Session session, int id) async => await Faq.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<OptionSupplementaire>> getAllOptions(Session session) async {
    final user = await _getRequiredUser(session);
    return await OptionSupplementaire.db.find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
  }
  Future<OptionSupplementaire> ajouterOption(Session session, OptionSupplementaire o) async => await OptionSupplementaire.db.insertRow(session, o);
  Future<OptionSupplementaire> modifierOption(Session session, OptionSupplementaire o) async => await OptionSupplementaire.db.updateRow(session, o);
  Future<void> supprimerOption(Session session, int id) async => await OptionSupplementaire.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<CodePromo>> getAllCodesPromo(Session session) async => await CodePromo.db.find(session);
  Future<CodePromo> ajouterCodePromo(Session session, CodePromo c) async => await CodePromo.db.insertRow(session, c);
  Future<CodePromo> modifierCodePromo(Session session, CodePromo c) async => await CodePromo.db.updateRow(session, c);
  Future<void> supprimerCodePromo(Session session, int id) async => await CodePromo.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<Map<String, dynamic>> getCodePromoStats(Session session, int id) async => {};
  Future<Map<String, dynamic>> getGlobalPromoSummary(Session session) async => {};
  Future<List<Utilisateur>> getStaffTanger(Session session) async => [];
  Future<void> ajouterStaff(Session session, String nom, String email) async {}
  Future<Utilisateur?> getMonProfil(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    return await Utilisateur.db.findFirstRow(session, where: (t) => t.authUserId.equals(authInfo.userIdentifier));
  }
  Future<List<Map<String, dynamic>>> getReservationsDetailed(Session session) async {
    final list = await getAllReservations(session);
    return list.map((r) => {'resId': r.id, 'statut': r.statut, 'montantTotal': r.montantTotal, 'dateReservation': r.dateReservation.toIso8601String()}).toList();
  }
  Future<List<Utilisateur>> getAllClients(Session session) async => await Utilisateur.db.find(session);
}
