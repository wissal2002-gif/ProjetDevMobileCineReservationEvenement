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

// ── Provider isolé pour la HomePage uniquement ──────────────────────────────
// Absorbe silencieusement les erreurs 401 (visiteur non connecté).
// mesReservationsProvider (utilisé dans MesReservationsPage) reste intact
// et affiche les vraies erreurs.
final _homeReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  try {
    return await ref.read(reservationDatasourceProvider).getMesReservations();
  } catch (_) {
    return []; // 401 ou déconnecté → liste vide, pas de crash
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

  // ═══════════════════════════════════════════════════════
  // HELPERS NIVEAU FIDÉLITÉ
  // ═══════════════════════════════════════════════════════

  String _getNiveau(int points) {
    if (points >= 500) return 'or';
    if (points >= 200) return 'argent';
    return 'bronze';
  }

  // ═══════════════════════════════════════════════════════
  // NOTIFICATIONS PERSONNALISÉES
  // ═══════════════════════════════════════════════════════

  List<Map<String, dynamic>> _buildNotifications(
      String prenom, String niveau, int points) {
    final List<Map<String, dynamic>> notifs = [];

    if (prenom.isNotEmpty) {
      if (niveau == 'or') {
        notifs.add({
          'icon': Icons.emoji_events,
          'color': const Color(0xFFFFD700),
          'titre': '👑 Membre Or — Bonjour $prenom !',
          'message':
          'Vous avez $points pts. Profitez de votre code -15% exclusif ce mois-ci.',
        });
      } else if (niveau == 'argent') {
        notifs.add({
          'icon': Icons.military_tech,
          'color': const Color(0xFFC0C0C0),
          'titre': '🥈 Membre Argent — Bonjour $prenom !',
          'message':
          'Encore ${500 - points} pts pour atteindre le niveau Or !',
        });
      } else {
        notifs.add({
          'icon': Icons.workspace_premium,
          'color': const Color(0xFFCD7F32),
          'titre': 'Bonjour $prenom !',
          'message':
          'Vous avez $points pts fidélité. Réservez pour en gagner plus !',
        });
      }
    }

    notifs.addAll([
      {
        'icon': Icons.local_offer,
        'color': Colors.orange,
        'titre': 'Offre spéciale !',
        'message':
        'Utilisez CINE20 pour -20% sur votre prochaine réservation.',
      },
      {
        'icon': Icons.new_releases,
        'color': Colors.blue,
        'titre': 'Nouveauté',
        'message': "De nouveaux films viennent d'être ajoutés au catalogue !",
      },
      {
        'icon': Icons.stars,
        'color': Colors.amber,
        'titre': 'Programme fidélité',
        'message':
        'Accumulez des points et obtenez des réductions exclusives.',
      },
      {
        'icon': Icons.event,
        'color': Colors.pink,
        'titre': 'Événements à venir',
        'message': 'Découvrez les événements culturels près de chez vous.',
      },
    ]);

    return notifs;
  }

  // ═══════════════════════════════════════════════════════
  // GENRE PRÉFÉRÉ
  // ═══════════════════════════════════════════════════════

  String? _calculerGenrePrefereDe(
      List<Seance> seances, List<Film> films) {
    final genreCount = <String, int>{};
    for (final seance in seances) {
      final film =
          films.where((f) => f.id == seance.filmId).firstOrNull;
      if (film?.genre == null) continue;
      genreCount[film!.genre!] = (genreCount[film.genre!] ?? 0) + 1;
    }
    if (genreCount.isEmpty) return null;
    return genreCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // ═══════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(filmsProvider);
    final eventsAsync = ref.watch(evenementsProvider);

    // ── Provider isolé HomePage — absorbe 401 silencieusement ──
    final reservationsAsync = ref.watch(_homeReservationsProvider);

    final seanceIds = (reservationsAsync.value ?? [])
        .where((r) => r.seanceId != null)
        .map((r) => r.seanceId!)
        .toList();

    final seancesAsync = seanceIds.isNotEmpty
        ? ref.watch(seancesByIdsProvider(seanceIds))
        : const AsyncValue<List<Seance>>.data([]);

    // ── Profil ────────────────────────────────────────────
    final profilState = ref.watch(profilProvider);
    final user = profilState.utilisateur;
    final prenom = user?.nom.split(' ').first ?? '';
    final points = user?.pointsFidelite ?? 0;
    final niveau = _getNiveau(points);

    final notifications = _buildNotifications(prenom, niveau, points);
    final notifIdx = _notifIndex % notifications.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'home_support_fab',
        backgroundColor: const Color(0xFF8B7355),
        onPressed: () => context.push('/support'),
        icon: const Icon(Icons.help_outline, color: Colors.white),
        label: const Text('Aide',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── HERO ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 80, bottom: 60, left: 20, right: 20),
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
              child: Column(children: [
                if (user != null) ...[
                  Text(
                    'Bonjour, $prenom 👋',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                ],
                const Text(
                  'Réservez vos billets de cinéma en ligne',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      height: 1.1),
                ),
                const SizedBox(height: 40),
                _buildSearchBar(),
              ]),
            ),
          ),

          // ─── NOTIFICATION BANNER ─────────────────────────
          if (_notifVisible)
            SliverToBoxAdapter(
              child: _buildNotifBanner(notifications, notifIdx),
            ),

          // ─── FILMS À L'AFFICHE ────────────────────────────
          SliverToBoxAdapter(
            child: _sectionHeader(
                "Films à l'affiche",
                    () => widget.onNavigate?.call(1)),
          ),
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
                    itemBuilder: (ctx, i) =>
                        _filmCard(ctx, filtered[i]),
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.accent)),
                error: (_, __) =>
                const Center(child: Text('Erreur')),
              ),
            ),
          ),

          // ─── RECOMMANDATIONS ─────────────────────────────
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: filmsAsync.when(
              data: (films) {
                final seances = seancesAsync.value ?? [];
                final genrePreference =
                _calculerGenrePrefereDe(seances, films);

                if (genrePreference != null) {
                  final recommandes = films
                      .where((f) => f.genre == genrePreference)
                      .take(6)
                      .toList();
                  if (recommandes.isNotEmpty) {
                    return _buildListeRecommandations(
                      titre: '🎯 Pour vous — $genrePreference',
                      films: recommandes,
                      genre: genrePreference,
                      personnalise: true,
                    );
                  }
                }
                return _buildRecommandationsGlobales(films);
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // ─── OFFRES SPÉCIALES ─────────────────────────────
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
              child: _sectionHeader('🎁 Offres spéciales', () {})),
          SliverToBoxAdapter(child: _buildOffres()),

          // ─── ÉVÉNEMENTS ───────────────────────────────────
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: _sectionHeader("Événements à l'affiche",
                    () => widget.onNavigate?.call(2)),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: eventsAsync.when(
                data: (events) {
                  final cinemas =
                      ref.watch(allCinemasProvider).value ?? [];
                  final filtered =
                  _filtrerEvenements(events, cinemas);
                  if (filtered.isEmpty) return _noResult();
                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) =>
                        _eventCard(ctx, filtered[i]),
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.accent)),
                error: (_, __) =>
                const Center(child: Text('Erreur de chargement')),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // WIDGETS
  // ═══════════════════════════════════════════════════════

  Widget _buildNotifBanner(
      List<Map<String, dynamic>> notifications, int idx) {
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
          decoration: BoxDecoration(
              color: color.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(n['icon'] as IconData, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n['titre'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Text(n['message'] as String,
                  style: const TextStyle(
                      color: AppColors.textLight, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: () => setState(() => _notifVisible = false),
            child: const Icon(Icons.close,
                color: Colors.white38, size: 16),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() =>
            _notifIndex = (_notifIndex + 1) % notifications.length),
            child:
            Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ),
        ]),
      ]),
    );
  }

  Widget _buildListeRecommandations({
    required String titre,
    required List<Film> films,
    required String genre,
    bool personnalise = false,
  }) {
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
            itemBuilder: (ctx, i) => _recommandationCard(
                ctx, films[i], genre,
                personnalise: personnalise),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommandationsGlobales(List<Film> films) {
    if (films.isEmpty) return const SizedBox();
    final genreCount = <String, int>{};
    for (final f in films) {
      if (f.genre != null) {
        genreCount[f.genre!] = (genreCount[f.genre!] ?? 0) + 1;
      }
    }
    if (genreCount.isEmpty) return const SizedBox();
    final topGenre =
        genreCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final recommandes =
    films.where((f) => f.genre == topGenre).take(6).toList();
    if (recommandes.isEmpty) return const SizedBox();
    return _buildListeRecommandations(
      titre: '⭐ Recommandés — $topGenre',
      films: recommandes,
      genre: topGenre,
    );
  }

  Widget _recommandationCard(BuildContext context, Film film, String genre,
      {bool personnalise = false}) {
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
                    errorWidget: (c, u, e) => Container(
                      color: AppColors.cardBg,
                      child: const Icon(Icons.movie,
                          color: Colors.white24, size: 40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    personnalise ? '🎯 $genre' : genre,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.star, color: Colors.amber, size: 18),
              ),
            ]),
            const SizedBox(height: 6),
            Text(film.titre,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if ((film.noteMoyenne ?? 0) > 0)
              Row(children: [
                const Icon(Icons.star, color: Colors.amber, size: 11),
                const SizedBox(width: 3),
                Text(film.noteMoyenne!.toStringAsFixed(1),
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 11)),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildOffres() {
    final offres = [
      {
        'code': 'CINE10',
        'desc': '10% de réduction',
        'color': Colors.blue,
        'icon': Icons.percent,
        'min': '50 MAD min.'
      },
      {
        'code': 'CINE20',
        'desc': '20% de réduction',
        'color': Colors.purple,
        'icon': Icons.percent,
        'min': '100 MAD min.'
      },
      {
        'code': 'REDUC50',
        'desc': '-50 MAD',
        'color': Colors.green,
        'icon': Icons.discount,
        'min': '100 MAD min.'
      },
      {
        'code': 'WELCOME',
        'desc': '15% bienvenue',
        'color': Colors.orange,
        'icon': Icons.celebration,
        'min': 'Sans minimum'
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: offres.length,
        itemBuilder: (ctx, i) {
          final o = offres[i];
          final color = o['color'] as Color;
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text(
                    'Code "${o['code']}" ! Utilisez-le dans votre panier.'),
                backgroundColor: color,
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {}),
              ));
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(o['icon'] as IconData, color: color, size: 18),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('PROMO',
                          style: TextStyle(
                              color: color,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(o['code'] as String,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1)),
                  Text(o['desc'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(o['min'] as String,
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 10)),
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
    return films
        .where((f) =>
    f.titre.toLowerCase().contains(q) ||
        (f.genre?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  List<Evenement> _filtrerEvenements(
      List<Evenement> events, List<Cinema> cinemas) {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return events;
    return events.where((e) {
      final matchesTitle = e.titre.toLowerCase().contains(q);
      final matchesLieu = (e.ville?.toLowerCase().contains(q) ?? false);
      final dateStr =
          '${e.dateDebut.day}/${e.dateDebut.month}/${e.dateDebut.year}';
      final matchesDate = dateStr.contains(q);
      bool matchesCinema = false;
      if (e.cinemaId != null) {
        final cinema = cinemas.firstWhere(
              (c) => c.id == e.cinemaId,
          orElse: () => Cinema(nom: '', ville: '', adresse: ''),
        );
        matchesCinema = cinema.nom.toLowerCase().contains(q);
      }
      return matchesTitle || matchesLieu || matchesDate || matchesCinema;
    }).toList();
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white)),
      child: Row(children: [
        const SizedBox(width: 15),
        const Icon(Icons.search, color: Colors.grey),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              hintText: 'Rechercher par nom ou lieu...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _noResult() => const Center(
      child: Text('Aucun résultat',
          style: TextStyle(color: Colors.white54)));

  Widget _sectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('Voir tout',
                style: TextStyle(color: Colors.white54)),
          ),
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
                child: CachedNetworkImage(
                    imageUrl: film.affiche ?? '',
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(film.titre,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
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
            CachedNetworkImage(
              imageUrl: event.affiche ?? '',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.titre,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text('${event.ville} • ${event.prix} MAD',
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}