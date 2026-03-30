import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/events_sidebar.dart';
import 'package:intl/intl.dart';

class RevenuesEventsPage extends ConsumerStatefulWidget {
  const RevenuesEventsPage({super.key});

  @override
  ConsumerState<RevenuesEventsPage> createState() => _RevenuesEventsPageState();
}

class _RevenuesEventsPageState extends ConsumerState<RevenuesEventsPage> {
  String _selectedCity         = "Toutes";
  String _selectedPeriod       = "Tout";
  String _selectedLocationType = "Tous";

  @override
  Widget build(BuildContext context) {
    final isMobile    = MediaQuery.of(context).size.width < 768;
    final resAsync    = ref.watch(allReservationsProvider);
    final eventsAsync = ref.watch(allEvenementsProvider);
    final usersAsync  = ref.watch(allClientsProvider);

    final isLoading = resAsync.isLoading || eventsAsync.isLoading || usersAsync.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          if (!isMobile) SizedBox(width: 280, child: EventsSidebar()),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                : _buildContent(
              context,
              isMobile,
              resAsync.value ?? [],
              eventsAsync.value ?? [],
              usersAsync.value ?? [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile, List<Reservation> allRes, List<Evenement> allEvents, List<Utilisateur> allUsers) {
    List<Reservation> eventRes = allRes.where((r) => r.evenementId != null).toList();

    final cities = ["Toutes", ...allEvents.map((e) => e.ville ?? "Inconnue").toSet()];

    final now = DateTime.now();

    var filteredData = eventRes.map((res) {
      final ev   = allEvents.firstWhere((e) => e.id == res.evenementId, orElse: () => Evenement(titre: "Inconnu", dateDebut: DateTime.now()));
      final user = allUsers.firstWhere((u) => u.id == res.utilisateurId, orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"));
      return {'res': res, 'ev': ev, 'user': user};
    }).toList();

    if (_selectedCity != "Toutes") {
      filteredData = filteredData.where((item) => (item['ev'] as Evenement).ville == _selectedCity).toList();
    }
    if (_selectedPeriod == "Ce mois") {
      filteredData = filteredData.where((item) {
        final date = (item['ev'] as Evenement).dateDebut;
        return date.month == now.month && date.year == now.year;
      }).toList();
    } else if (_selectedPeriod == "Cette année") {
      filteredData = filteredData.where((item) {
        final date = (item['ev'] as Evenement).dateDebut;
        return date.year == now.year;
      }).toList();
    }
    if (_selectedLocationType == "Au Cinéma") {
      filteredData = filteredData.where((item) => (item['ev'] as Evenement).cinemaId != null).toList();
    } else if (_selectedLocationType == "Hors Cinéma") {
      filteredData = filteredData.where((item) => (item['ev'] as Evenement).cinemaId == null).toList();
    }

    final double totalRevenu = filteredData.fold(0.0, (sum, item) => sum + (item['res'] as Reservation).montantTotal);
    final int    totalTickets = filteredData.length;
    final int    nbAnnulees   = filteredData.where((item) => (item['res'] as Reservation).statut == 'annule').length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 32),

          _buildFilterBar(cities, isMobile),
          const SizedBox(height: 32),

          // ─── KPI cards ───
          isMobile
              ? GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _kpiCard("REVENU FILTRÉ", "${totalRevenu.toStringAsFixed(0)} DH", Icons.account_balance_wallet, Colors.amber),
              _kpiCard("BILLETS",       "$totalTickets",                        Icons.confirmation_number,    Colors.blue),
              _kpiCard("ANNULATIONS",   "$nbAnnulees",                          Icons.cancel,                 Colors.orange),
            ],
          )
              : Row(children: [
            Expanded(child: _kpiCard("REVENU FILTRÉ", "${totalRevenu.toStringAsFixed(0)} DH", Icons.account_balance_wallet, Colors.amber)),
            const SizedBox(width: 16),
            Expanded(child: _kpiCard("BILLETS",       "$totalTickets",  Icons.confirmation_number, Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: _kpiCard("ANNULATIONS",   "$nbAnnulees",    Icons.cancel,              Colors.orange)),
          ]),

          const SizedBox(height: 40),
          _buildTypeChart(filteredData),
          const SizedBox(height: 40),
          _buildTransactionList(filteredData),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ANALYSE FINANCIÈRE DES ÉVÉNEMENTS",
            style: TextStyle(color: Colors.white, fontSize: isMobile ? 20 : 28, fontWeight: FontWeight.bold)),
        Text("Filtrez vos revenus par ville, période ou type de lieu",
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
      ],
    );
  }

  Widget _buildFilterBar(List<String> cities, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      // ─── Column sur mobile, Row sur desktop ───
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _filterDropdown("VILLE",    _selectedCity,         cities,                                          (val) => setState(() => _selectedCity         = val!)),
        const SizedBox(height: 16),
        _filterDropdown("PÉRIODE",  _selectedPeriod,       ["Tout", "Ce mois", "Cette année"],             (val) => setState(() => _selectedPeriod       = val!)),
        const SizedBox(height: 16),
        _filterDropdown("LIEU",     _selectedLocationType, ["Tous", "Au Cinéma", "Hors Cinéma"],           (val) => setState(() => _selectedLocationType = val!)),
      ])
          : Row(children: [
        _filterDropdown("VILLE",    _selectedCity,         cities,                                          (val) => setState(() => _selectedCity         = val!)),
        const SizedBox(width: 20),
        _filterDropdown("PÉRIODE",  _selectedPeriod,       ["Tout", "Ce mois", "Cette année"],             (val) => setState(() => _selectedPeriod       = val!)),
        const SizedBox(width: 20),
        _filterDropdown("LIEU",     _selectedLocationType, ["Tous", "Au Cinéma", "Hors Cinéma"],           (val) => setState(() => _selectedLocationType = val!)),
      ]),
    );
  }

  Widget _filterDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF1A1A1A),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          underline: const SizedBox(),
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        ),
      ],
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11, letterSpacing: 1.1)),
      ]),
    );
  }

  Widget _buildTypeChart(List<Map<String, dynamic>> filteredData) {
    final Map<String, double> revParType = {};
    for (var item in filteredData) {
      final ev  = item['ev']  as Evenement;
      final res = item['res'] as Reservation;
      final type = ev.type ?? 'autre';
      revParType[type] = (revParType[type] ?? 0) + res.montantTotal;
    }

    final double max = revParType.values.isEmpty ? 1 : revParType.values.reduce((a, b) => a > b ? a : b);

    return _cardContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("📊 RÉPARTITION PAR TYPE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ...revParType.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(e.key.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 13)),
              Text("${e.value.toStringAsFixed(0)} DH", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: e.value / max, minHeight: 6, backgroundColor: Colors.white10, color: Colors.amber),
          ]),
        )).toList(),
      ]),
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> filteredData) {
    return _cardContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("📋 TRANSACTIONS FILTRÉES", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final item = filteredData[index];
            final res  = item['res']  as Reservation;
            final ev   = item['ev']   as Evenement;
            final user = item['user'] as Utilisateur;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(ev.titre, style: const TextStyle(color: Colors.white, fontSize: 14)),
              subtitle: Text("${user.nom} • ${DateFormat('dd/MM').format(res.dateReservation)}", style: const TextStyle(color: Colors.white38, fontSize: 12)),
              trailing: Text("${res.montantTotal} DH", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            );
          },
        ),
      ]),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: child,
    );
  }
}