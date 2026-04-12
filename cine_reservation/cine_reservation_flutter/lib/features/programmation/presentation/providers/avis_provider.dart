// lib/features/programmation/presentation/providers/avis_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';

// ── Note de l'utilisateur connecté pour un film ──────────
final monAvisProvider =
FutureProvider.family<int?, int>((ref, filmId) async {
  try {
    return await client.avis.getMonAvis(filmId);
  } catch (_) {
    return null;
  }
});

// ── Stats (moyenne + total) pour un film ─────────────────
final statsFilmProvider =
FutureProvider.family<Map<String, dynamic>, int>((ref, filmId) async {
  try {
    return await client.avis.getStatsFilm(filmId);
  } catch (_) {
    return {'moyenne': 0.0, 'total': 0};
  }
});

// ── Notifier pour soumettre un avis ──────────────────────
class AvisNotifier extends StateNotifier<AsyncValue<int?>> {
  AvisNotifier() : super(const AsyncValue.data(null));

  Future<bool> soumettre(int filmId, int note, dynamic ref) async {
    state = const AsyncValue.loading();
    try {
      final avis = await client.avis.soumettreAvis(filmId, note);
      if (avis == null) {
        state = AsyncValue.error('Erreur', StackTrace.current);
        return false;
      }
      state = AsyncValue.data(avis.note);
      // Invalider le cache pour forcer le rechargement
      ref.invalidate(monAvisProvider(filmId));
      ref.invalidate(statsFilmProvider(filmId));
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

final avisNotifierProvider =
StateNotifierProvider.family<AvisNotifier, AsyncValue<int?>, int>(
      (ref, filmId) => AvisNotifier(),
);