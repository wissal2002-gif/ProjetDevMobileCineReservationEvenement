import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/admin_sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: statsAsync.when(
              data: (stats) => SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tableau de Bord",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: AppColors.accent),
                          onPressed: () => ref.refresh(adminStatsProvider),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // ─── CARTES STATISTIQUES (Données réelles) ───
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _statCard("FILMS", "${stats['totalFilms'] ?? 0}", Icons.movie, Colors.blue, constraints.maxWidth),
                            _statCard("ÉVÉNEMENTS", "${stats['totalEvents'] ?? 0}", Icons.event, Colors.orange, constraints.maxWidth),
                            _statCard("RÉSERVATIONS", "${stats['totalReservations'] ?? 0}", Icons.confirmation_number, Colors.green, constraints.maxWidth),
                            _statCard("UTILISATEURS", "${stats['totalUsers'] ?? 0}", Icons.people, Colors.purple, constraints.maxWidth),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 50),

                    // ─── DIAGRAMME ───
                    const Text(
                      "Analyse des Ventes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 350,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 20,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => AppColors.cardBg,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.toY.toInt()} ventes',
                                  const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin'];
                                  if (value.toInt() >= months.length) return const Text('');
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      months[value.toInt()],
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withOpacity(0.05),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _makeGroupData(0, 12),
                            _makeGroupData(1, 15),
                            _makeGroupData(2, 8),
                            _makeGroupData(3, 18),
                            _makeGroupData(4, 10),
                            _makeGroupData(5, 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text("Erreur: $err", style: const TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () => ref.refresh(adminStatsProvider),
                      child: const Text("Réessayer"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.accent,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, double maxWidth) {
    double cardWidth = (maxWidth - 60) / 4;
    if (cardWidth < 180) cardWidth = (maxWidth - 40) / 2;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Icon(Icons.trending_up, color: Colors.green, size: 16),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
