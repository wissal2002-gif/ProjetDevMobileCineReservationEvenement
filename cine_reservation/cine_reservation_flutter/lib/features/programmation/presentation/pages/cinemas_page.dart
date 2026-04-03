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

// ─── Providers ──────────────────────────────────────────────────────────────
final filmsByCinemaProvider =
FutureProvider.autoDispose.family<List<Film>, int>((ref, cinemaId) async {
  return await client.films.getFilmsByCinema(cinemaId);
});

final evenementsByCinemaProvider =
FutureProvider.family<List<Evenement>, int>((ref, cinemaId) async {
  return await client.evenements.getEvenementsByCinema(cinemaId);
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
                    child: CircularProgressIndicator(color: AppColors.accent),
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

  Widget _cinemaTile(BuildContext context, WidgetRef ref, Cinema cinema) {
    final estFavoriAsync = ref.watch(estCinemaFavoriProvider(cinema.id!));

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CinemaDetailPage(cinema: cinema)),
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
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    color: AppColors.accent.withOpacity(0.15),
                    child: cinema.photo != null && cinema.photo!.isNotEmpty
                        ? Image.network(cinema.photo!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 140)
                        : const Center(
                        child: Icon(Icons.movie_filter,
                            color: AppColors.accent, size: 56)),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () async {
                        await ref
                            .read(favoriCinemaProvider(cinema.id!).notifier)
                            .toggleCinema(cinema.id!, ref);
                        ref.invalidate(mesCinemasFavorisProvider);
                        ref.invalidate(estCinemaFavoriProvider(cinema.id!));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20)),
                        child: estFavoriAsync.when(
                          data: (estFavori) => Icon(
                            estFavori ? Icons.favorite : Icons.favorite_border,
                            color: estFavori ? Colors.red : Colors.white,
                            size: 20,
                          ),
                          loading: () => const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white)),
                          error: (_, __) => const Icon(Icons.favorite_border,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20)),
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
                              color: AppColors.textLight, fontSize: 13),
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
                              color: AppColors.textLight, fontSize: 13)),
                    ]),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => CinemaDetailPage(cinema: cinema)),
                      ),
                      icon: const Icon(Icons.movie_outlined, size: 16),
                      label: const Text('Voir la programmation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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

// ─── Page détail cinéma ──────────────────────────────────────────────────────
class CinemaDetailPage extends ConsumerStatefulWidget {
  final Cinema cinema;
  const CinemaDetailPage({super.key, required this.cinema});

  @override
  ConsumerState<CinemaDetailPage> createState() => _CinemaDetailPageState();
}

class _CinemaDetailPageState extends ConsumerState<CinemaDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(filmsByCinemaProvider(widget.cinema.id!));
    final evenementsAsync =
    ref.watch(evenementsByCinemaProvider(widget.cinema.id!));
    final estFavoriAsync =
    ref.watch(estCinemaFavoriProvider(widget.cinema.id!));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () async {
                    await ref
                        .read(favoriCinemaProvider(widget.cinema.id!)
                        .notifier)
                        .toggleCinema(widget.cinema.id!, ref);
                    ref.invalidate(mesCinemasFavorisProvider);
                    ref.invalidate(
                        estCinemaFavoriProvider(widget.cinema.id!));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: estFavoriAsync.when(
                      data: (estFavori) => Icon(
                        estFavori ? Icons.favorite : Icons.favorite_border,
                        color: estFavori ? Colors.red : Colors.white,
                        size: 26,
                      ),
                      loading: () => const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white)),
                      error: (_, __) => const Icon(Icons.favorite_border,
                          color: Colors.white, size: 26),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.cinema.photo != null &&
                      widget.cinema.photo!.isNotEmpty
                      ? Image.network(widget.cinema.photo!, fit: BoxFit.cover)
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
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.cinema.nom,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                            '${widget.cinema.ville} — ${widget.cinema.adresse}',
                            style: const TextStyle(
                                color: AppColors.textLight, fontSize: 12)),
                      ],
                    ),
                  ),
                  // TabBar
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.accent,
                    labelColor: AppColors.accent,
                    unselectedLabelColor: Colors.white54,
                    tabs: const [
                      Tab(icon: Icon(Icons.movie_outlined, size: 18),
                          text: 'Films'),
                      Tab(icon: Icon(Icons.event_outlined, size: 18),
                          text: 'Événements'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── Onglet Films ────────────────────────────────────────────
            filmsAsync.when(
              data: (films) {
                if (films.isEmpty) {
                  return _emptyState(
                      Icons.movie_outlined, 'Aucun film à l\'affiche');
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: films.length,
                  itemBuilder: (ctx, i) => _filmTile(context, films[i]),
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, _) => Center(
                  child: Text('Erreur: $e',
                      style: const TextStyle(color: Colors.red))),
            ),

            // ── Onglet Événements ───────────────────────────────────────
            evenementsAsync.when(
              data: (evenements) {
                if (evenements.isEmpty) {
                  return _emptyState(
                      Icons.event_outlined, 'Aucun événement prévu');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: evenements.length,
                  itemBuilder: (ctx, i) =>
                      _evenementTile(context, evenements[i]),
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, _) => Center(
                  child: Text('Erreur: $e',
                      style: const TextStyle(color: Colors.red))),
            ),
          ],
        ),
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
                        color: Colors.white24, size: 30)),
              )
                  : Container(
                  color: AppColors.cardBg,
                  child: const Icon(Icons.movie,
                      color: Colors.white24, size: 30)),
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

  Widget _evenementTile(BuildContext context, Evenement ev) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    return GestureDetector(
      onTap: () => context.push('/event-detail', extra: ev.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14)),
              child: SizedBox(
                width: 90,
                height: 90,
                child: ev.affiche != null && ev.affiche!.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: ev.affiche!,
                  fit: BoxFit.cover,
                  errorWidget: (c, u, e) => Container(
                      color: AppColors.accent.withOpacity(0.2),
                      child: const Icon(Icons.event,
                          color: AppColors.accent, size: 30)),
                )
                    : Container(
                    color: AppColors.accent.withOpacity(0.2),
                    child: const Icon(Icons.event,
                        color: AppColors.accent, size: 30)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.pink.withOpacity(0.5)),
                      ),
                      child: Text((ev.type ?? 'événement').toUpperCase(),
                          style: const TextStyle(
                              color: Colors.pink,
                              fontSize: 9,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Text(ev.titre,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.calendar_today,
                          color: AppColors.accent, size: 12),
                      const SizedBox(width: 4),
                      Text(dateFmt.format(ev.dateDebut.toLocal()),
                          style: const TextStyle(
                              color: AppColors.textLight, fontSize: 11)),
                    ]),
                    const SizedBox(height: 4),
                    Text('${ev.prix?.toStringAsFixed(0) ?? 0} MAD',
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios,
                  color: AppColors.accent, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white24, size: 56),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(
                  color: AppColors.textLight, fontSize: 15)),
        ],
      ),
    );
  }
}