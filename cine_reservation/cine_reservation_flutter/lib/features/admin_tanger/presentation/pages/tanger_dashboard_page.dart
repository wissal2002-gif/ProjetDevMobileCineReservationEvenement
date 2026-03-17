import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';

class TangerDashboardPage extends ConsumerWidget {
  const TangerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          // Sidebar fixe à gauche avec largeur définie
          const TangerSidebar(),

          Expanded(
            child: statsAsync.when(
              data: (stats) {
                final Map<String, dynamic> data = Map<String, dynamic>.from(stats);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),

                      // Grille de boutons
                      _buildQuickActionsGrid(context, data),

                      const SizedBox(height: 50),

                      // Graphique
                      _buildAnalyticsSection(),
                    ],
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B7355)),
              ),
              error: (e, _) => const Center(
                child: Text("Erreur de chargement des statistiques",
                    style: TextStyle(color: Colors.redAccent)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PANEL DE GESTION TANGER",
          style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF8B7355).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "📍 MÉGARAMA TANGER - ID: 9",
            style: TextStyle(
                color: Color(0xFF8B7355),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, Map<String, dynamic> stats) {
    return Wrap(
      spacing: 25,
      runSpacing: 25,
      children: [
        _adminMenuBtn(
          context,
          title: "FILMS",
          value: "${stats['totalFilms'] ?? 0}",
          icon: Icons.movie_filter_rounded,
          color: Colors.blueAccent,
          route: "/admin/tanger/films",
        ),
        _adminMenuBtn(
          context,
          title: "SÉANCES",
          value: "14",
          icon: Icons.confirmation_number_rounded,
          color: Colors.orangeAccent,
          route: "/admin/tanger/seances",
        ),
        _adminMenuBtn(
          context,
          title: "RÉSERVATIONS",
          value: "${stats['totalReservations'] ?? 0}",
          icon: Icons.payments_rounded,
          color: Colors.greenAccent,
          route: "/admin/tanger/reservations",
        ),
        _adminMenuBtn(
          context,
          title: "SALLES",
          value: "8",
          icon: Icons.meeting_room_rounded,
          color: Colors.purpleAccent,
          route: "/admin/tanger/salles",
        ),
        _adminMenuBtn(
          context,
          title: "STAFF",
          value: "Gestion",
          icon: Icons.people_alt_rounded,
          color: Colors.redAccent,
          route: "/admin/tanger/staff",
        ),
      ],
    );
  }

  Widget _adminMenuBtn(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // ✅ IMPORTANT : Capture le clic sur toute la surface
        onTap: () {
          // ✅ Utilisation de push pour éviter le crash du MouseTracker sur Chrome
          context.push(route);
        },
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ Évite les erreurs de hauteur infinie
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 25),
              Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 5),
              Text(
                  title,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ANALYSE DE FRÉQUENTATION",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 25),
        Container(
          height: 350,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 20,
              barTouchData: BarTouchData(enabled: true),
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                _barGroup(0, 12, const Color(0xFF8B7355)),
                _barGroup(1, 18, Colors.blueAccent),
                _barGroup(2, 10, const Color(0xFF8B7355)),
                _barGroup(3, 15, Colors.orangeAccent),
                _barGroup(4, 17, const Color(0xFF8B7355)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color c) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: c, width: 20, borderRadius: BorderRadius.circular(6))
      ],
    );
  }
}