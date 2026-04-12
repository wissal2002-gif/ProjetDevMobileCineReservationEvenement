import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';

// ── Compteur global pour forcer le refresh de peutNoterProvider ──
// Incrémenter ce compteur depuis n'importe où dans l'app
// provoque le rechargement de tous les peutNoterProvider actifs.
final peutNoterRefreshProvider = StateProvider<int>((ref) => 0);

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

// ── Vérifier si l'utilisateur peut noter ce film ─────────
// Écoute peutNoterRefreshProvider → se rafraîchit automatiquement
// après chaque réservation confirmée sans reload manuel.
final peutNoterProvider =
FutureProvider.family<bool, int>((ref, filmId) async {
  ref.watch(peutNoterRefreshProvider); // ← réactif
  try {
    return await client.avis.peutNoter(filmId);
  } catch (_) {
    return false;
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
        state = AsyncValue.error('non_reserve', StackTrace.current);
        return false;
      }
      state = AsyncValue.data(avis.note);
      ref.invalidate(monAvisProvider(filmId));
      ref.invalidate(statsFilmProvider(filmId));
      ref.invalidate(peutNoterProvider(filmId));
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