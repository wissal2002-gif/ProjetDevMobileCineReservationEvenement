import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
// On importe le client global depuis ton main.dart
import '../../../../main.dart';
import '../../data/datasources/support_remote_datasource.dart';
import '../../data/repositories/support_repository_impl.dart';

// On crée un provider simple qui retourne ton client global
final clientProvider = Provider<Client>((ref) {
  return client; // Utilise la variable 'client' définie dans ton main.dart
});

final supportRepositoryProvider = Provider((ref) {
  final clientInstance = ref.watch(clientProvider);
  return SupportRepositoryImpl(SupportRemoteDataSource(clientInstance));
});

// Provider pour récupérer la liste des demandes
final mesDemandesProvider = FutureProvider<List<DemandeSupport>>((ref) async {
  return ref.watch(supportRepositoryProvider).recupererMesDemandes();
});

// StateNotifier pour gérer l'envoi d'une nouvelle demande
class SupportNotifier extends StateNotifier<AsyncValue<void>> {
  final SupportRepositoryImpl repository;
  SupportNotifier(this.repository) : super(const AsyncData(null));

  Future<void> envoyerMessage(String sujet, String message) async {
    state = const AsyncLoading();
    try {
      final nouvelleDemande = DemandeSupport(
        sujet: sujet,
        message: message,
        statut: 'ouvert',
        createdAt: DateTime.now(),
        utilisateurId: 0, // Sera géré par l'endpoint (authInfo.userId)
      );
      await repository.creerDemandeSupport(nouvelleDemande);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

final supportActionProvider = StateNotifierProvider<SupportNotifier, AsyncValue<void>>((ref) {
  return SupportNotifier(ref.watch(supportRepositoryProvider));
});