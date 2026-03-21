import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/casa_sidebar.dart';
import 'package:intl/intl.dart';

class ManageReservationsCasaPage extends ConsumerWidget {
  const ManageReservationsCasaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          const CasaSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("GESTION DES RÉSERVATIONS - CASA",
                            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        Text("Exclusif Mégarama Casablanca — ID: 2",
                            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                      ]),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.amber),
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
                        : _buildFilteredCasaList(
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

  Widget _buildFilteredCasaList(
      BuildContext context,
      WidgetRef ref,
      List<Reservation> reservations,
      List<Utilisateur> users,
      List<Seance> seances,
      List<Film> films,
      List<Salle> salles,
      ) {
    
    final casaReservations = reservations.where((r) {
      if (r.seanceId == null || r.evenementId != null) return false;
      
      try {
        final seance = seances.firstWhere((s) => s.id == r.seanceId);
        final salle = salles.firstWhere((s) => s.id == seance.salleId);
        return salle.cinemaId == 2; 
      } catch (e) {
        return false;
      }
    }).toList();

    if (casaReservations.isEmpty) {
      return const Center(child: Text("Aucune réservation pour Casablanca.", style: TextStyle(color: Colors.white24)));
    }

    return ListView.builder(
      itemCount: casaReservations.length,
      itemBuilder: (context, index) {
        final res = casaReservations[index];
        final user = users.firstWhere((u) => u.id == res.utilisateurId, orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"));
        
        final seance = seances.firstWhere((s) => s.id == res.seanceId);
        final film = films.firstWhere((f) => f.id == seance.filmId, orElse: () => Film(titre: "Film #${seance.filmId}"));
        final salle = salles.firstWhere((s) => s.id == seance.salleId, orElse: () => Salle(cinemaId: 2, codeSalle: "Salle #${seance.salleId}", capacite: 0, typeProjection: ""));

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
                _infoRow("Salle:", salle.codeSalle),
                _infoRow("Montant:", "${res.montantTotal} DH"),
                _infoRow("Statut:", (res.statut ?? "N/A").toUpperCase()),
                if (isCancelled) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _handleRefund(context, ref, res),
                    child: const Text("REMBOURSER"),
                  )
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
    await client.admin.rembourserReservation(res.id!, res.montantTotal);
    ref.invalidate(allReservationsProvider);
  }
}
