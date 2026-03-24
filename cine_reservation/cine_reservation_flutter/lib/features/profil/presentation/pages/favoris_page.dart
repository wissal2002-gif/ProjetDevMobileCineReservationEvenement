// lib/features/profil/presentation/pages/favoris_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/favori_provider.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart';

class FavorisPage extends ConsumerWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmIdsAsync = ref.watch(mesFilmsFavorisProvider);
    final cinemaIdsAsync = ref.watch(mesCinemasFavorisProvider);
    final filmsAsync = ref.watch(filmsProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Mes Favoris',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Films favoris ───────────────────────────
            _sectionHeader(Icons.movie_outlined, 'Films favoris'),
            const SizedBox(height: 12),
            filmIdsAsync.when(
              data: (filmIds) => filmsAsync.when(
                data: (tousFilms) {
                  final favoris = tousFilms
                      .where((f) => f.id != null && filmIds.contains(f.id))
                      .toList();
                  if (favoris.isEmpty) {
                    return _empty('Aucun film en favori',
                        "Appuyez sur ♡ sur la page d'un film");
                  }
                  return _filmGrid(context, ref, favoris);
                },
                loading: () => _loading(),
                error: (_, __) => _erreur(),
              ),
              loading: () => _loading(),
              error: (_, __) => _erreur(),
            ),

            const SizedBox(height: 32),

            // ─── Cinémas favoris ─────────────────────────
            _sectionHeader(
                Icons.movie_filter_outlined, 'Cinémas favoris'),
            const SizedBox(height: 12),
            cinemaIdsAsync.when(
              data: (cinemaIds) => cinemasAsync.when(
                data: (tousCinemas) {
                  final favoris = tousCinemas
                      .where(
                          (c) => c.id != null && cinemaIds.contains(c.id))
                      .toList();
                  if (favoris.isEmpty) {
                    return _empty('Aucun cinéma en favori',
                        "Appuyez sur ♡ sur la page d'un cinéma");
                  }
                  return _cinemaList(context, ref, favoris);
                },
                loading: () => _loading(),
                error: (_, __) => _erreur(),
              ),
              loading: () => _loading(),
              error: (_, __) => _erreur(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _filmGrid(
      BuildContext context, WidgetRef ref, List<Film> films) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: films.length,
      itemBuilder: (ctx, i) => _filmTile(context, ref, films[i]),
    );
  }

  Widget _filmTile(BuildContext context, WidgetRef ref, Film film) {
    return GestureDetector(
      onTap: () => context.push('/film-detail', extra: film.id),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: film.affiche ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorWidget: (c, u, e) => Container(
                color: AppColors.cardBg,
                child: const Icon(Icons.movie,
                    color: Colors.white24, size: 30),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () async {
                await ref
                    .read(favoriFilmProvider(film.id!).notifier)
                    .toggleFilm(film.id!, ref);
                ref.invalidate(mesFilmsFavorisProvider);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.favorite,
                    color: Colors.red, size: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8)
                  ],
                ),
              ),
              child: Text(film.titre,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cinemaList(
      BuildContext context, WidgetRef ref, List<Cinema> cinemas) {
    return Column(
      children: cinemas.map((c) => _cinemaTile(context, ref, c)).toList(),
    );
  }

  Widget _cinemaTile(
      BuildContext context, WidgetRef ref, Cinema cinema) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.movie_filter,
                color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cinema.nom,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text('${cinema.ville} — ${cinema.adresse}',
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await ref
                  .read(favoriCinemaProvider(cinema.id!).notifier)
                  .toggleCinema(cinema.id!, ref);
              ref.invalidate(mesCinemasFavorisProvider);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.favorite,
                  color: Colors.red, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(children: [
      Icon(icon, color: AppColors.accent, size: 20),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _empty(String titre, String sousTitre) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: [
        const Icon(Icons.favorite_border,
            color: Colors.white24, size: 36),
        const SizedBox(height: 8),
        Text(titre,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(sousTitre,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textLight, fontSize: 12)),
      ]),
    );
  }

  Widget _loading() => const Center(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: AppColors.accent)));

  Widget _erreur() => const Center(
      child: Text('Erreur de chargement',
          style: TextStyle(color: Colors.white54)));
}