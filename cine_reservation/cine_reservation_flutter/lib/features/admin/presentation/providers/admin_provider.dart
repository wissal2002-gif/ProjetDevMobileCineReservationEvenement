import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// --- VÉRIFICATION ADMIN RÉACTIVE ---
final isUserAdminProvider = FutureProvider<bool>((ref) async {
  final authState = ref.watch(authProvider); // Réactif à la connexion
  if (!authState.isAuthenticated) return false;
  
  try {
    final user = await client.admin.getMonProfil();
    if (user == null) return false;
    return user.role == 'super_admin' || user.role == 'admin_local' || user.role == 'resp_evenements' || user.role == 'admin';
  } catch (e) {
    return false;
  }
});

// --- PROFIL ADMIN RÉACTIF ---
final adminProfileProvider = FutureProvider<Utilisateur?>((ref) async {
  final authState = ref.watch(authProvider); // TRÈS IMPORTANT : Force le rechargement après login
  if (!authState.isAuthenticated) return null;
  try {
    return await client.admin.getMonProfil();
  } catch (e) {
    return null;
  }
});

// --- Dashboard ---
final dashboardDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await client.admin.getDashboardData();
});

final adminStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  return await client.admin.getAdminStats();
});

final dashboardActionsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await client.admin.getDashboardActions();
});

// --- Cinémas & Salles ---
final allCinemasProvider = FutureProvider<List<Cinema>>((ref) async {
  return await client.admin.getAllCinemas();
});

final sallesProvider = FutureProvider.family<List<Salle>, int>((ref, cinemaId) async {
  return await client.admin.getSallesByCinema(cinemaId);
});

final allSallesProvider = FutureProvider<List<Salle>>((ref) async {
  return await client.admin.getSalles();
});

final siegesBySalleProvider = FutureProvider.family<List<Siege>, int>((ref, salleId) async {
  return await client.admin.getSiegesBySalle(salleId);
});

// --- Séances & Films ---
final allSeancesProvider = FutureProvider<List<Seance>>((ref) async {
  return await client.admin.getAllSeances();
});

final allFilmsProvider = FutureProvider<List<Film>>((ref) async {
  return await client.admin.getAllFilms();
});

// --- Événements ---
final allEvenementsProvider = FutureProvider<List<Evenement>>((ref) async {
  return await client.admin.getAllEvenements();
});

// --- Utilisateurs & Réservations ---
final allUtilisateursProvider = FutureProvider<List<Utilisateur>>((ref) async {
  return await client.admin.getManagedUsers();
});

final userHistoryProvider = FutureProvider.family<List<Reservation>, int>((ref, userId) async {
  return await client.admin.getHistoriqueUtilisateur(userId);
});

final allReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  return await client.admin.getAllReservations();
});

final detailedReservationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await client.admin.getReservationsDetailed();
});

final reservationSiegesProvider = FutureProvider.family<List<Siege>, int>((ref, resId) async {
  return await client.admin.getSiegesByReservation(resId);
});

final allDemandesSupportProvider = FutureProvider<List<DemandeSupport>>((ref) async {
  return await client.admin.getAllDemandesSupport();
});

// --- OPTIONS & SNACKS ---
final allOptionsProvider = FutureProvider<List<OptionSupplementaire>>((ref) async {
  return await client.admin.getAllOptions();
});

// --- PROMOTIONS ---
final allCodesPromoProvider = FutureProvider<List<CodePromo>>((ref) async {
  return await client.admin.getAllCodesPromo();
});

final codePromoStatsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, id) async {
  return await client.admin.getCodePromoStats(id);
});

final globalPromoSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await client.admin.getGlobalPromoSummary();
});
final staffTangerProvider = FutureProvider<List<Utilisateur>>((ref) async {
  return await client.admin.getStaffTanger();
});
final allClientsProvider = FutureProvider<List<Utilisateur>>((ref) async {
  return await client.admin.getAllClients();
});