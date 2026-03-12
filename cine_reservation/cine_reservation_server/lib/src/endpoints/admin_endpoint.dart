import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AdminEndpoint extends Endpoint {
  // ─── GESTION DES FILMS ───
  Future<Film> ajouterFilm(Session session, Film film) async => await Film.db.insertRow(session, film);
  Future<Film> modifierFilm(Session session, Film film) async => await Film.db.updateRow(session, film);
  Future<void> supprimerFilm(Session session, int id) async => await Film.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Film>> getAllFilms(Session session) async => await Film.db.find(session, orderBy: (t) => t.titre);

  // ─── GESTION DES CINÉMAS ───
  Future<Cinema> ajouterCinema(Session session, Cinema cinema) async => await Cinema.db.insertRow(session, cinema);
  Future<Cinema> modifierCinema(Session session, Cinema cinema) async => await Cinema.db.updateRow(session, cinema);
  Future<void> supprimerCinema(Session session, int id) async {
    await Salle.db.deleteWhere(session, where: (t) => t.cinemaId.equals(id));
    await Cinema.db.deleteWhere(session, where: (t) => t.id.equals(id));
  }
  Future<List<Cinema>> getAllCinemas(Session session) async => await Cinema.db.find(session, orderBy: (t) => t.nom);

  // ─── GESTION DES SALLES ───
  Future<Salle> ajouterSalle(Session session, Salle salle) async => await Salle.db.insertRow(session, salle);
  Future<Salle> modifierSalle(Session session, Salle salle) async => await Salle.db.updateRow(session, salle);
  Future<void> supprimerSalle(Session session, int id) async {
    await Siege.db.deleteWhere(session, where: (t) => t.salleId.equals(id));
    await Salle.db.deleteWhere(session, where: (t) => t.id.equals(id));
  }
  Future<List<Salle>> getSallesByCinema(Session session, int cinemaId) async => await Salle.db.find(session, where: (t) => t.cinemaId.equals(cinemaId));
  Future<List<Salle>> getAllSalles(Session session) async => await Salle.db.find(session);

  // ─── GESTION DES SIÈGES ───
  Future<List<Siege>> getSiegesBySalle(Session session, int salleId) async => await Siege.db.find(session, where: (t) => t.salleId.equals(salleId), orderBy: (t) => t.numero);
  Future<Siege> ajouterSiege(Session session, Siege siege) async => await Siege.db.insertRow(session, siege);
  Future<void> supprimerSiege(Session session, int id) async => await Siege.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<void> genererSiegesPourSalle(Session session, int salleId, int nbRangees, int siegesParRangee) async {
    await Siege.db.deleteWhere(session, where: (t) => t.salleId.equals(salleId));
    List<Siege> sieges = [];
    List<String> alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
    for (int r = 0; r < nbRangees; r++) {
      String rangee = alphabet[r];
      for (int s = 1; s <= siegesParRangee; s++) {
        sieges.add(Siege(salleId: salleId, rangee: rangee, numero: "$rangee$s", type: 'standard'));
      }
    }
    await Siege.db.insert(session, sieges);
  }

  // ─── GESTION DES SÉANCES ───
  Future<Seance> ajouterSeance(Session session, Seance seance) async => await Seance.db.insertRow(session, seance);
  Future<Seance> modifierSeance(Session session, Seance seance) async => await Seance.db.updateRow(session, seance);
  Future<void> supprimerSeance(Session session, int id) async => await Seance.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Seance>> getAllSeances(Session session) async => await Seance.db.find(session, orderBy: (t) => t.dateHeure);
  Future<List<Seance>> getSeancesByFilm(Session session, int filmId) async => await Seance.db.find(session, where: (t) => t.filmId.equals(filmId), orderBy: (t) => t.dateHeure);
  Future<List<Seance>> getSeancesByCinema(Session session, int cinemaId) async {
    final salles = await Salle.db.find(session, where: (t) => t.cinemaId.equals(cinemaId));
    final salleIds = salles.map((s) => s.id!).toSet();
    if (salleIds.isEmpty) return [];
    return await Seance.db.find(session, where: (t) => t.salleId.inSet(salleIds), orderBy: (t) => t.dateHeure);
  }

  // ─── GESTION DES UTILISATEURS ───
  Future<List<Utilisateur>> getAllUtilisateurs(Session session) async => await Utilisateur.db.find(session, orderBy: (t) => t.nom);
  Future<Utilisateur> suspendreUtilisateur(Session session, int id) async {
    final u = await Utilisateur.db.findById(session, id);
    if (u != null) { u.statut = 'suspendu'; return await Utilisateur.db.updateRow(session, u); }
    throw Exception("Non trouvé");
  }
  Future<Utilisateur> activerUtilisateur(Session session, int id) async {
    final u = await Utilisateur.db.findById(session, id);
    if (u != null) { u.statut = 'actif'; return await Utilisateur.db.updateRow(session, u); }
    throw Exception("Non trouvé");
  }
  Future<void> supprimerUtilisateur(Session session, int id) async => await Utilisateur.db.deleteWhere(session, where: (t) => t.id.equals(id));
  Future<List<Reservation>> getHistoriqueUtilisateur(Session session, int utilisateurId) async => await Reservation.db.find(session, where: (t) => t.utilisateurId.equals(utilisateurId), orderBy: (t) => t.dateReservation, orderDescending: true);

  Future<Utilisateur?> getMonProfil(Session session) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return null;
    final user = await Utilisateur.db.findFirstRow(session, where: (t) => t.authUserId.equals(authInfo.userIdentifier));
    if (user != null && user.statut?.toLowerCase() == 'suspendu') {
      throw Exception('ACCOUNT_SUSPENDED');
    }
    return user;
  }

  // ─── RÉSERVATIONS ───
  Future<List<Reservation>> getAllReservations(Session session) async => await Reservation.db.find(session, orderBy: (t) => t.dateReservation, orderDescending: true);
  Future<void> rembourserReservation(Session session, int reservationId, double montant) async {
    final res = await Reservation.db.findById(session, reservationId);
    if (res != null) { res.statut = 'rembourse'; res.montantApresReduction = montant; await Reservation.db.updateRow(session, res); }
  }
  Future<double> getTauxRemplissageSeance(Session session, int seanceId) async {
    final seance = await Seance.db.findById(session, seanceId);
    if (seance == null) return 0.0;
    final salle = await Salle.db.findById(session, seance.salleId);
    if (salle == null) return 0.0;
    final count = await Reservation.db.count(session, where: (t) => t.seanceId.equals(seanceId) & t.statut.notEquals('annule'));
    return (count / salle.capacite) * 100;
  }
  Future<List<Siege>> getSiegesByReservation(Session session, int reservationId) async {
    final rels = await ReservationSiege.db.find(session, where: (t) => t.reservationId.equals(reservationId));
    final ids = rels.map((r) => r.siegeId).toSet();
    if (ids.isEmpty) return [];
    return await Siege.db.find(session, where: (t) => t.id.inSet(ids));
  }

  // ─── ÉVÉNEMENTS ───
  Future<List<Evenement>> getAllEvenements(Session session) async => await Evenement.db.find(session, orderBy: (t) => t.dateDebut);
  Future<Evenement> ajouterEvenement(Session session, Evenement evenement) async => await Evenement.db.insertRow(session, evenement);
  Future<Evenement> modifierEvenement(Session session, Evenement evenement) async => await Evenement.db.updateRow(session, evenement);
  Future<void> supprimerEvenement(Session session, int id) async => await Evenement.db.deleteWhere(session, where: (t) => t.id.equals(id));

  // ─── SUPPORT ───
  Future<List<DemandeSupport>> getAllDemandesSupport(Session session) async => await DemandeSupport.db.find(session, orderBy: (t) => t.createdAt, orderDescending: true);
  Future<void> repondreDemande(Session session, int id, String reponse) async {
    final d = await DemandeSupport.db.findById(session, id);
    if (d != null) { d.reponse = reponse; d.statut = 'traité'; d.updatedAt = DateTime.now(); await DemandeSupport.db.updateRow(session, d); }
  }

  // ─── OPTIONS ───
  Future<List<OptionSupplementaire>> getAllOptions(Session session) async => await OptionSupplementaire.db.find(session);
  Future<OptionSupplementaire> ajouterOption(Session session, OptionSupplementaire option) async => await OptionSupplementaire.db.insertRow(session, option);
  Future<OptionSupplementaire> modifierOption(Session session, OptionSupplementaire option) async => await OptionSupplementaire.db.updateRow(session, option);
  Future<void> supprimerOption(Session session, int id) async => await OptionSupplementaire.db.deleteWhere(session, where: (t) => t.id.equals(id));

  // ─── STATISTIQUES ───
  Future<Map<String, int>> getAdminStats(Session session) async {
    return {
      'totalFilms': await Film.db.count(session),
      'totalEvents': await Evenement.db.count(session),
      'totalUsers': await Utilisateur.db.count(session),
      'totalReservations': await Reservation.db.count(session),
    };
  }
}
