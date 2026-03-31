import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/programmation/presentation/providers/programmation_provider.dart';
import '../../../../features/evenements/presentation/providers/evenement_provider.dart';
import '../../../../features/profil/presentation/providers/profil_provider.dart';
import '../../../../features/reservation/presentation/providers/reservation_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

// ── Provider isolé pour la HomePage uniquement ──────────────────────────────
final _homeReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  try {
    return await ref.read(reservationDatasourceProvider).getMesReservations();
  } catch (_) {
    return [];
  }
});

// ── Provider pour les codes promo actifs ─────────────────────────────────────
final _activePromosProvider = FutureProvider<List<CodePromo>>((ref) async {
  try {
    final allPromos = await client.admin.getAllCodesPromo();
    final now = DateTime.now();
    return allPromos.where((p) =>
    p.actif == true &&
        (p.dateExpiration == null || p.dateExpiration!.isAfter(now))
    ).toList();
  } catch (_) {
    return [];
  }
});

class HomePage extends ConsumerStatefulWidget {
  final Function(int)? onNavigate;
  const HomePage({super.key, this.onNavigate});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _searchQuery = '';
  bool _notifVisible = true;
  int _notifIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated) {
        ref.read(profilProvider.notifier).loadProfil();
      }
    });
  }

  String _getNiveau(int points) {
    if (points >= 500) return 'or';
    if (points >= 200) return 'argent';
    return 'bronze';
  }

  Color _getNiveauColor(String niveau) {
    switch (niveau) {
      case 'or': return const Color(0xFFFFD700);
      case 'argent': return const Color(0xFFC0C0C0);
      default: return const Color(0xFFCD7F32);
    }
  }

  List<Map<String, dynamic>> _buildBadgeNotifications(
      String prenom, String niveau, int points) {
    final List<Map<String, dynamic>> notifs = [];

    if (prenom.isNotEmpty) {
      final niveauColor = _getNiveauColor(niveau);
      String message;
      switch (niveau) {
        case 'or':
          message = '🎉 Membre Or ! Profitez de votre code OR15 pour -15% sur toutes vos réservations.';
          break;
        case 'argent':
          message = '⭐ Membre Argent ! Encore ${500 - points} pts pour atteindre le niveau Or.';
          break;
        default:
          message = '🌟 Membre Bronze ! $points pts fidélité. Réservez pour passer au niveau Argent !';
      }
      notifs.add({
        'icon': Icons.workspace_premium,
        'color': niveauColor,
        'titre': 'Niveau $niveau',
        'message': message,
        'id': null,
      });
    }

    return notifs;
  }

  String? _calculerGenrePrefere(List<Seance> seances, List<Film> films) {
    final genreCount = <String, int>{};
    for (final seance in seances) {
      final film = films.where((f) => f.id == seance.filmId).firstOrNull;
      if (film?.genre == null) continue;
      genreCount[film!.genre!] = (genreCount[film.genre!] ?? 0) + 1;
    }
    if (genreCount.isEmpty) return null;
    return genreCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  List<Film> _getRecommandations(List<Film> films, String? genrePrefere, int limit) {
    if (genrePrefere == null) return films.take(limit).toList();
    final recommandations = films.where((f) => f.genre == genrePrefere).toList();
    if (recommandations.length >= limit) return recommandations.take(limit).toList();
    return [...recommandations, ...films.where((f) => f.genre != genrePrefere).take(limit - recommandations.length)];
  }

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(filmsProvider);
    final eventsAsync = ref.watch(evenementsProvider);
    final reservationsAsync = ref.watch(_homeReservationsProvider);
    final promosAsync = ref.watch(_activePromosProvider);
    final authState = ref.watch(authProvider);
    final profilState = ref.watch(profilProvider);

    final user = authState.isAuthenticated ? profilState.utilisateur : null;
    final isLoading = profilState.isLoading && authState.isAuthenticated;

    final prenom = user?.nom.split(' ').first ?? '';
    final points = user?.pointsFidelite ?? 0;
    final niveau = _getNiveau(points);
    final isAuthenticated = authState.isAuthenticated;

    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    final seanceIds = (reservationsAsync.value ?? [])
        .where((r) => r.seanceId != null)
        .map((r) => r.seanceId!)
        .toList();

    final seancesAsync = seanceIds.isNotEmpty
        ? ref.watch(seancesByIdsProvider(seanceIds))
        : const AsyncValue<List<Seance>>.data([]);

    final notifications = _buildBadgeNotifications(prenom, niveau, points);
    final notifIdx = _notifIndex % (notifications.isEmpty ? 1 : notifications.length);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'home_support_fab',
        backgroundColor: AppColors.accent,
        onPressed: () => context.push('/support'),
        icon: const Icon(Icons.help_outline, color: Colors.white),
        label: const Text('Aide', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 60, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFF2C1810).withOpacity(0.8), AppColors.background],
                ),
              ),
              child: Column(children: [
                if (user != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bonjour, $prenom 👋', style: const TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getNiveauColor(niveau).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _getNiveauColor(niveau)),
                        ),
                        child: Text(
                          niveau.toUpperCase(),
                          style: TextStyle(color: _getNiveauColor(niveau), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                const Text(
                  'Réservez vos billets de cinéma en ligne',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, height: 1.1),
                ),
                const SizedBox(height: 40),
                _buildSearchBar(),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => context.push('/faq'),
                  icon: const Icon(Icons.help_center_outlined, color: AppColors.accent),
                  label: const Text("Une question ? Consultez notre FAQ", style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline)),
                ),
              ]),
            ),
          ),

          if (_notifVisible && notifications.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildNotifBanner(notifications, notifIdx),
            ),

          SliverToBoxAdapter(child: _sectionHeader("Films à l'affiche", () => widget.onNavigate?.call(1))),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: filmsAsync.when(
                data: (films) {
                  final filtered = _filtrerFilms(films);
                  if (filtered.isEmpty) return _noResult();
                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) => _filmCard(ctx, filtered[i]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (_, __) => const Center(child: Text('Erreur de chargement des films')),
              ),
            ),
          ),

          if (isAuthenticated)
            SliverToBoxAdapter(
              child: filmsAsync.when(
                data: (films) {
                  final seances = seancesAsync.value ?? [];
                  final genrePrefere = _calculerGenrePrefere(seances, films);
                  final recommandations = _getRecommandations(films, genrePrefere, 6);
                  if (recommandations.isEmpty) return const SizedBox();
                  return _buildRecommandationsSection(recommandations, genrePrefere);
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),

          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _sectionHeader('🎁 Offres spéciales', () {})),
          SliverToBoxAdapter(
            child: promosAsync.when(
              data: (promos) => promos.isEmpty ? const SizedBox() : _buildRealOffres(promos),
              loading: () => const SizedBox(height: 130, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
              error: (_, __) => const SizedBox(),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _sectionHeader("Événements à l'affiche", () => widget.onNavigate?.call(2))),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: eventsAsync.when(
                data: (events) {
                  final cinemas = ref.watch(allCinemasProvider).value ?? [];
                  final filtered = _filtrerEvenements(events, cinemas);
                  if (filtered.isEmpty) return _noResult();
                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) => _eventCard(ctx, filtered[i]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (_, __) => const Center(child: Text('Erreur de chargement des événements')),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildNotifBanner(List<Map<String, dynamic>> notifications, int idx) {
    final n = notifications[idx];
    final color = n['color'] as Color;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(n['icon'] as IconData, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n['titre'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(n['message'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: () => setState(() => _notifVisible = false),
            child: const Icon(Icons.close, color: Colors.white38, size: 16),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _notifIndex = (_notifIndex + 1) % notifications.length),
            child: Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ),
        ]),
      ]),
    );
  }

  Widget _buildRecommandationsSection(List<Film> films, String? genrePrefere) {
    final titre = genrePrefere != null ? '🎯 Pour vous — $genrePrefere' : '⭐ Recommandés pour vous';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(titre, () => widget.onNavigate?.call(1)),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            itemCount: films.length,
            itemBuilder: (ctx, i) => _recommandationCard(ctx, films[i], genrePrefere ?? 'Recommandé'),
          ),
        ),
      ],
    );
  }

  Widget _recommandationCard(BuildContext context, Film film, String genre) {
    return GestureDetector(
      onTap: () => context.push('/film-detail', extra: film.id),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 160,
                  width: 160,
                  child: CachedNetworkImage(
                    imageUrl: film.affiche ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (c, u, e) => Container(color: AppColors.cardBg, child: const Icon(Icons.movie, color: Colors.white24, size: 40)),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.9), borderRadius: BorderRadius.circular(6)),
                  child: Text(genre, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
              const Positioned(top: 8, right: 8, child: Icon(Icons.star, color: Colors.amber, size: 18)),
            ]),
            const SizedBox(height: 6),
            Text(film.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            if ((film.noteMoyenne ?? 0) > 0)
              Row(children: [
                const Icon(Icons.star, color: Colors.amber, size: 11),
                const SizedBox(width: 3),
                Text(film.noteMoyenne!.toStringAsFixed(1), style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRealOffres(List<CodePromo> promos) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: promos.length,
        itemBuilder: (ctx, i) {
          final promo = promos[i];
          final reduction = promo.typeReduction == 'pourcentage' ? '${promo.reduction.toStringAsFixed(0)}%' : '${promo.reduction.toStringAsFixed(0)} MAD';
          final minText = promo.montantMinimum != null && promo.montantMinimum! > 0 ? '${promo.montantMinimum!.toStringAsFixed(0)} MAD min.' : 'Sans minimum';
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text('Code "${promo.code}" ! $reduction de réduction.'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 2),
              ));
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange.withOpacity(0.3), Colors.orange.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.local_offer, color: Colors.orange, size: 18),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text('PROMO', style: TextStyle(color: Colors.orange, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(promo.code, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                  Text('$reduction de réduction', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(minText, style: const TextStyle(color: AppColors.textLight, fontSize: 10)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Film> _filtrerFilms(List<Film> films) {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return films;
    return films.where((f) => f.titre.toLowerCase().contains(q) || (f.genre?.toLowerCase().contains(q) ?? false)).toList();
  }

  List<Evenement> _filtrerEvenements(List<Evenement> events, List<Cinema> cinemas) {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return events;
    return events.where((e) {
      final matchesTitle = e.titre.toLowerCase().contains(q);
      final matchesLieu = (e.ville?.toLowerCase().contains(q) ?? false);
      final dateStr = '${e.dateDebut.day}/${e.dateDebut.month}/${e.dateDebut.year}';
      final matchesDate = dateStr.contains(q);
      bool matchesCinema = false;
      if (e.cinemaId != null) {
        final cinema = cinemas.firstWhere((c) => c.id == e.cinemaId, orElse: () => Cinema(nom: '', ville: '', adresse: ''));
        matchesCinema = cinema.nom.toLowerCase().contains(q);
      }
      return matchesTitle || matchesLieu || matchesDate || matchesCinema;
    }).toList();
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white)),
      child: Row(children: [
        const SizedBox(width: 15),
        const Icon(Icons.search, color: Colors.grey),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(hintText: 'Rechercher par nom ou lieu...', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
          ),
        ),
      ]),
    );
  }

  Widget _noResult() => const Center(child: Text('Aucun résultat', style: TextStyle(color: Colors.white54)));

  Widget _sectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          TextButton(onPressed: onSeeAll, child: const Text('Voir tout', style: TextStyle(color: Colors.white54))),
        ],
      ),
    );
  }

  Widget _filmCard(BuildContext ctx, Film film) {
    return GestureDetector(
      onTap: () => ctx.push('/film-detail', extra: film.id),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(imageUrl: film.affiche ?? '', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(film.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _eventCard(BuildContext ctx, Evenement event) {
    return GestureDetector(
      onTap: () => ctx.push('/event-detail', extra: event.id),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(children: [
            CachedNetworkImage(imageUrl: event.affiche ?? '', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${event.ville} • ${event.prix} MAD', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}