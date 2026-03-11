import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// --- Vérification Admin réactive ---
final isUserAdminProvider = FutureProvider<bool>((ref) async {
  // On observe l'état d'authentification pour réagir aux connexions/déconnexions
  final authState = ref.watch(authProvider);
  
  if (!authState.isAuthenticated) return false;

  try {
    final user = await client.admin.getMonProfil();
    // Retourne true si le rôle est admin
    return user?.role == 'admin';
  } catch (e) {
    return false;
  }
});

// --- Statistiques Dashboard ---
final adminStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  try {
    return await client.admin.getAdminStats();
  } catch (e) {
    throw Exception('Erreur statistiques : $e');
  }
});

// --- Cinémas & Salles ---
final allCinemasProvider = FutureProvider<List<Cinema>>((ref) async {
  return await client.admin.getAllCinemas();
});

final sallesProvider = FutureProvider.family<List<Salle>, int>((ref, cinemaId) async {
  return await client.admin.getSallesByCinema(cinemaId);
});

final allSallesProvider = FutureProvider<List<Salle>>((ref) async {
  return await client.admin.getAllSalles();
});

// --- Sièges ---
final siegesBySalleProvider = FutureProvider.family<List<Siege>, int>((ref, salleId) async {
  return await client.admin.getSiegesBySalle(salleId);
});

// --- Films & Séances ---
final allSeancesProvider = FutureProvider<List<Seance>>((ref) async {
  return await client.admin.getAllSeances();
});

final seancesByFilmProvider = FutureProvider.family<List<Seance>, int>((ref, filmId) async {
  return await client.admin.getSeancesByFilm(filmId);
});

final seancesByCinemaProvider = FutureProvider.family<List<Seance>, int>((ref, cinemaId) async {
  return await client.admin.getSeancesByCinema(cinemaId);
});

// --- Utilisateurs ---
final allUtilisateursProvider = FutureProvider<List<Utilisateur>>((ref) async {
  return await client.admin.getAllUtilisateurs();
});

final userHistoryProvider = FutureProvider.family<List<Reservation>, int>((ref, userId) async {
  return await client.admin.getHistoriqueUtilisateur(userId);
});

// --- Réservations & Remplissage ---
final allReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  return await client.admin.getAllReservations();
});

final reservationSiegesProvider = FutureProvider.family<List<Siege>, int>((ref, resId) async {
  return await client.admin.getSiegesByReservation(resId);
});

final remplissageSeanceProvider = FutureProvider.family<double, int>((ref, seanceId) async {
  return await client.admin.getTauxRemplissageSeance(seanceId);
});

// --- Événements ---
final allEvenementsProvider = FutureProvider<List<Evenement>>((ref) async {
  return await client.admin.getAllEvenements();
});

// --- Options & Snacks ---
final allOptionsProvider = FutureProvider<List<OptionSupplementaire>>((ref) async {
  return await client.admin.getAllOptions();
});

// --- Support Client ---
final allDemandesSupportProvider = FutureProvider<List<DemandeSupport>>((ref) async {
  return await client.admin.getAllDemandesSupport();
});
