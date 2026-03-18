import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/admin_sidebar.dart';
import 'package:intl/intl.dart';

class ManageReservationsPage extends ConsumerWidget {
  const ManageReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On utilise le provider détaillé qui contient les jointures (Nom client, Titre Film/Event)
    final detailedResAsync = ref.watch(detailedReservationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("GESTION GLOBALE DES RÉSERVATIONS",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.amber),
                        onPressed: () => ref.invalidate(detailedReservationsProvider),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: detailedResAsync.when(
                      data: (items) {
                        if (items.isEmpty) return const Center(child: Text("Aucune réservation dans le système.", style: TextStyle(color: Colors.white24)));
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) => _buildReservationCard(context, ref, items[index]),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
                      error: (e, _) => Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.redAccent))),
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

  Widget _buildReservationCard(BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    final bool isEvent = item['evenementId'] != null;
    final String title = isEvent ? (item['eventTitle'] ?? "Événement inconnu") : (item['filmTitle'] ?? "Film inconnu");
    final String userName = item['userName'] ?? "Inconnu";
    final String dateStr = item['seanceDate']?.toString() ?? "";
    final String statut = item['statut'] ?? "en_attente";
    final double montant = double.tryParse(item['montantTotal']?.toString() ?? '0') ?? 0.0;

    Color statusColor = Colors.orange;
    if (statut == 'confirme') statusColor = Colors.green;
    if (statut == 'rembourse') statusColor = Colors.blue;
    if (statut == 'annule') statusColor = Colors.redAccent;

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isEvent ? Colors.purple.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
          child: Icon(isEvent ? Icons.stars : Icons.movie, color: isEvent ? Colors.purpleAccent : Colors.blueAccent),
        ),
        title: Text("$userName — $title", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "Date: ${dateStr.isNotEmpty ? DateFormat('dd/MM HH:mm').format(DateTime.parse(dateStr)) : 'N/A'} • $montant DH",
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(statut.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () => _showReservationDetail(context, item),
      ),
    );
  }

  void _showReservationDetail(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("Détails Réservation #${item['resId']}", style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow("Client:", item['userName']),
            _detailRow("Email:", item['userEmail']),
            _detailRow("Téléphone:", item['userPhone']),
            const Divider(color: Colors.white10, height: 20),
            _detailRow("Type:", item['evenementId'] != null ? "ÉVÉNEMENT" : "CINÉMA"),
            _detailRow("Titre:", item['eventTitle'] ?? item['filmTitle']),
            if (item['salleName'] != null) _detailRow("Salle:", item['salleName']),
            if (item['eventVille'] != null) _detailRow("Ville:", item['eventVille']),
            _detailRow("Montant:", "${item['montantTotal']} DH"),
            _detailRow("Statut:", item['statut'].toString().toUpperCase()),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("FERMER")),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(child: Text(value ?? "N/A", style: const TextStyle(color: Colors.white, fontSize: 13))),
        ],
      ),
    );
  }
}
