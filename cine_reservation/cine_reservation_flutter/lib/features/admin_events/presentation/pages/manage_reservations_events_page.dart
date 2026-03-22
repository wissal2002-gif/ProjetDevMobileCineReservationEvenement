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
    // On utilise les providers de base (sécurisés pour la sérialisation)
    final resAsync = ref.watch(allReservationsProvider);
    final eventsAsync = ref.watch(allEvenementsProvider);
    final usersAsync = ref.watch(allClientsProvider);

    final isLoading = resAsync.isLoading || eventsAsync.isLoading || usersAsync.isLoading;
    final hasError = resAsync.hasError || eventsAsync.hasError || usersAsync.hasError;

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
                  const Text("RÉSERVATIONS - SPECTACLES & ÉVÉNEMENTS",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                        : hasError
                        ? const Center(child: Text("Erreur de chargement des données", style: TextStyle(color: Colors.redAccent)))
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
    // Filtrer les réservations : on ne garde que celles qui ont un evenementId (Pas de seanceId)
    final eventRes = allRes.where((r) => r.evenementId != null).toList();

    if (eventRes.isEmpty) {
      return const Center(child: Text("Aucune réservation d'événement.", style: TextStyle(color: Colors.white24)));
    }

    return ListView.builder(
      itemCount: eventRes.length,
      itemBuilder: (context, index) {
        final res = eventRes[index];
        
        // Jointure manuelle en Flutter (Plus stable que via Map Serverpod)
        final event = allEvents.firstWhere(
          (e) => e.id == res.evenementId,
          orElse: () => Evenement(titre: "Événement inconnu #${res.evenementId}", dateDebut: DateTime.now()),
        );
        
        final user = allUsers.firstWhere(
          (u) => u.id == res.utilisateurId,
          orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"),
        );

        return _buildReservationTile(context, ref, res, event, user);
      },
    );
  }

  Widget _buildReservationTile(BuildContext context, WidgetRef ref, Reservation res, Evenement ev, Utilisateur user) {
    final bool isCancelled = res.statut == 'annule';
    final bool isRefunded = res.statut == 'rembourse';

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      child: ExpansionTile(
        iconColor: Colors.amber,
        collapsedIconColor: Colors.white54,
        leading: Icon(
          isCancelled ? Icons.cancel : (isRefunded ? Icons.history : Icons.confirmation_number),
          color: isCancelled ? Colors.orange : (isRefunded ? Colors.blue : Colors.green),
        ),
        title: Text("${user.nom} - ${ev.titre}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${DateFormat('dd/MM HH:mm').format(ev.dateDebut)} • ${res.montantTotal} DH",
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("INFOS CLIENT", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _rowInfo("Email:", user.email),
                _rowInfo("Téléphone:", user.telephone ?? "N/A"),

                const Divider(color: Colors.white10, height: 30),

                const Text("DÉTAILS BILLET", style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _rowInfo("Statut:", (res.statut ?? "INCONNU").toUpperCase()),
                _rowInfo("Montant:", "${res.montantTotal} DH"),

                if (isCancelled) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.currency_exchange, size: 18),
                      label: const Text("PROCÉDER AU REMBOURSEMENT"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
                      onPressed: () => _handleRefund(context, ref, res, user),
                    ),
                  ),
                ],
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
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13))),
        ],
      ),
    );
  }

  void _handleRefund(BuildContext context, WidgetRef ref, Reservation res, Utilisateur user) async {
    final ctrl = TextEditingController(text: res.montantTotal.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Remboursement Ticket", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: "Montant (DH)", labelStyle: TextStyle(color: Colors.white54)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () async {
              await client.admin.rembourserReservation(res.id!, double.parse(ctrl.text));
              ref.invalidate(allReservationsProvider);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Remboursement effectué !")));
            },
            child: const Text("VALIDER"),
          )
        ],
      ),
    );
  }
}
