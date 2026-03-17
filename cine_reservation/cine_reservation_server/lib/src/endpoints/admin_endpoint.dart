import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AdminEndpoint extends Endpoint {
  // Helper pour récupérer l'utilisateur connecté
  Future<Utilisateur> _getRequiredUser(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Non authentifié');
    final user = await Utilisateur.db.findFirstRow(session,
        where: (t) => t.authUserId.equals(authInfo.userIdentifier));
    if (user == null) throw Exception('Utilisateur non trouvé');
    return user;
  }

  // --- DASHBOARD & TITRE ---
  Future<String> getDashboardTitle(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') return "ADMINISTRATION GLOBALE";
    if (user.role == 'admin_local' && user.cinemaId != null) {
      final cinema = await Cinema.db.findById(session, user.cinemaId!);
      return "ADMIN CINÉVENT ${cinema?.nom ?? 'LOCAL'}".toUpperCase();
    }
    return "ESPACE ADMINISTRATION";
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
    final pendingSupport = await DemandeSupport.db
        .count(session, where: (t) => t.statut.notEquals('traité'));

    int cancelledRes = 0;
    if (user.role == 'super_admin') {
      cancelledRes = await Reservation.db
          .count(session, where: (t) => t.statut.equals('annule'));
    } else if (user.cinemaId != null) {
      final salles = await Salle.db
          .find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      final sIds = salles.map((s) => s.id!).toSet();
      if (sIds.isNotEmpty) {
        cancelledRes = await Reservation.db.count(session,
            where: (t) => (t.seanceId.inSet(sIds)) & t.statut.equals('annule'));
      }
    }
    return {
      'pendingSupport': pendingSupport,
      'cancelledReservations': cancelledRes,
      'totalItems': pendingSupport + cancelledRes,
    };
  }

  Future<Map<String, int>> getAdminStats(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') {
      return {
        'totalFilms': await Film.db.count(session),
        'totalEvents': await Evenement.db.count(session),
        'totalUsers': await Utilisateur.db.count(session),
        'totalReservations': await Reservation.db.count(session),
      };
    } else {
      // Logique locale Tanger
      final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      final sIds = salles.map((s) => s.id!).toSet();

      // ✅ Correction ici : ajoutez <Seance> devant les crochets []
      final seances = sIds.isEmpty
          ? <Seance>[]
          : await Seance.db.find(session, where: (t) => t.salleId.inSet(sIds));

      final seanceIds = seances.map((s) => s.id!).toSet();

      final eventCount = await Evenement.db.count(session, where: (t) => t.cinemaId.equals(user.cinemaId));

      int resCount = seanceIds.isEmpty
          ? 0
          : await Reservation.db.count(session, where: (t) => t.seanceId.inSet(seanceIds));

      return {
        'totalFilms': await Film.db.count(session),
        'totalEvents': eventCount,
        'totalUsers': await Utilisateur.db.count(session, where: (t) => t.cinemaId.equals(user.cinemaId)),
        'totalReservations': resCount,
      };
    }
  }
  // --- GESTION CINÉMAS ---
  Future<List<Cinema>> getAllCinemas(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') return await Cinema.db.find(session);
    if (user.cinemaId != null) {
      return await Cinema.db
          .find(session, where: (t) => t.id.equals(user.cinemaId));
    }
    return [];
  }

  Future<Cinema> ajouterCinema(Session session, Cinema c) async =>
      await Cinema.db.insertRow(session, c);
  Future<Cinema> modifierCinema(Session session, Cinema c) async =>
      await Cinema.db.updateRow(session, c);
  Future<void> supprimerCinema(Session session, int id) async {
    await Salle.db.deleteWhere(session, where: (t) => t.cinemaId.equals(id));
    await Cinema.db.deleteWhere(session, where: (t) => t.id.equals(id));
  }

  // --- SALLES & SIÈGES ---
  Future<List<Salle>> getAllSalles(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') return await Salle.db.find(session);
    return await Salle.db
        .find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
  }

  Future<List<Salle>> getSalles(Session session) async =>
      await getAllSalles(session);

  Future<List<Salle>> getSallesByCinema(Session session, int cinemaId) async =>
      await Salle.db.find(session, where: (t) => t.cinemaId.equals(cinemaId));
  Future<Salle> ajouterSalle(Session session, Salle s) async =>
      await Salle.db.insertRow(session, s);
  Future<Salle> modifierSalle(Session session, Salle s) async =>
      await Salle.db.updateRow(session, s);
  Future<void> supprimerSalle(Session session, int id) async =>
      await Salle.db.deleteWhere(session, where: (t) => t.id.equals(id));

  Future<List<Siege>> getSiegesBySalle(Session session, int salleId) async =>
      await Siege.db.find(session,
          where: (t) => t.salleId.equals(salleId), orderBy: (t) => t.numero);
  Future<void> genererSiegesPourSalle(
      Session session, int salleId, int nbRangees, int siegesParRangee) async {
    await Siege.db.deleteWhere(session, where: (t) => t.salleId.equals(salleId));
    List<Siege> sList = [];
    List<String> abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
    for (int i = 0; i < nbRangees; i++) {
      for (int j = 1; j <= siegesParRangee; j++) {
        sList.add(Siege(
            salleId: salleId, rangee: abc[i], numero: "${abc[i]}$j", type: 'standard'));
      }
    }
    await Siege.db.insert(session, sList);
  }

  // --- SÉANCES ---
  Future<List<Seance>> getAllSeances(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') {
      return await Seance.db.find(session, orderBy: (t) => t.dateHeure);
    }
    final salles = await Salle.db
        .find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
    final sIds = salles.map((s) => s.id!).toSet();
    if (sIds.isEmpty) return [];
    return await Seance.db
        .find(session, where: (t) => t.salleId.inSet(sIds), orderBy: (t) => t.dateHeure);
  }

  Future<Seance> ajouterSeance(Session session, Seance s) async =>
      await Seance.db.insertRow(session, s);
  Future<Seance> modifierSeance(Session session, Seance s) async =>
      await Seance.db.updateRow(session, s);
  Future<void> supprimerSeance(Session session, int id) async =>
      await Seance.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Seance>> getSeancesByFilm(Session session, int filmId) async =>
      await Seance.db.find(session, where: (t) => t.filmId.equals(filmId));
  Future<List<Seance>> getSeancesByCinema(Session session, int id) async {
    final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(id));
    final sIds = salles.map((s) => s.id!).toSet();
    if (sIds.isEmpty) return [];
    return await Seance.db.find(session, where: (t) => t.salleId.inSet(sIds));
  }

  // --- FILMS ---
  Future<List<Film>> getAllFilms(Session session) async =>
      await Film.db.find(session, orderBy: (t) => t.titre);
  Future<Film> ajouterFilm(Session session, Film f) async =>
      await Film.db.insertRow(session, f);
  Future<Film> modifierFilm(Session session, Film f) async =>
      await Film.db.updateRow(session, f);
  Future<void> supprimerFilm(Session session, int id) async =>
      await Film.db.deleteWhere(session, where: (t) => t.id.equals(id));

  // --- ÉVÉNEMENTS ---
  Future<List<Evenement>> getAllEvenements(Session session) async =>
      await Evenement.db.find(session, orderBy: (t) => t.dateDebut);
  Future<Evenement> ajouterEvenement(Session session, Evenement ev) async =>
      await Evenement.db.insertRow(session, ev);
  Future<Evenement> modifierEvenement(Session session, Evenement ev) async =>
      await Evenement.db.updateRow(session, ev);
  Future<void> supprimerEvenement(Session session, int id) async =>
      await Evenement.db.deleteWhere(session, where: (t) => t.id.equals(id));

  // --- UTILISATEURS ---
  Future<List<Utilisateur>> getAllUtilisateurs(Session session) async =>
      await Utilisateur.db.find(session);
  Future<List<Utilisateur>> getManagedUsers(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') return await Utilisateur.db.find(session);
    return await Utilisateur.db
        .find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
  }

  Future<void> activerUtilisateur(Session session, int id) async {
    final u = await Utilisateur.db.findById(session, id);
    if (u != null) {
      u.statut = 'actif';
      await Utilisateur.db.updateRow(session, u);
    }
  }

  Future<void> suspendreUtilisateur(Session session, int id) async {
    final u = await Utilisateur.db.findById(session, id);
    if (u != null) {
      u.statut = 'suspendu';
      await Utilisateur.db.updateRow(session, u);
    }
  }

  Future<void> supprimerUtilisateur(Session session, int id) async =>
      await Utilisateur.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Reservation>> getHistoriqueUtilisateur(
          Session session, int userId) async =>
      await Reservation.db.find(session,
          where: (t) => t.utilisateurId.equals(userId),
          orderBy: (t) => t.dateReservation,
          orderDescending: true);

  // --- RÉSERVATIONS ---
  // Dans admin_endpoint.dart
  Future<List<Reservation>> getAllReservations(Session session) async {
    final user = await _getRequiredUser(session);

    if (user.role == 'super_admin') {
      return await Reservation.db.find(session, orderBy: (t) => t.dateReservation, orderDescending: true);
    }

    if (user.cinemaId != null) {
      // On récupère les IDs des SÉANCES de ce cinéma (et pas seulement les salles)
      final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
      final sIds = salles.map((s) => s.id!).toSet();

      if (sIds.isEmpty) return [];

      final seances = await Seance.db.find(session, where: (t) => t.salleId.inSet(sIds));
      final seanceIds = seances.map((s) => s.id!).toSet();

      if (seanceIds.isEmpty) return [];

      return await Reservation.db.find(session,
          where: (t) => t.seanceId.inSet(seanceIds),
          orderBy: (t) => t.dateReservation,
          orderDescending: true);
    }
    return [];
  }

  Future<void> rembourserReservation(
      Session session, int resId, double amt) async {
    final res = await Reservation.db.findById(session, resId);
    if (res != null) {
      res.statut = 'rembourse';
      res.montantApresReduction = amt;
      await Reservation.db.updateRow(session, res);
    }
  }

  Future<List<Siege>> getSiegesByReservation(Session session, int resId) async {
    final rels = await ReservationSiege.db
        .find(session, where: (t) => t.reservationId.equals(resId));
    final sIds = rels.map((r) => r.siegeId).toSet();
    return sIds.isEmpty ? [] : await Siege.db.find(session, where: (t) => t.id.inSet(sIds));
  }

  Future<double> getTauxRemplissageSeance(Session session, int sId) async {
    final s = await Seance.db.findById(session, sId);
    final salle = await Salle.db.findById(session, s?.salleId ?? 0);
    if (salle == null) return 0.0;
    final count = await Reservation.db.count(session,
        where: (t) =>
            t.seanceId.equals(sId) & t.statut.notEquals('annule'));
    return (count / salle.capacite) * 100;
  }

  // --- SUPPORT ---
  Future<List<DemandeSupport>> getAllDemandesSupport(Session session) async =>
      await DemandeSupport.db
          .find(session, orderBy: (t) => t.createdAt, orderDescending: true);

  Future<void> repondreDemande(Session session, int id, String resp) async {
    final d = await DemandeSupport.db.findById(session, id);
    if (d != null) {
      d.reponse = resp;
      d.statut = 'traité';
      await DemandeSupport.db.updateRow(session, d);
    }
  }

  // --- OPTIONS ---
  Future<List<OptionSupplementaire>> getAllOptions(Session session) async {
    final user = await _getRequiredUser(session);
    if (user.role == 'super_admin') return await OptionSupplementaire.db.find(session);
    return await OptionSupplementaire.db
        .find(session, where: (t) => t.cinemaId.equals(user.cinemaId));
  }

  Future<OptionSupplementaire> ajouterOption(
          Session session, OptionSupplementaire o) async =>
      await OptionSupplementaire.db.insertRow(session, o);
  Future<OptionSupplementaire> modifierOption(
          Session session, OptionSupplementaire o) async =>
      await OptionSupplementaire.db.updateRow(session, o);
  Future<void> supprimerOption(Session session, int id) async =>
      await OptionSupplementaire.db
          .deleteWhere(session, where: (t) => t.id.equals(id));

  // --- PROMOTIONS ---
  Future<List<CodePromo>> getAllCodesPromo(Session session) async =>
      await CodePromo.db.find(session, orderBy: (t) => t.code);
  Future<CodePromo> ajouterCodePromo(Session session, CodePromo cp) async =>
      await CodePromo.db.insertRow(session, cp);
  Future<CodePromo> modifierCodePromo(Session session, CodePromo cp) async =>
      await CodePromo.db.updateRow(session, cp);
  Future<void> supprimerCodePromo(Session session, int id) async =>
      await CodePromo.db.deleteWhere(session, where: (t) => t.id.equals(id));

  Future<Map<String, dynamic>> getCodePromoStats(
      Session session, int id) async {
    final usages = await Reservation.db
        .find(session, where: (t) => t.codePromoId.equals(id));
    return {
      'totalUsages': usages.length,
      'uniqueUsers': usages.map((r) => r.utilisateurId).toSet().length,
      'totalReduction': usages.fold(
          0.0,
          (sum, r) =>
              sum +
              (r.montantTotal -
                  (r.montantApresReduction ?? r.montantTotal))),
      'lastUsage': usages.isEmpty
          ? null
          : usages
              .map((r) => r.dateReservation)
              .reduce((a, b) => a.isAfter(b) ? a : b)
              .toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> getGlobalPromoSummary(Session session) async {
    final promos =
        await CodePromo.db.find(session, where: (t) => t.actif.equals(true));
    return {'activeCodes': promos.length, 'todayUsages': 0, 'totalSavings': 0.0};
  }

  // --- TANGER SPECIFICS ---
  Future<List<Utilisateur>> getStaffTanger(Session session) async =>
      await Utilisateur.db.find(session,
          where: (t) => t.cinemaId.equals(9) & t.role.equals('staff_scanner'));
  Future<void> ajouterStaff(Session session, String nom, String email) async =>
      await Utilisateur.db.insertRow(
          session,
          Utilisateur(
              nom: nom,
              email: email,
              role: 'staff_scanner',
              cinemaId: 9,
              statut: 'actif'));
  Future<void> traiterRemboursement(Session session, int reservationId) async {
    final res = await Reservation.db.findById(session, reservationId);
    if (res != null) {
      res.statut = 'rembourse';
      await Reservation.db.updateRow(session, res);
    }
  }
  // Dans admin_endpoint.dart
  // ✅ Mise à jour de la méthode pour être plus performante et propre
  Future<void> genererSiegesAutomatique(Session session, {
    required int salleId,
    required int nbRangees,
    required int nbColonnes,
  }) async {
    // 1. Supprimer les anciens sièges de cette salle pour éviter les doublons
    await Siege.db.deleteWhere(session, where: (t) => t.salleId.equals(salleId));

    List<Siege> sList = [];
    final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    for (int r = 0; r < nbRangees; r++) {
      String lettreRangee = alphabet[r];
      for (int c = 1; c <= nbColonnes; c++) {
        sList.add(Siege(
          salleId: salleId,
          numero: "$lettreRangee-$c",
          rangee: lettreRangee,
          type: 'standard',
        ));
      }
    }
    // 2. Insertion groupée (beaucoup plus rapide pour le Web)
    await Siege.db.insert(session, sList);
  }

  // --- PROFIL ---
  Future<Utilisateur?> getMonProfil(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final user = await Utilisateur.db.findFirstRow(session,
        where: (t) => t.authUserId.equals(authInfo.userIdentifier));
    if (user != null && user.statut == 'suspendu') {
      throw Exception('ACCOUNT_SUSPENDED');
    }
    return user;
  }
  Future<List<Map<String, dynamic>>> getReservationsDetailed(Session session) async {
    // 1. On récupère d'abord les réservations (en utilisant votre filtrage Tanger déjà existant)
    final reservations = await getAllReservations(session);    List<Map<String, dynamic>> detailedList = [];

    for (var res in reservations) {
      // 2. On va chercher l'utilisateur lié à cette réservation
      final user = await Utilisateur.db.findById(session, res.utilisateurId);

      String filmTitle = "N/A";
      String salleName = "N/A";
      DateTime? seanceDate;

      // 3. On va chercher la séance, puis le film et la salle
      if (res.seanceId != null) {
        final seance = await Seance.db.findById(session, res.seanceId!);
        if (seance != null) {
          seanceDate = seance.dateHeure;

          final film = await Film.db.findById(session, seance.filmId);
          filmTitle = film?.titre ?? "Film inconnu";

          final salle = await Salle.db.findById(session, seance.salleId);
          salleName = salle?.codeSalle ?? "Salle inconnue";
        }
      }

      // 4. On prépare le "paquet" de données pour Flutter
      // On convertit tout en types simples (String, int, DateTime) pour Serverpod
      detailedList.add({
        'reservation': res, // L'objet de base (montant, statut, id)
        'userName': user?.nom ?? "Inconnu",
        'userEmail': user?.email ?? "Non renseigné",
        'userPhone': user?.telephone ?? "Non renseigné",
        'filmTitle': filmTitle,
        'salleName': salleName,
        'seanceDate': seanceDate,
      });
    }

    return detailedList;
  }
}
