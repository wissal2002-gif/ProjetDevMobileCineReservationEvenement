// lib/features/profil/presentation/providers/favori_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';

// ═══════════════════════════════════════════════════════
// PROVIDERS DE LECTURE
// ═══════════════════════════════════════════════════════

final mesFilmsFavorisProvider = FutureProvider<List<int>>((ref) async {
  try {
    return await client.favori.getMesFilmsFavoris();
  } catch (_) {
    return [];
  }
});

final mesCinemasFavorisProvider = FutureProvider<List<int>>((ref) async {
  try {
    return await client.favori.getMesCinemasFavoris();
  } catch (_) {
    return [];
  }
});

final estFilmFavoriProvider =
FutureProvider.family<bool, int>((ref, filmId) async {
  try {
    return await client.favori.estFilmFavori(filmId);
  } catch (_) {
    return false;
  }
});

final estCinemaFavoriProvider =
FutureProvider.family<bool, int>((ref, cinemaId) async {
  try {
    return await client.favori.estCinemaFavori(cinemaId);
  } catch (_) {
    return false;
  }
});

// ═══════════════════════════════════════════════════════
// NOTIFIER — toggle favori
// Utilise WidgetRef au lieu de Ref pour compatibilité Flutter Riverpod
// ═══════════════════════════════════════════════════════

class FavoriNotifier extends StateNotifier<bool> {
  FavoriNotifier(bool initial) : super(initial);

  Future<bool> toggleFilm(int filmId, WidgetRef ref) async {
    final estFavori = state;
    try {
      if (estFavori) {
        await client.favori.retirerFilm(filmId);
      } else {
        await client.favori.ajouterFilm(filmId);
      }
      state = !estFavori;
      ref.invalidate(mesFilmsFavorisProvider);
      ref.invalidate(estFilmFavoriProvider(filmId));
      return state;
    } catch (_) {
      return estFavori;
    }
  }

  Future<bool> toggleCinema(int cinemaId, WidgetRef ref) async {
    final estFavori = state;
    try {
      if (estFavori) {
        await client.favori.retirerCinema(cinemaId);
      } else {
        await client.favori.ajouterCinema(cinemaId);
      }
      state = !estFavori;
      ref.invalidate(mesCinemasFavorisProvider);
      ref.invalidate(estCinemaFavoriProvider(cinemaId));
      return state;
    } catch (_) {
      return estFavori;
    }
  }
}

final favoriFilmProvider =
StateNotifierProvider.family<FavoriNotifier, bool, int>(
      (ref, filmId) {
    final initial = ref.watch(estFilmFavoriProvider(filmId)).value ?? false;
    return FavoriNotifier(initial);
  },
);

final favoriCinemaProvider =
StateNotifierProvider.family<FavoriNotifier, bool, int>(
      (ref, cinemaId) {
    final initial =
        ref.watch(estCinemaFavoriProvider(cinemaId)).value ?? false;
    return FavoriNotifier(initial);
  },
);