import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/events_sidebar.dart';
import 'package:intl/intl.dart';

class ManageReservationsEventsPage extends ConsumerWidget {
  const ManageReservationsEventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Détection de la taille de l'écran (Pixel 7 < 768)
    final isMobile = MediaQuery.of(context).size.width < 768;

    final resAsync    = ref.watch(allReservationsProvider);
    final eventsAsync = ref.watch(allEvenementsProvider);
    final usersAsync  = ref.watch(allClientsProvider);

    final isLoading = resAsync.isLoading || eventsAsync.isLoading || usersAsync.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      // Sur Pixel 7, on n'affiche pas la Sidebar fixe pour gagner de la place
      body: Row(
        children: [
          if (!isMobile) SizedBox(width: 280, child: const EventsSidebar()),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── HEADER RESPONSIVE ───
                  _buildHeader(isMobile, ref),

                  const SizedBox(height: 20),

                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                        : _buildFilteredList(
                      context,
                      ref,
                      resAsync.value ?? [],
                      eventsAsync.value ?? [],
                      usersAsync.value ?? [],
                      isMobile, // On passe isMobile à la liste
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

  // Fonction Header séparée pour plus de clarté
  Widget _buildHeader(bool isMobile, WidgetRef ref) {
    final title = const Text(
      "RÉSERVATIONS TICKETS ÉVÉNEMENTS",
      style: TextStyle(
          color: Colors.white,
          fontSize: 18, // Taille réduite pour Pixel 7
          fontWeight: FontWeight.bold
      ),
    );

    final refreshBtn = IconButton(
      icon: const Icon(Icons.refresh, color: Colors.amber),
      onPressed: () {
        ref.invalidate(allReservationsProvider);
        ref.invalidate(allEvenementsProvider);
        ref.invalidate(allClientsProvider);
      },
    );

    if (isMobile) {
      return Row( // Sur mobile, on met le titre et le bouton sur la même ligne
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: title), // Expanded empêche le texte de déborder
          refreshBtn,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        title,
        refreshBtn,
      ],
    );
  }

  Widget _buildFilteredList(BuildContext context, WidgetRef ref, List<Reservation> allRes, List<Evenement> allEvents, List<Utilisateur> allUsers, bool isMobile) {
    final eventRes = allRes.where((r) => r.evenementId != null || r.typeReservation == 'evenement').toList();

    if (eventRes.isEmpty) {
      return const Center(child: Text("Aucune réservation d'événement.", style: TextStyle(color: Colors.white24)));
    }

    return ListView.builder(
      itemCount: eventRes.length,
      itemBuilder: (context, index) {
        final res   = eventRes[index];
        final event = allEvents.firstWhere((e) => e.id == res.evenementId,
            orElse: () => Evenement(titre: "Événement #${res.evenementId}", dateDebut: res.dateReservation));
        final user  = allUsers.firstWhere((u) => u.id == res.utilisateurId,
            orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"));
        return _buildReservationTile(context, ref, res, event, user, isMobile);
      },
    );
  }

  Widget _buildReservationTile(BuildContext context, WidgetRef ref, Reservation res, Evenement ev, Utilisateur user, bool isMobile) {
    final bool isCancelled = (res.statut ?? '').toLowerCase() == 'annule';
    final bool isRefunded  = (res.statut ?? '').toLowerCase() == 'rembourse';

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      child: ExpansionTile(
        iconColor: Colors.amber,
        collapsedIconColor: Colors.white54,
        tilePadding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16), // Padding réduit sur Pixel 7
        leading: Icon(
          isCancelled ? Icons.cancel : (isRefunded ? Icons.history : Icons.check_circle),
          color: isCancelled ? Colors.orange : (isRefunded ? Colors.blue : Colors.green),
          size: isMobile ? 20 : 24,
        ),
        title: Text(
          "${user.nom} - ${ev.titre}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isMobile ? 13 : 15),
        ),
        subtitle: Text(
          "${DateFormat('dd/MM HH:mm').format(res.dateReservation)} • ${res.montantTotal} DH",
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Email:", user.email, isMobile),
                _infoRow("Téléphone:", user.telephone ?? "N/A", isMobile),
                _infoRow("Montant:", "${res.montantTotal} DH", isMobile),
                _infoRow("Statut:", (res.statut ?? "N/A").toUpperCase(), isMobile),
                if (isCancelled) ...[
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity, // Bouton large sur mobile
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.currency_exchange, size: 18),
                      label: Text(isMobile ? "REMBOURSER" : "PROCÉDER AU REMBOURSEMENT"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12)
                      ),
                      onPressed: () => _handleRefund(context, ref, res),
                    ),
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isMobile) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      SizedBox(
          width: isMobile ? 80 : 120, // Largeur adaptée au Pixel 7
          child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12))
      ),
      Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 12))),
    ]),
  );

  // ... (Garder la fonction _handleRefund identique à la vôtre)
  void _handleRefund(BuildContext context, WidgetRef ref, Reservation res) async {
    final ctrlPrice  = TextEditingController(text: res.montantTotal.toString());
    final ctrlReason = TextEditingController(text: "Annulation de l'événement");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Confirmer le remboursement", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: ctrlPrice,  keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Montant (DH)"), style: const TextStyle(color: Colors.white)),
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Remboursement validé !"), backgroundColor: Colors.green));
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