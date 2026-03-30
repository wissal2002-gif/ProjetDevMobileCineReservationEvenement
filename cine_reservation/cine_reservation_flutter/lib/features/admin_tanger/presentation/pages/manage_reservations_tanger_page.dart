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
    final isMobile = MediaQuery.of(context).size.width < 768;
    final resAsync     = ref.watch(allReservationsProvider);
    final usersAsync   = ref.watch(allClientsProvider);
    final seancesAsync = ref.watch(allSeancesProvider);
    final filmsAsync   = ref.watch(allFilmsProvider);
    final sallesAsync  = ref.watch(allSallesProvider);

    final isLoading = resAsync.isLoading ||
        usersAsync.isLoading ||
        seancesAsync.isLoading ||
        filmsAsync.isLoading ||
        sallesAsync.isLoading;

    final hasError = resAsync.hasError ||
        usersAsync.hasError ||
        seancesAsync.hasError ||
        filmsAsync.hasError ||
        sallesAsync.hasError;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          if (!isMobile) const SizedBox(width: 280, child: TangerSidebar()),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("RÉSERVATIONS CINÉMA - TANGER",
                              style: TextStyle(color: Colors.white, fontSize: isMobile ? 18 : 28, fontWeight: FontWeight.bold)),

                          Text("Exclusif Mégarama Tanger — ID: 9",
                              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                        ],
                      ),
                      // ✅ BOUTON ACTUALISER
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.amber, size: 28),
                        tooltip: "Actualiser les données",
                        onPressed: () {
                          ref.invalidate(allReservationsProvider);
                          ref.invalidate(allClientsProvider);
                          ref.invalidate(allSeancesProvider);
                          ref.invalidate(allFilmsProvider);
                          ref.invalidate(allSallesProvider);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                        : hasError
                        ? const Center(child: Text("Erreur de chargement", style: TextStyle(color: Colors.redAccent)))
                        : _buildFilteredTangerList(
                      context,
                      ref,
                      resAsync.value ?? [],
                      usersAsync.value ?? [],
                      seancesAsync.value ?? [],
                      filmsAsync.value ?? [],
                      sallesAsync.value ?? [],
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

  Widget _buildFilteredTangerList(
      BuildContext context,
      WidgetRef ref,
      List<Reservation> reservations,
      List<Utilisateur> users,
      List<Seance> seances,
      List<Film> films,
      List<Salle> salles,
      ) {

    // ✅ FILTRE STRICT : Uniquement Cinéma ID 9 et exclure les événements
    final tangerReservations = reservations.where((r) {
      if (r.seanceId == null) return false; // Exclure les événements

      try {
        final seance = seances.firstWhere((s) => s.id == r.seanceId);
        final salle = salles.firstWhere((s) => s.id == seance.salleId);
        return salle.cinemaId == 9; // Uniquement Tanger
      } catch (e) {
        return false;
      }
    }).toList();

    if (tangerReservations.isEmpty) {
      return const Center(child: Text("Aucune réservation pour Tanger.", style: TextStyle(color: Colors.white24)));
    }

    return ListView.builder(
      itemCount: tangerReservations.length,
      itemBuilder: (context, index) {
        final res = tangerReservations[index];
        // ✅ RECHERCHE ROBUSTE DU NOM DU CLIENT
        final user = users.firstWhere(
                (u) => u.id == res.utilisateurId,
            orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A")
        );

        final seance = seances.firstWhere((s) => s.id == res.seanceId, orElse: () => seances.firstWhere((s) => s.id == res.seanceId));
        final film = films.firstWhere((f) => f.id == seance.filmId, orElse: () => Film(titre: "Film #${seance.filmId}"));
        final salle = salles.firstWhere((s) => s.id == seance.salleId, orElse: () => Salle(cinemaId: 9, codeSalle: "Salle #${seance.salleId}", capacite: 0, typeProjection: ""));

        return _buildResCard(context, ref, res, user, film, salle, seance);
      },
    );
  }

  Widget _buildResCard(BuildContext context, WidgetRef ref, Reservation res, Utilisateur user, Film film, Salle salle, Seance seance) {
    final bool isCancelled = res.statut == 'annule';
    final bool isRefunded  = res.statut == 'rembourse';

    return Card(
      color: Colors.white.withOpacity(0.04),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Icon(Icons.movie, color: isCancelled ? Colors.orange : (isRefunded ? Colors.blue : Colors.green)),
        title: Text(user.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text("${film.titre} • ${DateFormat('dd/MM HH:mm').format(seance.dateHeure)}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Email:", user.email),
                _infoRow("Téléphone:", user.telephone ?? "Non renseigné"),
                _infoRow("Salle:", salle.codeSalle),
                _infoRow("Montant:", "${res.montantTotal} DH"),
                _infoRow("Statut:", (res.statut ?? "N/A").toUpperCase()),
                if (isCancelled) ...[
                  const SizedBox(height: 10),
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
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13))), Text(value, style: const TextStyle(color: Colors.white, fontSize: 13))]),
  );

  void _handleRefund(BuildContext context, WidgetRef ref, Reservation res) async {
    final ctrlPrice = TextEditingController(text: res.montantTotal.toString());
    final ctrlReason = TextEditingController(text: "Annulation de séance");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Confirmer le remboursement", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Le client recevra un e-mail de confirmation après validation.", style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 15),
            TextField(controller: ctrlPrice, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Montant à rembourser (DH)"), style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            TextField(controller: ctrlReason, decoration: const InputDecoration(labelText: "Raison du remboursement"), style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () async {
              // ✅ FIX: Appel corrigé avec les bons arguments
              await client.admin.rembourserReservation(res.id!, double.parse(ctrlPrice.text), ctrlReason.text);
              ref.invalidate(allReservationsProvider);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Remboursement effectué et e-mail envoyé !"), backgroundColor: Colors.green));
            },
            child: const Text("VALIDER"),
          )
        ],
      ),
    );
  }
}
