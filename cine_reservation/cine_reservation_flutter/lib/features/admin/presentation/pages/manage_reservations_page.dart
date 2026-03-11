import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManageReservationsPage extends ConsumerWidget {
  const ManageReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resAsync = ref.watch(allReservationsProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);
    final filmsAsync = ref.watch(prog.filmsProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);
    final sallesAsync = ref.watch(allSallesProvider);
    final seancesAsync = ref.watch(allSeancesProvider);
    final eventsAsync = ref.watch(allEvenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("GESTION DES RÉSERVATIONS")),
      body: resAsync.when(
        data: (reservations) => usersAsync.when(
          data: (users) => filmsAsync.when(
            data: (films) => cinemasAsync.when(
              data: (cinemas) => sallesAsync.when(
                data: (salles) => seancesAsync.when(
                  data: (seances) => eventsAsync.when(
                    data: (events) {
                      final cinemaRes = reservations.where((r) => r.typeReservation == 'cinema').toList();
                      final eventRes = reservations.where((r) => r.typeReservation == 'evenement').toList();

                      return DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            const TabBar(
                              indicatorColor: AppColors.accent,
                              labelColor: AppColors.accent,
                              tabs: [
                                Tab(text: "CINÉMA", icon: Icon(Icons.movie_outlined)),
                                Tab(text: "ÉVÉNEMENTS", icon: Icon(Icons.event_available_outlined)),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  _buildList(context, ref, cinemaRes, users, films, cinemas, salles, seances, []),
                                  _buildList(context, ref, eventRes, users, [], cinemas, [], [], events, isEvent: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("Erreur events: $e")),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Erreur séances: $e")),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Erreur salles: $e")),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Erreur cinémas: $e")),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Erreur films: $e")),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Erreur utilisateurs: $e")),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Reservation> list, List<Utilisateur> users, List<Film> films, List<Cinema> cinemas, List<Salle> salles, List<Seance> seances, List<Evenement> events, {bool isEvent = false}) {
    if (list.isEmpty) return const Center(child: Text("Aucune réservation.", style: TextStyle(color: Colors.white54)));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final res = list[index];
        final user = users.firstWhere((u) => u.id == res.utilisateurId, orElse: () => Utilisateur(nom: "Inconnu", email: ""));

        String title = "Inconnu";
        String lieu = "";
        Evenement? relatedEvent;

        if (isEvent) {
          relatedEvent = events.firstWhere((e) => e.id == res.evenementId, orElse: () => Evenement(titre: "Événement inconnu", dateDebut: DateTime.now()));
          title = relatedEvent.titre;
          lieu = "${relatedEvent.ville} - ${relatedEvent.lieu ?? ''}";
        } else {
          final seance = seances.firstWhere((s) => s.id == res.seanceId, orElse: () => Seance(filmId: 0, salleId: 0, dateHeure: DateTime.now(), placesDisponibles: 0, prixNormal: 0));
          final film = films.firstWhere((f) => f.id == seance.filmId, orElse: () => Film(titre: "Film inconnu"));
          final salle = salles.firstWhere((s) => s.id == seance.salleId, orElse: () => Salle(cinemaId: 0, codeSalle: "?", capacite: 0));
          final cinema = cinemas.firstWhere((c) => c.id == salle.cinemaId, orElse: () => Cinema(nom: "Cinéma inconnu", adresse: "", ville: ""));
          title = film.titre;
          lieu = "${cinema.nom} - Salle ${salle.codeSalle}";
        }

        return Card(
          color: Colors.white.withOpacity(0.05),
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Icon(res.statut == 'annule' ? Icons.cancel : Icons.check_circle, color: _getStatusColor(res.statut)),
            title: Text("${user.nom} - $title", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("${DateFormat('dd/MM HH:mm').format(res.dateReservation)} • ${res.montantTotal} DH", style: const TextStyle(color: Colors.white54, fontSize: 12)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Lieu:", lieu),
                    if (!isEvent) ref.watch(reservationSiegesProvider(res.id!)).when(
                      data: (s) => _infoRow("Sièges:", s.map((e) => e.numero).join(", ")),
                      loading: () => const Text("..."),
                      error: (_,__) => const Text("Erreur sièges"),
                    ),
                    _infoRow("Statut Actuel:", res.statut?.toUpperCase() ?? ""),

                    if (isEvent && relatedEvent != null && res.statut == 'annule') ...[
                      const Divider(color: Colors.white10),
                      const Text("CONDITIONS DE REMBOURSEMENT", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                      _infoRow("Annulation Gratuite:", relatedEvent.annulationGratuite == true ? "OUI" : "NON"),
                      _infoRow("Délai:", "${relatedEvent.delaiAnnulation ?? 0}h avant"),
                      _infoRow("Frais d'annulation:", "${relatedEvent.fraisAnnulation ?? 0} DH"),
                    ],

                    if (res.statut == 'annule') ...[
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.currency_exchange),
                        label: const Text("PROCÉDER AU REMBOURSEMENT"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () => _showRefundDialog(context, ref, res, relatedEvent),
                      ),
                    ],
                    if (res.statut == 'rembourse') ...[
                      const SizedBox(height: 8),
                      Text("Remboursement effectué: ${res.montantApresReduction ?? 0} DH", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    ]
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showRefundDialog(BuildContext context, WidgetRef ref, Reservation res, Evenement? event) {
    double suggestion = res.montantTotal;
    if (event != null && event.annulationGratuite == false) {
      suggestion = res.montantTotal - (event.fraisAnnulation ?? 0);
    }
    final amountCtrl = TextEditingController(text: suggestion.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Valider le remboursement"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Montant payé: ${res.montantTotal} DH", style: const TextStyle(color: Colors.white70)),
            if (event?.annulationGratuite == false) Text("Frais suggérés: -${event?.fraisAnnulation} DH", style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Montant à rendre au client", suffixText: "DH"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              await client.admin.rembourserReservation(res.id!, double.parse(amountCtrl.text));
              ref.invalidate(allReservationsProvider);
              Navigator.pop(context);
            },
            child: const Text("Confirmer"),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        Text("$label ", style: const TextStyle(color: Colors.white38, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ]),
    );
  }

  Color _getStatusColor(String? statut) {
    if (statut == 'annule') return Colors.orangeAccent;
    if (statut == 'rembourse') return Colors.blueAccent;
    if (statut == 'confirme') return Colors.greenAccent;
    return Colors.white24;
  }
}