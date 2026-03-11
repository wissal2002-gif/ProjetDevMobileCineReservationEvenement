import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

// Statistiques pour le Dashboard (Retourne une Map comme attendu par admin_dashboard_page.dart)
final adminStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  return await client.admin.getAdminStats();
});

final allCinemasProvider = FutureProvider<List<Cinema>>((ref) async {
  return await client.admin.getAllCinemas();
});

final sallesProvider = FutureProvider.family<List<Salle>, int>((ref, cinemaId) async {
  return await client.admin.getSallesByCinema(cinemaId);
});

final allSallesProvider = FutureProvider<List<Salle>>((ref) async {
  return await client.admin.getAllSalles();
});

final allSeancesProvider = FutureProvider<List<Seance>>((ref) async {
  return await client.admin.getAllSeances();
});

final allUtilisateursProvider = FutureProvider<List<Utilisateur>>((ref) async {
  return await client.admin.getAllUtilisateurs();
});

final allReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  return await client.admin.getAllReservations();
});

// Provider manquant pour l'historique
final userHistoryProvider = FutureProvider.family<List<Reservation>, int>((ref, userId) async {
  return await client.admin.getHistoriqueUtilisateur(userId);
});

// Provider manquant pour les demandes de support (nom corrigé avec 's')
final allDemandesSupportProvider = FutureProvider<List<DemandeSupport>>((ref) async {
  return await client.admin.getAllDemandesSupport();
});

// Provider manquant pour les sièges d'une réservation
final reservationSiegesProvider = FutureProvider.family<List<Siege>, int>((ref, resId) async {
  return await client.admin.getSiegesByReservation(resId);
});

// Provider pour les événements
final allEvenementsProvider = FutureProvider<List<Evenement>>((ref) async {
  return await client.admin.getAllEvenements();
});

// Provider pour le remplissage
final remplissageSeanceProvider = FutureProvider.family<double, int>((ref, seanceId) async {
  return await client.admin.getTauxRemplissageSeance(seanceId);
});