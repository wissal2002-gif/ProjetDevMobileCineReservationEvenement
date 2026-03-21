import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/events_sidebar.dart';
import 'package:intl/intl.dart';

class ManageReservationsEventsPage extends ConsumerWidget {
  const ManageReservationsEventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resAsync = ref.watch(allReservationsProvider);
    final eventsAsync = ref.watch(allEvenementsProvider);
    final usersAsync = ref.watch(allClientsProvider);

    final isLoading = resAsync.isLoading || eventsAsync.isLoading || usersAsync.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          const EventsSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("RÉSERVATIONS TICKETS ÉVÉNEMENTS",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.amber),
                        onPressed: () {
                          ref.invalidate(allReservationsProvider);
                          ref.invalidate(allEvenementsProvider);
                          ref.invalidate(allClientsProvider);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                        : _buildFilteredList(
                            context,
                            ref,
                            resAsync.value ?? [],
                            eventsAsync.value ?? [],
                            usersAsync.value ?? [],
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

  Widget _buildFilteredList(BuildContext context, WidgetRef ref, List<Reservation> allRes, List<Evenement> allEvents, List<Utilisateur> allUsers) {
    final eventRes = allRes.where((r) => r.evenementId != null || r.typeReservation == 'evenement').toList();

    if (eventRes.isEmpty) {
      return const Center(child: Text("Aucune réservation d'événement.", style: TextStyle(color: Colors.white24)));
    }

    return ListView.builder(
      itemCount: eventRes.length,
      itemBuilder: (context, index) {
        final res = eventRes[index];
        final event = allEvents.firstWhere((e) => e.id == res.evenementId, 
            orElse: () => Evenement(titre: "Événement #${res.evenementId}", dateDebut: res.dateReservation));
        final user = allUsers.firstWhere((u) => u.id == res.utilisateurId, 
            orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"));

        return _buildReservationTile(context, ref, res, event, user);
      },
    );
  }

  Widget _buildReservationTile(BuildContext context, WidgetRef ref, Reservation res, Evenement ev, Utilisateur user) {
    final bool isCancelled = (res.statut ?? '').toLowerCase() == 'annule';
    final bool isRefunded = (res.statut ?? '').toLowerCase() == 'rembourse';

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      child: ExpansionTile(
        iconColor: Colors.amber,
        collapsedIconColor: Colors.white54,
        leading: Icon(
          isCancelled ? Icons.cancel : (isRefunded ? Icons.history : Icons.check_circle),
          color: isCancelled ? Colors.orange : (isRefunded ? Colors.blue : Colors.green),
        ),
        title: Text("${user.nom} - ${ev.titre}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${DateFormat('dd/MM HH:mm').format(res.dateReservation)} • ${res.montantTotal} DH",
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Email:", user.email),
                _infoRow("Téléphone:", user.telephone ?? "N/A"),
                _infoRow("Montant:", "${res.montantTotal} DH"),
                _infoRow("Statut Actuel:", (res.statut ?? "N/A").toUpperCase()),
                if (isCancelled) ...[
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.currency_exchange),
                    label: const Text("PROCÉDER AU REMBOURSEMENT"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
                    onPressed: () => _handleRefund(context, ref, res),
                  ),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13))),
      Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13))),
    ]),
  );

  void _handleRefund(BuildContext context, WidgetRef ref, Reservation res) async {
    final ctrlPrice = TextEditingController(text: res.montantTotal.toString());
    final ctrlReason = TextEditingController(text: "Annulation de l'événement");
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Confirmer le remboursement", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: ctrlPrice, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Montant (DH)"), style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            TextField(controller: ctrlReason, decoration: const InputDecoration(labelText: "Raison"), style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () async {
              try {
                await client.admin.rembourserReservation(res.id!, double.parse(ctrlPrice.text), ctrlReason.text);
                ref.invalidate(allReservationsProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Remboursement validé et e-mail envoyé !"), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.redAccent));
              }
            },
            child: const Text("VALIDER"),
          )
        ],
      ),
    );
  }
}
