import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import 'package:intl/intl.dart';

// ✅ FIX 1 : ConsumerStatefulWidget
class ManageReservationsLocalPage extends ConsumerStatefulWidget {
  const ManageReservationsLocalPage({super.key});

  @override
  ConsumerState<ManageReservationsLocalPage> createState() =>
      _ManageReservationsLocalPageState();
}

class _ManageReservationsLocalPageState
    extends ConsumerState<ManageReservationsLocalPage> {

  // ✅ FIX 2 : variable dans le State (pas dans le Widget)
  String _filtreStatut = "Tous";

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final adminAsync   = ref.watch(adminProfileProvider);
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

    return adminAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text("Erreur: $e"))),
      data: (admin) {
        final cinemaId   = admin?.cinemaId;
        final cinemaName = admin?.nomCinema ?? "Cinéma";

        return Scaffold(
          backgroundColor: const Color(0xFF0D0A08),
          body: Row(
            children: [
              if (!isMobile) const LocalAdminSidebar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Header ──────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "RÉSERVATIONS CINÉMA - ${cinemaName.toUpperCase()}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 18 : 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Exclusif $cinemaName — ID: ${cinemaId ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh,
                                color: Colors.amber, size: 28),
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

                      const SizedBox(height: 16),

                      // ── FILTRE STATUT ────────────────────────────
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text("Statut :",
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 12)),
                            const SizedBox(width: 8),
                            ...["Tous", "Confirmé", "Annulé", "Remboursé"]
                                .map((f) {
                              final selected = _filtreStatut == f;
                              Color color;
                              switch (f) {
                                case "Confirmé":
                                  color = Colors.green;
                                  break;
                                case "Annulé":
                                  color = Colors.orange;
                                  break;
                                case "Remboursé":
                                  color = Colors.blue;
                                  break;
                                default:
                                  color = Colors.amber;
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                  label: Text(f,
                                      style: TextStyle(
                                          color: selected
                                              ? Colors.white
                                              : Colors.white70,
                                          fontSize: 11)),
                                  selected: selected,
                                  // ✅ FIX 3 : setState accessible ici
                                  onSelected: (_) =>
                                      setState(() => _filtreStatut = f),
                                  selectedColor: color,
                                  backgroundColor: Colors.white10,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Content ──────────────────────────────────
                      Expanded(
                        child: isLoading
                            ? const Center(
                            child: CircularProgressIndicator(
                                color: Colors.amber))
                            : hasError
                            ? const Center(
                            child: Text("Erreur de chargement",
                                style: TextStyle(
                                    color: Colors.redAccent)))
                            : _buildFilteredList(
                          context,
                          cinemaId,
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
      },
    );
  }

  Widget _buildFilteredList(
      BuildContext context,
      int? cinemaId,
      List<Reservation> reservations,
      List<Utilisateur> users,
      List<Seance> seances,
      List<Film> films,
      List<Salle> salles,
      ) {
    if (cinemaId == null) {
      return const Center(
        child: Text("Aucun cinéma associé à ce compte.",
            style: TextStyle(color: Colors.white24)),
      );
    }

    // Filtre principal : cinemaId + exclure événements
    List<Reservation> localReservations = reservations.where((r) {
      if (r.cinemaId == null) return false;
      if (r.typeReservation == 'evenement') return false;
      return r.cinemaId == cinemaId;
    }).toList();

    // ✅ FIX 4 : filtre statut avec toutes les variantes
    if (_filtreStatut != "Tous") {
      localReservations = localReservations.where((r) {
        final statut = (r.statut ?? '').toLowerCase().trim();
        switch (_filtreStatut) {
          case "Confirmé":
            return statut == 'confirmee' ||
                statut == 'confirme' ||
                statut == 'confirmed' ||
                statut == 'actif';
          case "Annulé":
            return statut == 'annule' ||
                statut == 'annulé' ||
                statut == 'cancelled';
          case "Remboursé":
            return statut == 'rembourse' ||
                statut == 'remboursé' ||
                statut == 'refunded';
          default:
            return true;
        }
      }).toList();
    }

    if (localReservations.isEmpty) {
      return Center(
        child: Text(
          "Aucune réservation pour ce cinéma.",
          style: TextStyle(color: Colors.white.withOpacity(0.24)),
        ),
      );
    }

    return ListView.builder(
      itemCount: localReservations.length,
      itemBuilder: (context, index) {
        final res = localReservations[index];

        final user = users.firstWhere(
              (u) => u.id == res.utilisateurId,
          orElse: () =>
              Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"),
        );

        Seance? seance;
        Film?   film;
        Salle?  salle;

        if (res.seanceId != null) {
          try {
            seance = seances.firstWhere((s) => s.id == res.seanceId);
          } catch (_) {}
          if (seance != null) {
            try {
              film = films.firstWhere((f) => f.id == seance!.filmId);
            } catch (_) {}
            try {
              salle = salles.firstWhere((s) => s.id == seance!.salleId);
            } catch (_) {}
          }
        }

        return _ResCard(
          res: res,
          user: user,
          film: film,
          salle: salle,
          seance: seance,
          onRefund: () => _handleRefund(context, res),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13)),
        ),
      ],
    ),
  );

  void _handleRefund(BuildContext context, Reservation res) async {
    final ctrlPrice =
    TextEditingController(text: res.montantTotal.toString());
    final ctrlReason =
    TextEditingController(text: "Annulation de séance");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Confirmer le remboursement",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Le client recevra un e-mail de confirmation après validation.",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: ctrlPrice,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Montant à rembourser (DH)"),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ctrlReason,
              decoration: const InputDecoration(
                  labelText: "Raison du remboursement"),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () async {
              try {
                await client.admin.rembourserReservation(
                  res.id!,
                  double.parse(ctrlPrice.text),
                  ctrlReason.text,
                );
                ref.invalidate(allReservationsProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                    Text("Remboursement effectué et e-mail envoyé !"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Erreur: $e"),
                      backgroundColor: Colors.redAccent),
                );
              }
            },
            child: const Text("VALIDER"),
          ),
        ],
      ),
    );
  }
}

// ── Widget Card réservation ───────────────────────────────────────────────────
class _ResCard extends ConsumerWidget {
  final Reservation res;
  final Utilisateur user;
  final Film?       film;
  final Salle?      salle;
  final Seance?     seance;
  final VoidCallback onRefund;

  const _ResCard({
    required this.res,
    required this.user,
    required this.film,
    required this.salle,
    required this.seance,
    required this.onRefund,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siegesAsync = res.id != null
        ? ref.watch(reservationSiegesProvider(res.id!))
        : const AsyncValue<List<Siege>>.data([]);

    final bool isCancelled = (res.statut ?? '').toLowerCase() == 'annule';
    final bool isRefunded  = (res.statut ?? '').toLowerCase() == 'rembourse';

    Color statusColor = Colors.orange;
    final statut = (res.statut ?? '').toLowerCase();
    if (statut == 'confirmee' || statut == 'confirme') {
      statusColor = Colors.green;
    } else if (statut == 'rembourse') {
      statusColor = Colors.blue;
    } else if (statut == 'annule') {
      statusColor = Colors.redAccent;
    }

    return Card(
      color: Colors.white.withOpacity(0.04),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        leading: Icon(Icons.movie_rounded, color: statusColor),
        title: Text(user.nom ?? "Client",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          seance != null
              ? "${film?.titre ?? 'Film inconnu'} • ${DateFormat('dd/MM HH:mm').format(res.dateReservation.toLocal())}"
              : "Réservation #${res.id}",
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Email:", user.email),
                _infoRow("Téléphone:", user.telephone ?? "Non renseigné"),
                if (salle != null) _infoRow("Salle:", salle!.codeSalle),
                _infoRow("Montant:", "${res.montantTotal} DH"),
                _infoRow("Statut:", (res.statut ?? "N/A").toUpperCase()),

                const Divider(color: Colors.white10, height: 20),

                // ── SIÈGES ─────────────────────────────────────────
                const Text("SIÈGES RÉSERVÉS",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.2)),
                const SizedBox(height: 10),

                siegesAsync.when(
                  loading: () => const SizedBox(
                    height: 30,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Colors.amber, strokeWidth: 2),
                    ),
                  ),
                  error: (e, _) => Text("Erreur: $e",
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 12)),
                  data: (sieges) {
                    if (sieges.isEmpty) {
                      return Text("Aucun siège enregistré",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 12));
                    }
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sieges.map((s) {
                        final isVip = s.type == 'vip';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isVip
                                ? Colors.amber.withOpacity(0.15)
                                : Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isVip
                                  ? Colors.amber.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.event_seat_rounded,
                                  color: isVip
                                      ? Colors.amber
                                      : Colors.white54,
                                  size: 14),
                              const SizedBox(width: 5),
                              Text(s.numero,
                                  style: TextStyle(
                                      color: isVip
                                          ? Colors.amber
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              if (isVip) ...[
                                const SizedBox(width: 4),
                                const Text("VIP",
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                if (isCancelled) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.currency_exchange, size: 16),
                      label: const Text("PROCÉDER AU REMBOURSEMENT"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: onRefund,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 13))),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13))),
      ],
    ),
  );
}