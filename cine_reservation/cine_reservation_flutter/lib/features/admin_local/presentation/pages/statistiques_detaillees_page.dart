import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import '../../../../core/theme/app_theme.dart';

// ── Provider ──────────────────────────────────────────────────────────────────
final statistiquesDetailleesProvider =
FutureProvider<Map<String, dynamic>>((ref) async {
  final jsonStr = await client.admin.getStatistiquesDetaillees();
  return jsonDecode(jsonStr) as Map<String, dynamic>;
});

// ── Page ──────────────────────────────────────────────────────────────────────
class StatistiquesDetailleesPage extends ConsumerStatefulWidget {
  const StatistiquesDetailleesPage({super.key});

  @override
  ConsumerState<StatistiquesDetailleesPage> createState() =>
      _StatistiquesDetailleesPageState();
}

class _StatistiquesDetailleesPageState
    extends ConsumerState<StatistiquesDetailleesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final admin = ref.watch(adminProfileProvider).value;
    final statsAsync = ref.watch(statistiquesDetailleesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (!isMobile) const LocalAdminSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      isMobile ? 16 : 40, isMobile ? 16 : 40,
                      isMobile ? 16 : 40, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STATISTIQUES DÉTAILLÉES",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 18 : 26,
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
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.amber, size: 26),
                        tooltip: "Actualiser",
                        onPressed: () => ref
                            .invalidate(statistiquesDetailleesProvider),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Tabs ─────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.amber.withOpacity(0.4)),
                      ),
                      labelColor: Colors.amber,
                      unselectedLabelColor:
                      Colors.white.withOpacity(0.4),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.chair_rounded, size: 18),
                          text: "SIÈGES",
                        ),
                        Tab(
                          icon: Icon(Icons.movie_rounded, size: 18),
                          text: "FILMS",
                        ),
                        Tab(
                          icon: Icon(Icons.fastfood_rounded, size: 18),
                          text: "OPTIONS",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Content ──────────────────────────────────────────
                Expanded(
                  child: statsAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                          color: Colors.amber),
                    ),
                    error: (e, _) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.redAccent, size: 48),
                          const SizedBox(height: 12),
                          Text("Erreur: $e",
                              style: const TextStyle(
                                  color: Colors.redAccent)),
                        ],
                      ),
                    ),
                    data: (stats) {
                      final statsParSalle = (stats['statsParSalle']
                      as List<dynamic>)
                          .cast<Map<String, dynamic>>();
                      final statsParFilm =
                      (stats['statsParFilm'] as List<dynamic>)
                          .cast<Map<String, dynamic>>();
                      final statsOptions =
                      (stats['statsOptions'] as List<dynamic>)
                          .cast<Map<String, dynamic>>();
                      final dateJour =
                      DateTime.tryParse(stats['dateJour'] ?? '');

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          // ── Tab 1 : Sièges ──────────────────────
                          _buildSiegesTab(
                              statsParSalle, isMobile),

                          // ── Tab 2 : Films ───────────────────────
                          _buildFilmsTab(statsParFilm, isMobile),

                          // ── Tab 3 : Options ─────────────────────
                          _buildOptionsTab(
                              statsOptions, dateJour, isMobile),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 1 : SIÈGES ────────────────────────────────────────────────────────
  Widget _buildSiegesTab(
      List<Map<String, dynamic>> stats, bool isMobile) {
    if (stats.isEmpty) return _emptyState("Aucune salle configurée");

    final totalSieges =
    stats.fold<int>(0, (sum, s) => sum + (s['total'] as int));
    final totalOccupes =
    stats.fold<int>(0, (sum, s) => sum + (s['occupes'] as int));
    final totalLibres = totalSieges - totalOccupes;

    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40, vertical: 8),
      children: [
        // Résumé global
        _buildGlobalCard([
          _miniStat("TOTAL", "$totalSieges",
              Icons.event_seat_rounded, Colors.blue),
          _miniStat("OCCUPÉS", "$totalOccupes",
              Icons.block_rounded, Colors.redAccent),
          _miniStat("LIBRES", "$totalLibres",
              Icons.check_circle_outline, Colors.green),
        ], isMobile),

        const SizedBox(height: 24),

        const Text(
          "DÉTAIL PAR SALLE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),

        ...stats.map((salle) {
          final total = salle['total'] as int;
          final occupes = salle['occupes'] as int;
          final libres = salle['libres'] as int;
          final pct = total > 0 ? occupes / total : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                              Icons.meeting_room_rounded,
                              color: Colors.amber,
                              size: 18),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Salle ${salle['salleName']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${(pct * 100).toStringAsFixed(0)}% occupé",
                      style: TextStyle(
                        color: pct > 0.7
                            ? Colors.redAccent
                            : pct > 0.4
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Barre de remplissage
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor:
                    Colors.white.withOpacity(0.06),
                    valueColor: AlwaysStoppedAnimation(
                      pct > 0.7
                          ? Colors.redAccent
                          : pct > 0.4
                          ? Colors.orange
                          : Colors.green,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    _badge("$total sièges", Colors.blue),
                    const SizedBox(width: 8),
                    _badge("$occupes occupés", Colors.redAccent),
                    const SizedBox(width: 8),
                    _badge("$libres libres", Colors.green),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── TAB 2 : FILMS ─────────────────────────────────────────────────────────
  Widget _buildFilmsTab(
      List<Map<String, dynamic>> stats, bool isMobile) {
    if (stats.isEmpty) {
      return _emptyState("Aucun film dans ce cinéma");
    }

    final totalRes = stats.fold<int>(
        0, (sum, s) => sum + (s['nbReservations'] as int));
    final totalRevenu = stats.fold<double>(
        0.0, (sum, s) => sum + (s['revenu'] as double));

    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40, vertical: 8),
      children: [
        _buildGlobalCard([
          _miniStat("FILMS", "${stats.length}",
              Icons.movie_rounded, Colors.purple),
          _miniStat("RÉSERVATIONS", "$totalRes",
              Icons.confirmation_number_rounded, Colors.blue),
          _miniStat("REVENUS",
              "${totalRevenu.toStringAsFixed(0)} DH",
              Icons.payments_rounded, Colors.amber),
        ], isMobile),

        const SizedBox(height: 24),

        const Text(
          "PERFORMANCE PAR FILM",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),

        ...stats.map((film) {
          final titre = film['filmTitre'] as String? ?? '—';
          final nbSeances = film['nbSeances'] as int;
          final nbRes = film['nbReservations'] as int;
          final revenu = (film['revenu'] as num).toDouble();
          final maxRes = stats
              .map((s) => s['nbReservations'] as int)
              .reduce((a, b) => a > b ? a : b);
          final pct =
          maxRes > 0 ? nbRes / maxRes : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                        Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.movie_rounded,
                          color: Colors.purple, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        titre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${revenu.toStringAsFixed(0)} DH",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor:
                    Colors.white.withOpacity(0.06),
                    valueColor: const AlwaysStoppedAnimation(
                        Colors.purple),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    _badge("$nbSeances séances",
                        Colors.blue),
                    const SizedBox(width: 8),
                    _badge("$nbRes réservations",
                        Colors.purple),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── TAB 3 : OPTIONS ───────────────────────────────────────────────────────
  Widget _buildOptionsTab(List<Map<String, dynamic>> stats,
      DateTime? dateJour, bool isMobile) {
    final dateStr = dateJour != null
        ? DateFormat('dd MMMM yyyy', 'fr').format(dateJour)
        : "aujourd'hui";

    if (stats.isEmpty) {
      return _emptyState(
          "Aucune option consommée aujourd'hui");
    }

    final totalQte = stats.fold<int>(
        0, (sum, s) => sum + (s['quantite'] as int));
    final totalRevenu = stats.fold<double>(
        0.0, (sum, s) => sum + (s['revenu'] as double));

    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40, vertical: 8),
      children: [
        // Date du jour
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.amber.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today_rounded,
                  color: Colors.amber, size: 14),
              const SizedBox(width: 8),
              Text(
                "Consommation du $dateStr",
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildGlobalCard([
          _miniStat("ARTICLES", "$totalQte",
              Icons.fastfood_rounded, Colors.orange),
          _miniStat("REVENUS",
              "${totalRevenu.toStringAsFixed(0)} DH",
              Icons.payments_rounded, Colors.amber),
        ], isMobile),

        const SizedBox(height: 24),

        const Text(
          "DÉTAIL PAR OPTION",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),

        ...stats.map((opt) {
          final nom = opt['nom'] as String? ?? '—';
          final categorie =
              opt['categorie'] as String? ?? 'snack';
          final quantite = opt['quantite'] as int;
          final revenu =
          (opt['revenu'] as num).toDouble();
          final maxQte = stats
              .map((s) => s['quantite'] as int)
              .reduce((a, b) => a > b ? a : b);
          final pct =
          maxQte > 0 ? quantite / maxQte : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange
                            .withOpacity(0.1),
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                      child: Icon(
                          _categorieIcon(categorie),
                          color: Colors.orange,
                          size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            nom,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            categorie.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white
                                  .withOpacity(0.3),
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Text(
                          "×$quantite",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${revenu.toStringAsFixed(0)} DH",
                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor:
                    Colors.white.withOpacity(0.06),
                    valueColor: const AlwaysStoppedAnimation(
                        Colors.orange),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── WIDGETS UTILITAIRES ───────────────────────────────────────────────────

  Widget _buildGlobalCard(
      List<Widget> items, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.white.withOpacity(0.06)),
      ),
      child: isMobile
          ? Wrap(
        spacing: 16,
        runSpacing: 16,
        children: items,
      )
          : Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _miniStat(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart_rounded,
              size: 64,
              color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  IconData _categorieIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'boisson': return Icons.local_drink_rounded;
      case 'combo':   return Icons.lunch_dining_rounded;
      case 'autre':   return Icons.more_horiz_rounded;
      default:        return Icons.fastfood_rounded;
    }
  }
}