import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';

class TangerDashboardPage extends ConsumerStatefulWidget {
  const TangerDashboardPage({super.key});

  @override
  ConsumerState<TangerDashboardPage> createState() => _TangerDashboardPageState();
}

class _TangerDashboardPageState extends ConsumerState<TangerDashboardPage> {
  static const int tangerCinemaId = 9;

  @override
  Widget build(BuildContext context) {
    final filmsAsync        = ref.watch(allFilmsProvider);
    final seancesAsync      = ref.watch(allSeancesProvider);
    final sallesAsync       = ref.watch(allSallesProvider);
    final reservationsAsync = ref.watch(allReservationsProvider);
    final supportAsync      = ref.watch(allDemandesSupportProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          const TangerSidebar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 36),
                  _buildStatCards(filmsAsync, seancesAsync, sallesAsync, reservationsAsync),
                  const SizedBox(height: 28),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      flex: 3,
                      child: seancesAsync.when(
                        data: (seances) {
                          final films = filmsAsync.value ?? [];
                          final salles = sallesAsync.value ?? [];
                          final now = DateTime.now();
                          final today = seances.where((s) =>
                          s.dateHeure.day == now.day &&
                              s.dateHeure.month == now.month &&
                              s.dateHeure.year == now.year).toList();
                          return _buildSeancesCard(today, films, salles);
                        },
                        loading: () => _loadingCard("Séances aujourd'hui"),
                        error: (e, _) => _errorCard("$e"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: supportAsync.when(
                        data: (support) => _buildAlertsCard(support),
                        loading: () => _loadingCard("Alertes"),
                        error: (e, _) => _errorCard("$e"),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 28),
                  reservationsAsync.when(
                    data: (res) => _buildRevenusChart(res),
                    loading: () => _loadingCard("Revenus"),
                    error: (e, _) => _errorCard("$e"),
                  ),
                  const SizedBox(height: 28),
                  reservationsAsync.when(
                    data: (res) => _buildLastReservations(res),
                    loading: () => _loadingCard("Réservations"),
                    error: (e, _) => _errorCard("$e"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("PANEL DE GESTION TANGER",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
              color: const Color(0xFF8B7355).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: const Text("📍 MÉGARAMA TANGER — ID: 9",
              style: TextStyle(color: Color(0xFF8B7355), fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ]),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10)),
        child: Row(children: [
          const Icon(Icons.calendar_today, color: Color(0xFF8B7355), size: 16),
          const SizedBox(width: 8),
          Text(DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now()),
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
      ),
    ]);
  }

  Widget _buildStatCards(
      AsyncValue<List<Film>> filmsAsync,
      AsyncValue<List<Seance>> seancesAsync,
      AsyncValue<List<Salle>> sallesAsync,
      AsyncValue<List<Reservation>> reservationsAsync,
      ) {
    final films        = filmsAsync.value ?? [];
    final salles       = (sallesAsync.value ?? [])
        .where((s) => s.cinemaId == tangerCinemaId).toList();
    final salleIds     = salles.map((s) => s.id).toSet();
    final seances      = (seancesAsync.value ?? [])
        .where((s) => salleIds.contains(s.salleId)).toList();
    final reservations = reservationsAsync.value ?? [];
    final revenu       = reservations
        .where((r) => r.statut == 'confirme')
        .fold<double>(0, (sum, r) => sum + r.montantTotal);

    return Row(children: [
      Expanded(child: _statCard("FILMS", "${films.length}", Icons.movie_filter_rounded,
          Colors.blueAccent, "/admin/tanger/films")),
      const SizedBox(width: 14),
      Expanded(child: _statCard("SÉANCES", "${seances.length}", Icons.schedule_rounded,
          Colors.orangeAccent, "/admin/tanger/seances")),
      const SizedBox(width: 14),
      Expanded(child: _statCard("RÉSERVATIONS", "${reservations.length}",
          Icons.confirmation_number_rounded, Colors.greenAccent, "/admin/tanger/reservations")),
      const SizedBox(width: 14),
      Expanded(child: _statCard("SALLES", "${salles.length}", Icons.meeting_room_rounded,
          Colors.purpleAccent, "/admin/tanger/salles")),
      const SizedBox(width: 14),
      Expanded(child: _statCard("REVENUS", "${revenu.toStringAsFixed(0)} DH",
          Icons.account_balance_wallet_rounded, Colors.amber, "/admin/tanger/reservations")),
    ]);
  }

  Widget _statCard(String title, String value, IconData icon, Color color, String route) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.15))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 14),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(title, style: TextStyle(color: Colors.white.withOpacity(0.35),
                fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
          ]),
        ),
      ),
    );
  }

  Widget _buildSeancesCard(List<Seance> seances, List<Film> films, List<Salle> salles) {
    return _block(
      title: "🎬 Séances Aujourd'hui",
      subtitle: "${seances.length} séances programmées",
      headerAction: TextButton(
        onPressed: () => context.push('/admin/tanger/seances'),
        child: const Text("+ Programmer", style: TextStyle(color: Color(0xFF8B7355), fontSize: 12)),
      ),
      child: seances.isEmpty
          ? Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            const Icon(Icons.info_outline, color: Colors.white24, size: 18),
            const SizedBox(width: 8),
            Text("Aucune séance aujourd'hui",
                style: TextStyle(color: Colors.white.withOpacity(0.3))),
          ]))
          : Column(
          children: seances.take(5).map<Widget>((s) {
            final film = films.firstWhere((f) => f.id == s.filmId, orElse: () => Film(titre: "Film inconnu"));
            final salle = salles.firstWhere((sa) => sa.id == s.salleId, orElse: () => Salle(cinemaId: 0, codeSalle: "?", capacite: 0, typeProjection: ""));
            
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.schedule, color: Colors.orange, size: 18),
              ),
              title: Text(film.titre,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: Text("Salle ${salle.codeSalle} • ${s.typeProjection}",
                  style: const TextStyle(color: Colors.white38, fontSize: 11)),
              trailing: Text(DateFormat('HH:mm').format(s.dateHeure),
                  style: const TextStyle(color: Color(0xFF8B7355),
                      fontWeight: FontWeight.bold, fontSize: 14)),
            );
          }).toList()),
    );
  }

  Widget _buildAlertsCard(List<DemandeSupport> support) {
    final pending = support.where((d) => d.statut == 'en_attente').length;
    return _block(
      title: "⚡ Actions Requises",
      child: Column(children: [
        _alertRow(Icons.chat_bubble_outline, "$pending demandes support",
            "En attente", Colors.red, pending > 0, '/admin/support'),
        _alertRow(Icons.movie_filter_outlined, "Programmer séances",
            "Planning du jour", Colors.orange, false, '/admin/tanger/seances'),
        _alertRow(Icons.confirmation_number_outlined, "Voir réservations",
            "Activité récente", Colors.green, false, '/admin/tanger/reservations'),
        _alertRow(Icons.grid_on_outlined, "Gérer sièges",
            "Plan de salle", Colors.blue, false, '/admin/tanger/salles'),
      ]),
    );
  }

  Widget _alertRow(IconData icon, String title, String sub, Color color,
      bool isWarning, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(
              color: isWarning ? Colors.orange : Colors.white,
              fontSize: 13, fontWeight: FontWeight.w600)),
          Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ])),
        GestureDetector(
          onTap: () => context.push(route),
          child: const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 14),
        ),
      ]),
    );
  }

  Widget _buildRevenusChart(List<Reservation> reservations) {
    final now = DateTime.now();
    List<double> revenus = List.filled(7, 0);
    List<String> jours = [];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      jours.add(DateFormat('E', 'fr_FR').format(day));
      final dayRevenu = reservations
          .where((r) =>
      r.dateReservation.day == day.day &&
          r.dateReservation.month == day.month &&
          r.statut != 'annule')
          .fold<double>(0, (sum, r) => sum + r.montantTotal);
      revenus[6 - i] = dayRevenu;
    }

    final total = revenus.fold(0.0, (a, b) => a + b);
    final maxY = revenus.isEmpty ? 100.0
        : (revenus.reduce((a, b) => a > b ? a : b) + 50).clamp(100.0, double.infinity);

    return _block(
      title: "💰 Revenus — 7 derniers jours",
      subtitle: "Total : ${total.toStringAsFixed(0)} DH",
      child: SizedBox(
        height: 200,
        child: BarChart(BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF1A1A1A),
              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                "${rod.toY.toStringAsFixed(0)} DH",
                const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(
                  jours[value.toInt()],
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) => BarChartGroupData(
            x: i,
            barRods: [BarChartRodData(
              toY: revenus[i],
              color: revenus[i] > 0 ? const Color(0xFF8B7355) : Colors.white10,
              width: 22,
              borderRadius: BorderRadius.circular(6),
            )],
          )),
        )),
      ),
    );
  }

  Widget _buildLastReservations(List<Reservation> reservations) {
    final recent = reservations.take(5).toList();
    return _block(
      title: "📋 Dernières Réservations",
      headerAction: TextButton(
        onPressed: () => context.push('/admin/tanger/reservations'),
        child: const Text("Voir toutes →",
            style: TextStyle(color: Color(0xFF8B7355), fontSize: 12)),
      ),
      child: recent.isEmpty
          ? const Text("Aucune réservation", style: TextStyle(color: Colors.white24))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 36,
          columnSpacing: 28,
          columns: const [
            DataColumn(label: Text("ID", style: TextStyle(color: Colors.white38, fontSize: 11))),
            DataColumn(label: Text("MONTANT", style: TextStyle(color: Colors.white38, fontSize: 11))),
            DataColumn(label: Text("STATUT", style: TextStyle(color: Colors.white38, fontSize: 11))),
            DataColumn(label: Text("DATE", style: TextStyle(color: Colors.white38, fontSize: 11))),
          ],
          rows: recent.map<DataRow>((r) {
            Color sc = Colors.orange;
            if (r.statut == 'confirme')  sc = Colors.green;
            if (r.statut == 'annule')    sc = Colors.red;
            if (r.statut == 'rembourse') sc = Colors.blue;
            return DataRow(cells: [
              DataCell(Text("#${r.id}", style: const TextStyle(color: Colors.white54, fontSize: 12))),
              DataCell(Text("${r.montantTotal} DH",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: sc.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text((r.statut ?? 'N/A').toUpperCase(),
                    style: TextStyle(color: sc, fontSize: 10, fontWeight: FontWeight.bold)),
              )),
              DataCell(Text(DateFormat('dd/MM HH:mm').format(r.dateReservation),
                  style: const TextStyle(color: Colors.white38, fontSize: 11))),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _block({required String title, String? subtitle, Widget? headerAction, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            if (subtitle != null)
              Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ]),
          if (headerAction != null) headerAction,
        ]),
        const SizedBox(height: 20),
        child,
      ]),
    );
  }

  Widget _loadingCard(String title) => _block(
      title: title,
      child: const Center(child: CircularProgressIndicator(color: Color(0xFF8B7355))));

  Widget _errorCard(String e) => _block(
      title: "Erreur",
      child: Text(e, style: const TextStyle(color: Colors.redAccent)));
}
