import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/programmation_provider.dart';
import '../../../profil/presentation/providers/favori_provider.dart';
import '../../../../main.dart';

// ─── Provider films par cinéma ──────────────────────────────────────────────
final filmsByCinemaProvider =
FutureProvider.autoDispose.family<List<Film>, int>((ref, cinemaId) async {
  return await client.films.getFilmsByCinema(cinemaId);
});

// ─── Page liste des cinémas ─────────────────────────────────────────────────
class CinemasPage extends ConsumerWidget {
  const CinemasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2C1810).withOpacity(0.8),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nos Cinémas',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Choisissez votre cinéma',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14)),
                ],
              ),
            ),
          ),

          // Liste cinémas
          cinemasAsync.when(
            data: (cinemas) => SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _cinemaTile(context, ref, cinemas[i]),
                  childCount: cinemas.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child:
                    CircularProgressIndicator(color: AppColors.accent),
                  )),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(
                  child: Text('Erreur: $e',
                      style: const TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cinemaTile(
      BuildContext context, WidgetRef ref, Cinema cinema) {
    final estFavoriAsync =
    ref.watch(estCinemaFavoriProvider(cinema.id!));

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CinemaDetailPage(cinema: cinema),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image cinéma
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    color: AppColors.accent.withOpacity(0.15),
                    child: cinema.photo != null &&
                        cinema.photo!.isNotEmpty
                        ? Image.network(cinema.photo!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 140)
                        : const Center(
                        child: Icon(Icons.movie_filter,
                            color: AppColors.accent, size: 56)),
                  ),
                  // Bouton favori
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
                        await ref
                            .read(favoriCinemaProvider(cinema.id!)
                            .notifier)
                            .toggleCinema(cinema.id!, ref);
                        ref.invalidate(
                            mesCinemasFavorisProvider);
                        ref.invalidate(
                            estCinemaFavoriProvider(cinema.id!));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: estFavoriAsync.when(
                          data: (estFavori) => Icon(
                            estFavori
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: estFavori
                                ? Colors.red
                                : Colors.white,
                            size: 20,
                          ),
                          loading: () => const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white)),
                          error: (_, __) => const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 20),
                        ),
                      ),
                    ),
                  ),
                  // Badge ville
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cinema.ville,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            // Infos
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(cinema.nom,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: AppColors.accent, size: 14),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.location_on,
                        color: AppColors.accent, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(cinema.adresse,
                          style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  if (cinema.telephone != null) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.phone_outlined,
                          color: AppColors.accent, size: 14),
                      const SizedBox(width: 4),
                      Text(cinema.telephone!,
                          style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 13)),
                    ]),
                  ],
                  const SizedBox(height: 12),
                  // Bouton voir programmation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  CinemaDetailPage(cinema: cinema),
                            ),
                          ),
                      icon: const Icon(Icons.movie_outlined,
                          size: 16),
                      label: const Text('Voir la programmation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Page détail cinéma avec programmation ──────────────────────────────────
class CinemaDetailPage extends ConsumerWidget {
  final Cinema cinema;
  const CinemaDetailPage({super.key, required this.cinema});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmsAsync = ref.watch(filmsByCinemaProvider(cinema.id!));
    final estFavoriAsync =
    ref.watch(estCinemaFavoriProvider(cinema.id!));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar avec image
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Bouton favori
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () async {
                    await ref
                        .read(favoriCinemaProvider(cinema.id!)
                        .notifier)
                        .toggleCinema(cinema.id!, ref);
                    ref.invalidate(mesCinemasFavorisProvider);
                    ref.invalidate(
                        estCinemaFavoriProvider(cinema.id!));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: estFavoriAsync.when(
                      data: (estFavori) => Icon(
                        estFavori
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                        estFavori ? Colors.red : Colors.white,
                        size: 26,
                      ),
                      loading: () => const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white)),
                      error: (_, __) => const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 26),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  cinema.photo != null && cinema.photo!.isNotEmpty
                      ? Image.network(cinema.photo!,
                      fit: BoxFit.cover)
                      : Container(
                    color: AppColors.accent.withOpacity(0.2),
                    child: const Center(
                      child: Icon(Icons.movie_filter,
                          color: AppColors.accent, size: 80),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Infos cinéma
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cinema.nom,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.location_on,
                        color: AppColors.accent, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          '${cinema.ville} — ${cinema.adresse}',
                          style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14)),
                    ),
                  ]),
                  if (cinema.telephone != null) ...[
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.phone_outlined,
                          color: AppColors.accent, size: 16),
                      const SizedBox(width: 6),
                      Text(cinema.telephone!,
                          style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14)),
                    ]),
                  ],
                  if (cinema.description != null) ...[
                    const SizedBox(height: 12),
                    Text(cinema.description!,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.5)),
                  ],
                  const SizedBox(height: 24),

                  // Titre programmation
                  const Text('PROGRAMMATION',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 2)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Films
          filmsAsync.when(
            data: (films) {
              if (films.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(children: [
                        const Icon(Icons.movie_outlined,
                            color: Colors.white24, size: 48),
                        const SizedBox(height: 12),
                        const Text(
                            'Aucun film à l\'affiche pour ce cinéma',
                            style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 15),
                            textAlign: TextAlign.center),
                      ]),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                sliver: SliverGrid(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _filmTile(context, films[i]),
                    childCount: films.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(
                        color: AppColors.accent),
                  )),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(
                  child: Text('Erreur: $e',
                      style:
                      const TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filmTile(BuildContext context, Film film) {
    return GestureDetector(
      onTap: () => context.push('/film-detail', extra: film.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: film.affiche != null && film.affiche!.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: film.affiche!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorWidget: (c, u, e) => Container(
                  color: AppColors.cardBg,
                  child: const Icon(Icons.movie,
                      color: Colors.white24, size: 30),
                ),
              )
                  : Container(
                color: AppColors.cardBg,
                child: const Icon(Icons.movie,
                    color: Colors.white24, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(film.titre,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          if (film.genre != null)
            Text(film.genre!,
                style: const TextStyle(
                    color: AppColors.textLight, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}