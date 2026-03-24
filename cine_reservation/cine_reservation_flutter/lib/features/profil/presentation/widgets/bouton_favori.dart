// lib/features/profil/presentation/widgets/bouton_favori.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/favori_provider.dart';

/// Bouton ♡/♥ pour les films
/// Usage : BoutonFavoriFilm(filmId: film.id!)
class BoutonFavoriFilm extends ConsumerWidget {
  final int filmId;
  final double size;

  const BoutonFavoriFilm({super.key, required this.filmId, this.size = 24});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estFavori = ref.watch(favoriFilmProvider(filmId));
    final estFavoriAsync = ref.watch(estFilmFavoriProvider(filmId));
    final afficher = estFavori || (estFavoriAsync.value ?? false);

    return IconButton(
      icon: Icon(
        afficher ? Icons.favorite : Icons.favorite_border,
        color: afficher ? Colors.red : Colors.white70,
        size: size,
      ),
      onPressed: () async {
        final nouvelEtat = await ref
            .read(favoriFilmProvider(filmId).notifier)
            .toggleFilm(filmId, ref);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(nouvelEtat
                ? 'Film ajouté aux favoris ♥'
                : 'Film retiré des favoris'),
            backgroundColor: nouvelEtat ? Colors.red : AppColors.cardBg,
            duration: const Duration(seconds: 2),
          ));
        }
      },
    );
  }
}

/// Bouton ♡/♥ pour les cinémas
/// Usage : BoutonFavoriCinema(cinemaId: cinema.id!)
class BoutonFavoriCinema extends ConsumerWidget {
  final int cinemaId;
  final double size;

  const BoutonFavoriCinema(
      {super.key, required this.cinemaId, this.size = 24});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estFavori = ref.watch(favoriCinemaProvider(cinemaId));
    final estFavoriAsync = ref.watch(estCinemaFavoriProvider(cinemaId));
    final afficher = estFavori || (estFavoriAsync.value ?? false);

    return IconButton(
      icon: Icon(
        afficher ? Icons.favorite : Icons.favorite_border,
        color: afficher ? Colors.red : Colors.white70,
        size: size,
      ),
      onPressed: () async {
        final nouvelEtat = await ref
            .read(favoriCinemaProvider(cinemaId).notifier)
            .toggleCinema(cinemaId, ref);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(nouvelEtat
                ? 'Cinéma ajouté aux favoris ♥'
                : 'Cinéma retiré des favoris'),
            backgroundColor: nouvelEtat ? Colors.red : AppColors.cardBg,
            duration: const Duration(seconds: 2),
          ));
        }
      },
    );
  }
}