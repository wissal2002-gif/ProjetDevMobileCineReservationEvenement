import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../data/datasources/support_remote_datasource.dart';
import '../../data/repositories/support_repository_impl.dart';

final clientProvider = Provider<Client>((ref) => client);

final supportRepositoryProvider = Provider((ref) {
  return SupportRepositoryImpl(SupportRemoteDataSource(ref.watch(clientProvider)));
});

final mesDemandesProvider = FutureProvider<List<DemandeSupport>>((ref) async {
  return ref.watch(supportRepositoryProvider).recupererMesDemandes();
});

// ── AJOUTER cinemaId ────────────────────────────────────────────────────────
class SupportNotifier extends StateNotifier<AsyncValue<void>> {
  final SupportRepositoryImpl repository;
  SupportNotifier(this.repository) : super(const AsyncData(null));

  Future<void> envoyerMessage(
      String sujet,
      String message, {
        int? cinemaId,        // ← AJOUTER
      }) async {
    state = const AsyncLoading();
    try {
      final nouvelleDemande = DemandeSupport(
        sujet: sujet,
        message: message,
        statut: 'ouvert',
        createdAt: DateTime.now(),
        utilisateurId: 0,
        cinemaId: cinemaId,   // ← AJOUTER
      );
      await repository.creerDemandeSupport(nouvelleDemande);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

final supportActionProvider =
StateNotifierProvider<SupportNotifier, AsyncValue<void>>((ref) {
  return SupportNotifier(ref.watch(supportRepositoryProvider));
});