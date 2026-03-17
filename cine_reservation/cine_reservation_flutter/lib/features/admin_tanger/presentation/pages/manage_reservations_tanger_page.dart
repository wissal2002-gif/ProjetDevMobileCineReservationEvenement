import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';
import 'package:intl/intl.dart';

class ManageReservationsTangerPage extends ConsumerWidget {
  const ManageReservationsTangerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resAsync = ref.watch(allReservationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          const TangerSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GESTION DES RÉSERVATIONS — TANGER",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Expanded(
                    child: resAsync.when(
                      data: (reservations) {
                        if (reservations.isEmpty) {
                          return const Center(
                              child: Text("Aucune réservation.",
                                  style:
                                  TextStyle(color: Colors.white24)));
                        }
                        return ListView.builder(
                          itemCount: reservations.length,
                          itemBuilder: (context, index) =>
                              _buildReservationTile(
                                  context, ref, reservations[index]),
                        );
                      },
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              color: Colors.amber)),
                      error: (e, _) => Center(
                          child: Text("Erreur: $e",
                              style: const TextStyle(
                                  color: Colors.redAccent))),
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

  Widget _buildReservationTile(
      BuildContext context, WidgetRef ref, Reservation res) {
    final bool isCancelled = res.statut == 'annule';
    final bool isRefunded = res.statut == 'rembourse';

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white10)),
      child: ExpansionTile(
        iconColor: Colors.amber,
        collapsedIconColor: Colors.white54,
        leading: Icon(
          isCancelled
              ? Icons.cancel
              : (isRefunded ? Icons.history : Icons.check_circle),
          color: isCancelled
              ? Colors.orange
              : (isRefunded ? Colors.blue : Colors.green),
        ),
        title: Text("Réservation #${res.id}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${DateFormat('dd/MM/yyyy HH:mm').format(res.dateReservation)} • ${res.montantTotal} DH",
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("DÉTAILS RÉSERVATION",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _rowInfo("ID Réservation:", "#${res.id}"),
                _rowInfo("Montant Total:", "${res.montantTotal} DH"),
                _rowInfo("Statut:", (res.statut ?? 'inconnu').toUpperCase()),

                if (isCancelled) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.currency_exchange, size: 18),
                      label: const Text("PROCÉDER AU REMBOURSEMENT",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () =>
                          _handleRefund(context, ref, res),
                    ),
                  ),
                ],

                if (isRefunded) ...[
                  const SizedBox(height: 10),
                  Text(
                      "Remboursement: ${res.montantApresReduction ?? res.montantTotal} DH",
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold)),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 13))),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13))),
      ]),
    );
  }

  void _handleRefund(
      BuildContext context, WidgetRef ref, Reservation res) {
    final ctrl =
    TextEditingController(text: res.montantTotal.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Confirmer le remboursement",
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              labelText: "Montant à rembourser (DH)",
              labelStyle: TextStyle(color: Colors.white54)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () async {
              await client.admin.rembourserReservation(
                  res.id!, double.parse(ctrl.text));
              ref.invalidate(allReservationsProvider);
              Navigator.pop(ctx);
            },
            child: const Text("VALIDER"),
          )
        ],
      ),
    );
  }
}