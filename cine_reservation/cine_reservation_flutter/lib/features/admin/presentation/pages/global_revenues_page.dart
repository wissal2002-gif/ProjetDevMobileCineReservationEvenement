import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_sidebar.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

class GlobalRevenuesPage extends ConsumerWidget {
  const GlobalRevenuesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resAsync = ref.watch(allReservationsProvider);
    final seancesAsync = ref.watch(allSeancesProvider);
    final sallesAsync = ref.watch(allSallesProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);
    final eventsAsync = ref.watch(allEvenementsProvider);
    final filmsAsync = ref.watch(allFilmsProvider);

    final isLoading = resAsync.isLoading || 
                      seancesAsync.isLoading || 
                      sallesAsync.isLoading || 
                      cinemasAsync.isLoading || 
                      eventsAsync.isLoading ||
                      filmsAsync.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("REVENUS GLOBAUX"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            onPressed: () {
              ref.invalidate(allReservationsProvider);
              ref.invalidate(allSeancesProvider);
              ref.invalidate(allEvenementsProvider);
            },
            tooltip: "Actualiser les données",
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
              : _buildMainContent(
                  resAsync.value ?? [],
                  seancesAsync.value ?? [],
                  sallesAsync.value ?? [],
                  cinemasAsync.value ?? [],
                  eventsAsync.value ?? [],
                  filmsAsync.value ?? [],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    List<Reservation> res, 
    List<Seance> seances, 
    List<Salle> salles, 
    List<Cinema> cinemas, 
    List<Evenement> events,
    List<Film> films
  ) {
    // 1. Calcul Revenu Global
    final totalGlobal = res.fold(0.0, (sum, r) => sum + r.montantTotal);
    final totalCinema = res.where((r) => r.seanceId != null).fold(0.0, (sum, r) => sum + r.montantTotal);
    final totalEvents = res.where((r) => r.evenementId != null).fold(0.0, (sum, r) => sum + r.montantTotal);
    
    // 2. Calcul par Cinéma
    Map<String, double> revParCinema = {};
    for (var c in cinemas) {
      final sallesIds = salles.where((s) => s.cinemaId == c.id).map((s) => s.id).toSet();
      final seancesIds = seances.where((s) => sallesIds.contains(s.salleId)).map((s) => s.id).toSet();
      final total = res.where((r) => r.seanceId != null && seancesIds.contains(r.seanceId)).fold(0.0, (sum, r) => sum + r.montantTotal);
      revParCinema[c.nom] = total;
    }

    // 3. Calcul par Film
    Map<String, double> revParFilm = {};
    for (var f in films) {
      final seancesIds = seances.where((s) => s.filmId == f.id).map((s) => s.id).toSet();
      final total = res.where((r) => r.seanceId != null && seancesIds.contains(r.seanceId)).fold(0.0, (sum, r) => sum + r.montantTotal);
      if (total > 0) revParFilm[f.titre] = total;
    }

    // 4. Calcul par Événement
    Map<String, double> revParEvent = {};
    for (var e in events) {
      final total = res.where((r) => r.evenementId == e.id).fold(0.0, (sum, r) => sum + r.montantTotal);
      if (total > 0) revParEvent[e.titre] = total;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(totalGlobal, totalCinema, totalEvents),
          const SizedBox(height: 40),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildSectionCard("🏢 PAR CINÉMA", revParCinema, Icons.business, Colors.blue)),
              const SizedBox(width: 20),
              Expanded(child: _buildSectionCard("🎭 PAR ÉVÉNEMENT", revParEvent, Icons.stars, Colors.purple)),
            ],
          ),
          
          const SizedBox(height: 40),
          _buildSectionCard("🎬 TOP FILMS (RECETTES)", revParFilm, Icons.movie, Colors.amber),
          
          const SizedBox(height: 40),
          _buildRecentTransactions(res, seances, films, events),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(double total, double cine, double ev) {
    return Row(
      children: [
        _kpiCard("REVENU GLOBAL", "${total.toStringAsFixed(0)} DH", Icons.account_balance_wallet, Colors.amber),
        const SizedBox(width: 16),
        _kpiCard("TOTAL CINÉMAS", "${cine.toStringAsFixed(0)} DH", Icons.movie_filter, Colors.blue),
        const SizedBox(width: 16),
        _kpiCard("TOTAL ÉVÉNEMENTS", "${ev.toStringAsFixed(0)} DH", Icons.event, Colors.purple),
      ],
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 16),
            Text(value, style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Map<String, double> data, IconData icon, Color accentColor) {
    final sortedEntries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final double maxVal = data.isEmpty ? 1.0 : data.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: AppColors.accent, size: 18), const SizedBox(width: 10), Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 24),
          if (data.isEmpty) const Text("Aucune donnée", style: TextStyle(color: Colors.white24, fontSize: 12)),
          ...sortedEntries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    Text("${e.value.toStringAsFixed(0)} DH", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: e.value / maxVal,
                  minHeight: 4,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  color: accentColor.withOpacity(0.5),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List<Reservation> res, List<Seance> seances, List<Film> films, List<Evenement> events) {
    final recent = res.reversed.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("📋 DERNIÈRES TRANSACTIONS", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...recent.map((r) {
            String title = "Inconnu";
            if (r.seanceId != null) {
              final s = seances.firstWhere((s) => s.id == r.seanceId, orElse: () => Seance(filmId: 0, salleId: 0, dateHeure: DateTime.now(), langue: '', typeProjection: '', typeSeance: '', placesDisponibles: 0, prixNormal: 0, prixReduit: 0, prixSenior: 0, prixEnfant: 0));
              final f = films.firstWhere((f) => f.id == s.filmId, orElse: () => Film(titre: "Film #${s.filmId}"));
              title = f.titre;
            } else if (r.evenementId != null) {
              final ev = events.firstWhere((e) => e.id == r.evenementId, orElse: () => Evenement(titre: "Événement #${r.evenementId}", dateDebut: DateTime.now()));
              title = ev.titre;
            }

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(r.seanceId != null ? Icons.movie_outlined : Icons.stars, color: Colors.white24),
              title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              subtitle: Text(DateFormat('dd/MM HH:mm').format(r.dateReservation), style: const TextStyle(color: Colors.white38, fontSize: 12)),
              trailing: Text("${r.montantTotal} DH", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            );
          }).toList(),
        ],
      ),
    );
  }
}
