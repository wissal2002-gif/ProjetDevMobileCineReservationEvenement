import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/events_sidebar.dart';
import 'package:intl/intl.dart';

class StatsEventsPage extends ConsumerStatefulWidget {
  const StatsEventsPage({super.key});

  @override
  ConsumerState<StatsEventsPage> createState() => _StatsEventsPageState();
}

class _StatsEventsPageState extends ConsumerState<StatsEventsPage> {
  // ── Filtre principal ──────────────────────────────────────────────────────
  String _filter = 'tous'; // 'tous' | 'cinema' | 'hors_cinema'
  String _filterPeriode = 'tout'; // 'tout' | 'mois' | 'annee'

  @override
  Widget build(BuildContext context) {
    final isMobile     = MediaQuery.of(context).size.width < 768;
    final eventsAsync  = ref.watch(allEvenementsProvider);
    final resAsync     = ref.watch(allReservationsProvider);
    final admin        = ref.watch(adminProfileProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          if (!isMobile) const EventsSidebar(),
          Expanded(
            child: eventsAsync.when(
              data: (events) => resAsync.when(
                data: (reservations) => _buildContent(
                    context, isMobile, events, reservations, admin),
                loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.amber)),
                error: (e, _) => Center(child: Text("Erreur: $e")),
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.amber)),
              error: (e, _) => Center(child: Text("Erreur: $e")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile,
      List<Evenement> allEvents, List<Reservation> allRes, dynamic admin) {

    // ── Filtrage par rôle ──────────────────────────────────────────────────
    // ✅ APRÈS — séparer les deux logiques
    List<Evenement> events = allEvents;
    List<Evenement> eventsCinema = [];
    List<Evenement> eventsHorsCinema = [];

    if (admin?.role == 'resp_evenements' && admin?.cinemaId != null) {
      // Événements dans son cinéma
      eventsCinema = allEvents
          .where((e) => e.cinemaId == admin!.cinemaId)
          .toList();
      // Événements hors cinéma créés par ce resp
      // (ils ont cinemaId == null mais ville du cinéma)
      final cinema = ref.read(allCinemasProvider).value
          ?.firstWhere((c) => c.id == admin!.cinemaId,
          orElse: () => Cinema(nom: '', adresse: '', ville: ''));
      eventsHorsCinema = allEvents
          .where((e) => e.cinemaId == null &&
          e.ville == cinema?.ville)
          .toList();
      events = [...eventsCinema, ...eventsHorsCinema];
    } else {
      eventsCinema    = allEvents.where((e) => e.cinemaId != null).toList();
      eventsHorsCinema = allEvents.where((e) => e.cinemaId == null).toList();
    }

    final enCinema   = eventsCinema.length;
    final horsCinema = eventsHorsCinema.length;

    // ── Filtrage par type lieu ─────────────────────────────────────────────
    List<Evenement> filtered = events;
    if (_filter == 'cinema') {
      filtered = events.where((e) => e.cinemaId != null).toList();
    } else if (_filter == 'hors_cinema') {
      filtered = events.where((e) => e.cinemaId == null).toList();
    }

    // ── Filtrage par période ───────────────────────────────────────────────
    final now = DateTime.now();
    if (_filterPeriode == 'mois') {
      filtered = filtered.where((e) =>
      e.dateDebut.month == now.month && e.dateDebut.year == now.year
      ).toList();
    } else if (_filterPeriode == 'annee') {
      filtered = filtered.where((e) => e.dateDebut.year == now.year).toList();
    }

    // ── Réservations filtrées ─────────────────────────────────────────────
    final filteredIds = filtered.map((e) => e.id).toSet();
    final filteredRes = allRes
        .where((r) => r.evenementId != null && filteredIds.contains(r.evenementId))
        .toList();

    // ── KPIs ──────────────────────────────────────────────────────────────
    final totalEvents   = filtered.length;
    final activeEvents  = filtered.where((e) => e.statut == 'actif').length;
    final totalBillets  = filteredRes.where((r) => r.statut != 'annule').length;
    final totalRevenu   = filteredRes
        .where((r) => r.statut != 'annule')
        .fold(0.0, (sum, r) => sum + r.montantTotal);
    final totalAnnules  = filteredRes.where((r) => r.statut == 'annule').length;
    final tauxAnnulation = filteredRes.isEmpty
        ? 0.0
        : (totalAnnules / filteredRes.length * 100);

    // ── Top événements par billets ────────────────────────────────────────
    final Map<int, int> billetsParEvent = {};
    final Map<int, double> revenuParEvent = {};
    for (final r in filteredRes.where((r) => r.statut != 'annule')) {
      if (r.evenementId != null) {
        billetsParEvent[r.evenementId!] =
            (billetsParEvent[r.evenementId!] ?? 0) + 1;
        revenuParEvent[r.evenementId!] =
            (revenuParEvent[r.evenementId!] ?? 0) + r.montantTotal;
      }
    }
    final topEvents = billetsParEvent.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // ── Revenus par catégorie ─────────────────────────────────────────────
    final Map<String, double> revenuParType = {};
    final Map<String, int> billetsParType = {};
    for (final ev in filtered) {
      final type = ev.type ?? 'autre';
      final res = filteredRes.where((r) =>
      r.evenementId == ev.id && r.statut != 'annule').toList();
      revenuParType[type] = (revenuParType[type] ?? 0) +
          res.fold(0.0, (s, r) => s + r.montantTotal);
      billetsParType[type] = (billetsParType[type] ?? 0) + res.length;
    }

    // ── Split cinéma / hors cinéma ────────────────────────────────────────

    // ✅ APRÈS
    final resCinema = allRes.where((r) {
      final ev = allEvents.firstWhere((e) => e.id == r.evenementId,
          orElse: () => Evenement(titre: '', dateDebut: DateTime.now()));
      return eventsCinema.any((e) => e.id == ev.id) && r.statut != 'annule';
    }).length;

    final resHors = allRes.where((r) {
      final ev = allEvents.firstWhere((e) => e.id == r.evenementId,
          orElse: () => Evenement(titre: '', dateDebut: DateTime.now()));
      return eventsHorsCinema.any((e) => e.id == ev.id) && r.statut != 'annule';
    }).length;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── HEADER ──────────────────────────────────────────────────────
          Text("STATISTIQUES ÉVÉNEMENTS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Vue globale sur tous vos événements",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4), fontSize: 13)),
          const SizedBox(height: 24),

          // ── FILTRES ─────────────────────────────────────────────────────
          _buildFiltres(isMobile),
          const SizedBox(height: 32),

          // ── VUE SPLIT CINÉMA / HORS CINÉMA ──────────────────────────────
          _buildSplitCard(enCinema, horsCinema, resCinema, resHors, isMobile),
          const SizedBox(height: 24),

          // ── KPI CARDS ───────────────────────────────────────────────────
          isMobile
              ? GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _kpi("ÉVÉNEMENTS", "$totalEvents", Icons.event, Colors.blue),
              _kpi("ACTIFS", "$activeEvents", Icons.check_circle_outline, Colors.green),
              _kpi("BILLETS VENDUS", "$totalBillets", Icons.confirmation_number, Colors.amber),
              _kpi("REVENU TOTAL", "${totalRevenu.toStringAsFixed(0)} DH", Icons.payments, Colors.orange),
              _kpi("ANNULATIONS", "$totalAnnules", Icons.cancel_outlined, Colors.red),
              _kpi("TAUX ANNUL.", "${tauxAnnulation.toStringAsFixed(1)}%", Icons.percent, Colors.purple),
            ],
          )
              : Column(children: [
            Row(children: [
              Expanded(child: _kpi("ÉVÉNEMENTS", "$totalEvents", Icons.event, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _kpi("ACTIFS", "$activeEvents", Icons.check_circle_outline, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _kpi("BILLETS VENDUS", "$totalBillets", Icons.confirmation_number, Colors.amber)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _kpi("REVENU TOTAL", "${totalRevenu.toStringAsFixed(0)} DH", Icons.payments, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _kpi("ANNULATIONS", "$totalAnnules", Icons.cancel_outlined, Colors.red)),
              const SizedBox(width: 16),
              Expanded(child: _kpi("TAUX ANNUL.", "${tauxAnnulation.toStringAsFixed(1)}%", Icons.percent, Colors.purple)),
            ]),
          ]),

          const SizedBox(height: 32),

          // ── TOP ÉVÉNEMENTS PAR BILLETS ───────────────────────────────────
          _buildTopEvents(topEvents, filtered, revenuParEvent, isMobile),
          const SizedBox(height: 24),

          // ── REVENUS PAR CATÉGORIE ────────────────────────────────────────
          _buildRevenuParType(revenuParType, billetsParType, isMobile),
          const SizedBox(height: 24),

          // ── LISTE ÉVÉNEMENTS FILTRÉS ─────────────────────────────────────
          _buildListeEvents(filtered, filteredRes, isMobile),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── FILTRES ───────────────────────────────────────────────────────────────

  Widget _buildFiltres(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _filterLabel("TYPE DE LIEU"),
        const SizedBox(height: 8),
        _filterButtons([
          _FilterOption('tous', 'Tous', Icons.apps),
          _FilterOption('cinema', 'Dans Cinéma', Icons.movie),
          _FilterOption('hors_cinema', 'Hors Cinéma', Icons.place),
        ], _filter, (v) => setState(() => _filter = v)),
        const SizedBox(height: 16),
        _filterLabel("PÉRIODE"),
        const SizedBox(height: 8),
        _filterButtons([
          _FilterOption('tout', 'Tout', Icons.all_inclusive),
          _FilterOption('mois', 'Ce mois', Icons.calendar_today),
          _FilterOption('annee', 'Cette année', Icons.calendar_month),
        ], _filterPeriode, (v) => setState(() => _filterPeriode = v)),
      ])
          : Row(children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filterLabel("TYPE DE LIEU"),
            const SizedBox(height: 8),
            _filterButtons([
              _FilterOption('tous', 'Tous', Icons.apps),
              _FilterOption('cinema', 'Dans Cinéma', Icons.movie),
              _FilterOption('hors_cinema', 'Hors Cinéma', Icons.place),
            ], _filter, (v) => setState(() => _filter = v)),
          ],
        )),
        const SizedBox(width: 32),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filterLabel("PÉRIODE"),
            const SizedBox(height: 8),
            _filterButtons([
              _FilterOption('tout', 'Tout', Icons.all_inclusive),
              _FilterOption('mois', 'Ce mois', Icons.calendar_today),
              _FilterOption('annee', 'Cette année', Icons.calendar_month),
            ], _filterPeriode, (v) => setState(() => _filterPeriode = v)),
          ],
        )),
      ]),
    );
  }

  Widget _filterLabel(String text) => Text(text,
      style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1));

  Widget _filterButtons(List<_FilterOption> options, String current,
      Function(String) onSelect) {
    return Wrap(
      spacing: 8,
      children: options.map((o) {
        final isSelected = current == o.value;
        return GestureDetector(
          onTap: () => onSelect(o.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withOpacity(0.2)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.white12,
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(o.icon,
                  size: 14,
                  color: isSelected ? AppColors.accent : Colors.white38),
              const SizedBox(width: 6),
              Text(o.label,
                  style: TextStyle(
                      color: isSelected ? AppColors.accent : Colors.white54,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal)),
            ]),
          ),
        );
      }).toList(),
    );
  }

  // ── SPLIT CINÉMA / HORS CINÉMA ───────────────────────────────────────────

  Widget _buildSplitCard(int enCinema, int horsCinema,
      int resCinema, int resHors, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("VUE D'ENSEMBLE",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          isMobile
              ? Column(children: [
            _splitItem("🎬 Dans Cinéma", enCinema, resCinema, Colors.blue),
            const SizedBox(height: 16),
            _splitItem("🏟️ Hors Cinéma", horsCinema, resHors, Colors.orange),
          ])
              : Row(children: [
            Expanded(child: _splitItem("🎬 Dans Cinéma", enCinema, resCinema, Colors.blue)),
            const SizedBox(width: 16),
            const VerticalDivider(color: Colors.white10, width: 1),
            const SizedBox(width: 16),
            Expanded(child: _splitItem("🏟️ Hors Cinéma", horsCinema, resHors, Colors.orange)),
          ]),
          const SizedBox(height: 20),
          // Barre de progression
          _buildProgressBar(enCinema, horsCinema),
        ],
      ),
    );
  }

  Widget _splitItem(String label, int nbEvents, int nbRes, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(children: [
          _miniStat("Événements", "$nbEvents", color),
          const SizedBox(width: 24),
          _miniStat("Billets vendus", "$nbRes", color),
        ]),
      ]),
    );
  }

  Widget _miniStat(String label, String value, Color color) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value,
          style: TextStyle(
              color: color, fontSize: 22, fontWeight: FontWeight.bold)),
      Text(label,
          style:
          const TextStyle(color: Colors.white38, fontSize: 11)),
    ],
  );

  Widget _buildProgressBar(int cinema, int hors) {
    final total = cinema + hors;
    if (total == 0) return const SizedBox();
    final ratioCinema = cinema / total;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("🎬 ${(ratioCinema * 100).toStringAsFixed(0)}% cinéma",
            style: const TextStyle(color: Colors.blue, fontSize: 11)),
        Text("${((1 - ratioCinema) * 100).toStringAsFixed(0)}% hors cinéma 🏟️",
            style: const TextStyle(color: Colors.orange, fontSize: 11)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(children: [
          Expanded(
            flex: (ratioCinema * 100).round(),
            child: Container(height: 8, color: Colors.blue),
          ),
          Expanded(
            flex: ((1 - ratioCinema) * 100).round(),
            child: Container(height: 8, color: Colors.orange),
          ),
        ]),
      ),
    ]);
  }

  // ── TOP ÉVÉNEMENTS ────────────────────────────────────────────────────────

  Widget _buildTopEvents(List<MapEntry<int, int>> topEvents,
      List<Evenement> events, Map<int, double> revenuParEvent, bool isMobile) {
    final top5 = topEvents.take(5).toList();
    final maxBillets = top5.isEmpty ? 1 : top5.first.value;

    return _section(
      title: "🏆 TOP ÉVÉNEMENTS PAR BILLETS",
      child: top5.isEmpty
          ? const Text("Aucune donnée",
          style: TextStyle(color: Colors.white38))
          : Column(
        children: top5.asMap().entries.map((entry) {
          final rank  = entry.key + 1;
          final item  = entry.value;
          final ev    = events.firstWhere((e) => e.id == item.key,
              orElse: () => Evenement(
                  titre: "Événement #${item.key}",
                  dateDebut: DateTime.now()));
          final revenu = revenuParEvent[item.key] ?? 0.0;
          final ratio  = item.value / maxBillets;
          final isInCinema = ev.cinemaId != null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  // Rang
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: rank == 1
                          ? Colors.amber.withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text("$rank",
                          style: TextStyle(
                              color: rank == 1
                                  ? Colors.amber
                                  : Colors.white38,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Titre + badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(ev.titre,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isInCinema
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isInCinema ? "Cinéma" : "Hors Cinéma",
                              style: TextStyle(
                                  color: isInCinema
                                      ? Colors.blue
                                      : Colors.orange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                        Text(
                          "${ev.ville ?? ''} • ${ev.type?.toUpperCase() ?? ''}",
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text("${item.value} billets",
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    Text("${revenu.toStringAsFixed(0)} DH",
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11)),
                  ]),
                ]),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: ratio,
                  minHeight: 5,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rank == 1 ? Colors.amber : AppColors.accent,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── REVENUS PAR CATÉGORIE ─────────────────────────────────────────────────

  Widget _buildRevenuParType(Map<String, double> revenuParType,
      Map<String, int> billetsParType, bool isMobile) {
    final sorted = revenuParType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxRevenu = sorted.isEmpty ? 1.0 : sorted.first.value;

    final colors = [
      Colors.amber, Colors.blue, Colors.green,
      Colors.purple, Colors.orange, Colors.teal,
      Colors.red, Colors.cyan, Colors.pink,
    ];

    return _section(
      title: "📊 REVENUS PAR CATÉGORIE",
      child: sorted.isEmpty
          ? const Text("Aucune donnée",
          style: TextStyle(color: Colors.white38))
          : Column(
        children: sorted.asMap().entries.map((entry) {
          final i     = entry.key;
          final type  = entry.value.key;
          final rev   = entry.value.value;
          final nb    = billetsParType[type] ?? 0;
          final color = colors[i % colors.length];
          final ratio = rev / maxRevenu;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(type.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ]),
                    Row(children: [
                      Text("$nb billets",
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11)),
                      const SizedBox(width: 12),
                      Text("${rev.toStringAsFixed(0)} DH",
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ]),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── LISTE ÉVÉNEMENTS ─────────────────────────────────────────────────────

  Widget _buildListeEvents(List<Evenement> events,
      List<Reservation> reservations, bool isMobile) {
    return _section(
      title: "📋 LISTE DES ÉVÉNEMENTS FILTRÉS",
      child: events.isEmpty
          ? const Text("Aucun événement pour ces filtres",
          style: TextStyle(color: Colors.white38))
          : Column(
        children: events.map((ev) {
          final resEv = reservations
              .where((r) =>
          r.evenementId == ev.id && r.statut != 'annule')
              .toList();
          final revenu = resEv.fold(0.0, (s, r) => s + r.montantTotal);
          final isInCinema = ev.cinemaId != null;
          final tauxRemplissage = ev.placesTotales != null &&
              ev.placesTotales! > 0
              ? (resEv.length / ev.placesTotales! * 100)
              : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  // Badge type lieu
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isInCinema
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        isInCinema ? Icons.movie : Icons.place,
                        size: 11,
                        color:
                        isInCinema ? Colors.blue : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isInCinema ? "Cinéma" : "Hors Cinéma",
                        style: TextStyle(
                            color: isInCinema
                                ? Colors.blue
                                : Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  // Badge statut
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statutColor(ev.statut)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (ev.statut ?? 'actif').toUpperCase(),
                      style: TextStyle(
                          color: _statutColor(ev.statut),
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('dd/MM/yyyy').format(ev.dateDebut),
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 11),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(ev.titre,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  "${ev.ville ?? ''} ${ev.lieu != null ? '• ${ev.lieu}' : ''} • ${ev.type?.toUpperCase() ?? ''}",
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  _evStat("${resEv.length}", "billets", Colors.amber),
                  const SizedBox(width: 20),
                  _evStat("${revenu.toStringAsFixed(0)} DH",
                      "revenu", Colors.green),
                  const SizedBox(width: 20),
                  _evStat(
                      "${tauxRemplissage.toStringAsFixed(0)}%",
                      "remplissage",
                      tauxRemplissage > 70
                          ? Colors.green
                          : tauxRemplissage > 40
                          ? Colors.orange
                          : Colors.red),
                ]),
                const SizedBox(height: 8),
                // Barre remplissage
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: tauxRemplissage / 100,
                    minHeight: 4,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      tauxRemplissage > 70
                          ? Colors.green
                          : tauxRemplissage > 40
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  Widget _section({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        child,
      ]),
    );
  }

  Widget _kpi(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 10),
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10,
                letterSpacing: 1)),
      ]),
    );
  }

  Widget _evStat(String value, String label, Color color) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14)),
      Text(label,
          style: const TextStyle(color: Colors.white38, fontSize: 10)),
    ],
  );

  Color _statutColor(String? s) {
    switch (s) {
      case 'actif':    return Colors.green;
      case 'complet':  return Colors.blue;
      case 'annule':   return Colors.red;
      case 'inactif':  return Colors.orange;
      default:         return Colors.white38;
    }
  }
}

// ── Modèle option filtre ──────────────────────────────────────────────────────
class _FilterOption {
  final String value;
  final String label;
  final IconData icon;
  const _FilterOption(this.value, this.label, this.icon);
}