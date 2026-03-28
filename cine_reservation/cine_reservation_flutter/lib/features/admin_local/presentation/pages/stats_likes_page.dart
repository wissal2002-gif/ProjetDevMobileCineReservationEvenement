import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import 'dart:convert'; // ✅ ajouter en haut du fichier


// ── Provider ──────────────────────────────────────────────────────────────────
final statsFavorisProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final jsonStr = await client.admin.getStatsFavoris();
  return jsonDecode(jsonStr) as Map<String, dynamic>;
});
// ── Page ──────────────────────────────────────────────────────────────────────
class StatsLikesPage extends ConsumerWidget {
  const StatsLikesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final admin = ref.watch(adminProfileProvider).value;
    final statsAsync = ref.watch(statsFavorisProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (!isMobile) const LocalAdminSidebar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ───────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STATISTIQUES LIKES",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 20 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            admin?.nomCinema ?? "Cinéma",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh,
                            color: Colors.pinkAccent, size: 26),
                        tooltip: "Actualiser",
                        onPressed: () => ref.invalidate(statsFavorisProvider),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Contenu ──────────────────────────────────────────
                  Expanded(
                    child: statsAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: Colors.pinkAccent),
                      ),
                      error: (e, _) => Center(
                        child: Text("Erreur: $e",
                            style:
                            const TextStyle(color: Colors.redAccent)),
                      ),
                      data: (stats) {
                        final totalCinema =
                            stats['totalLikesCinema'] as int? ?? 0;
                        final totalFilms =
                            stats['totalLikesFilms'] as int? ?? 0;
                        final topFilms = (stats['topFilms']
                        as List<dynamic>?) ??
                            [];

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Cards stats ──────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: _statCard(
                                      icon: Icons.business_rounded,
                                      label: "LIKES CINÉMA",
                                      value: "$totalCinema",
                                      color: Colors.pinkAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _statCard(
                                      icon: Icons.movie_rounded,
                                      label: "LIKES FILMS",
                                      value: "$totalFilms",
                                      color: Colors.purpleAccent,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // ── Top films ────────────────────────────
                              const Text(
                                "TOP FILMS LIKÉS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),

                              if (topFilms.isEmpty)
                                Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 40),
                                      Icon(Icons.favorite_border,
                                          size: 60,
                                          color: Colors.white
                                              .withOpacity(0.1)),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Aucun like sur vos films pour l'instant.",
                                        style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.3),
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ...topFilms.asMap().entries.map((entry) {
                                  final rank  = entry.key + 1;
                                  final film  = entry.value as Map;
                                  final titre = film['titre'] as String;
                                  final likes = film['likes'] as int;
                                  final max   = (topFilms.first
                                  as Map)['likes'] as int;
                                  final pct   = max > 0
                                      ? likes / max
                                      : 0.0;

                                  return _filmLikeRow(
                                      rank, titre, likes, pct);
                                }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stat Card ─────────────────────────────────────────────────────────────
  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  // ── Film Like Row ─────────────────────────────────────────────────────────
  Widget _filmLikeRow(int rank, String titre, int likes, double pct) {
    final rankColor = rank == 1
        ? Colors.amber
        : rank == 2
        ? Colors.grey[400]!
        : rank == 3
        ? Colors.brown[300]!
        : Colors.white38;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rang
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "#$rank",
                    style: TextStyle(
                      color: rankColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Titre
              Expanded(
                child: Text(
                  titre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Likes
              Row(
                children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.pinkAccent, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "$likes",
                    style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Barre de progression
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: const AlwaysStoppedAnimation(Colors.pinkAccent),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}