import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/events_sidebar.dart';
import 'package:intl/intl.dart';

class ManageReservationsEventsPage extends ConsumerStatefulWidget {
  const ManageReservationsEventsPage({super.key});

  @override
  ConsumerState<ManageReservationsEventsPage> createState() =>
      _ManageReservationsEventsPageState();
}

class _ManageReservationsEventsPageState
    extends ConsumerState<ManageReservationsEventsPage> {

  String _filtreType   = "Tous";
  String _filtreStatut = "Tous";

  @override
  Widget build(BuildContext context) {
    final isMobile    = MediaQuery.of(context).size.width < 768;
    final resAsync    = ref.watch(allReservationsProvider);
    final eventsAsync = ref.watch(allEvenementsProvider);
    final usersAsync  = ref.watch(allClientsProvider);
    final cinemasAsync = ref.watch(allCinemasProvider); // ← AJOUTÉ

    final isLoading = resAsync.isLoading ||
        eventsAsync.isLoading ||
        usersAsync.isLoading ||
        cinemasAsync.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          if (!isMobile) SizedBox(width: 280, child: const EventsSidebar()),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 20),
                  _buildFilterBar(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: isLoading
                        ? const Center(
                        child: CircularProgressIndicator(
                            color: Colors.amber))
                        : _buildFilteredList(
                      context,
                      resAsync.value ?? [],
                      eventsAsync.value ?? [],
                      usersAsync.value ?? [],
                      cinemasAsync.value ?? [], // ← AJOUTÉ
                      isMobile,
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

  Widget _buildHeader(bool isMobile) {
    final title = const Text(
      "RÉSERVATIONS TICKETS ÉVÉNEMENTS",
      style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold),
    );
    final refreshBtn = IconButton(
      icon: const Icon(Icons.refresh, color: Colors.amber),
      onPressed: () {
        ref.invalidate(allReservationsProvider);
        ref.invalidate(allEvenementsProvider);
        ref.invalidate(allClientsProvider);
        ref.invalidate(allCinemasProvider); // ← AJOUTÉ
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Expanded(child: title), refreshBtn],
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Text("Lieu :",
              style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(width: 8),
          ...["Tous", "Au Cinéma", "Hors Cinéma"].map((f) {
            final selected = _filtreType == f;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(f,
                    style: TextStyle(
                        color: selected ? Colors.black : Colors.white70,
                        fontSize: 11)),
                selected: selected,
                onSelected: (_) => setState(() => _filtreType = f),
                selectedColor: Colors.amber,
                backgroundColor: Colors.white10,
              ),
            );
          }).toList(),
          const SizedBox(width: 16),
          const Text("Statut :",
              style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(width: 8),
          ...["Tous", "Confirmé", "Annulé", "Remboursé"].map((f) {
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
                        color: selected ? Colors.white : Colors.white70,
                        fontSize: 11)),
                selected: selected,
                onSelected: (_) => setState(() => _filtreStatut = f),
                selectedColor: color,
                backgroundColor: Colors.white10,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFilteredList(
      BuildContext context,
      List<Reservation> allRes,
      List<Evenement> allEvents,
      List<Utilisateur> allUsers,
      List<Cinema> allCinemas, // ← AJOUTÉ
      bool isMobile,
      ) {
    final admin = ref.read(adminProfileProvider).value;

    // Garder uniquement les réservations d'événements
    List<Reservation> eventRes = allRes
        .where((r) =>
    r.evenementId != null || r.typeReservation == 'evenement')
        .toList();

    // Filtre selon le rôle de l'admin
    if (admin?.role == 'resp_evenements' && admin?.cinemaId != null) {

      // ── Récupérer la ville du cinéma de l'admin depuis Cinema ──────
      final cinemaDeLAdmin = allCinemas.firstWhere(
            (c) => c.id == admin!.cinemaId,
        orElse: () => Cinema(nom: '', adresse: '', ville: ''),
      );
      final villeAdmin = cinemaDeLAdmin.ville.isNotEmpty
          ? cinemaDeLAdmin.ville
          : null;

      // ── Filtrer les événements accessibles à cet admin ─────────────
      final mesEventIds = allEvents
          .where((e) {
        // CAS 1 : événement dans son cinéma
        if (e.cinemaId == admin!.cinemaId) return true;

        // CAS 2 : événement hors cinéma (cinemaId == null)
        // mais dans la même ville que son cinéma
        if (e.cinemaId == null &&
            villeAdmin != null &&
            e.ville != null &&
            e.ville == villeAdmin) return true;

        return false;
      })
          .map((e) => e.id)
          .toSet();

      eventRes = eventRes
          .where((r) => mesEventIds.contains(r.evenementId))
          .toList();
    }

    // ── Filtre lieu (chips) ─────────────────────────────────────────────
    if (_filtreType == "Au Cinéma") {
      eventRes = eventRes.where((r) {
        final ev = allEvents.firstWhere(
              (e) => e.id == r.evenementId,
          orElse: () => Evenement(titre: '', dateDebut: DateTime.now()),
        );
        return ev.cinemaId != null;
      }).toList();
    } else if (_filtreType == "Hors Cinéma") {
      eventRes = eventRes.where((r) {
        final ev = allEvents.firstWhere(
              (e) => e.id == r.evenementId,
          orElse: () => Evenement(titre: '', dateDebut: DateTime.now()),
        );
        return ev.cinemaId == null;
      }).toList();
    }

    if (_filtreStatut != "Tous") {
      eventRes = eventRes.where((r) {
        final statut = (r.statut ?? '').toLowerCase().trim();
        switch (_filtreStatut) {
          case "Confirmé":
            return statut == 'confirmee' ||
                statut == 'confirme' ||
                statut == 'confirmed';
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

    if (eventRes.isEmpty) {
      return const Center(
          child: Text(
            "Aucune réservation d'événement.",
            style: TextStyle(color: Colors.white24),
          ));
    }

    return ListView.builder(
      itemCount: eventRes.length,
      itemBuilder: (context, index) {
        final res = eventRes[index];
        final event = allEvents.firstWhere(
              (e) => e.id == res.evenementId,
          orElse: () => Evenement(
              titre: "Événement #${res.evenementId}",
              dateDebut: res.dateReservation),
        );
        final user = allUsers.firstWhere(
              (u) => u.id == res.utilisateurId,
          orElse: () =>
              Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"),
        );
        return _buildReservationTile(context, res, event, user, isMobile);
      },
    );
  }

  Widget _buildReservationTile(
      BuildContext context,
      Reservation res,
      Evenement ev,
      Utilisateur user,
      bool isMobile,
      ) {
    final bool isCancelled = (res.statut ?? '').toLowerCase() == 'annule';
    final bool isRefunded  = (res.statut ?? '').toLowerCase() == 'rembourse';
    final bool isAtCinema  = ev.cinemaId != null;

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white10)),
      child: ExpansionTile(
        iconColor: Colors.amber,
        collapsedIconColor: Colors.white54,
        tilePadding:
        EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
        leading: Icon(
          isCancelled
              ? Icons.cancel
              : (isRefunded ? Icons.history : Icons.check_circle),
          color: isCancelled
              ? Colors.orange
              : (isRefunded ? Colors.blue : Colors.green),
          size: isMobile ? 20 : 24,
        ),
        title: Text(
          "${user.nom} - ${ev.titre}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 13 : 15),
        ),
        subtitle: Row(
          children: [
            // Badge CINÉMA ou EXTERNE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isAtCinema
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isAtCinema ? "CINÉMA" : "EXTERNE",
                style: TextStyle(
                    color: isAtCinema ? Colors.blue : Colors.amber,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "${DateFormat('dd/MM HH:mm').format(res.dateReservation)} • ${res.montantTotal} DH",
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── INFOS CLIENT ──────────────────────────────────
                _sectionLabel("INFOS CLIENT"),
                const SizedBox(height: 8),
                _infoRow("Nom :", user.nom ?? "N/A", isMobile),
                _infoRow("Email :", user.email, isMobile),
                _infoRow("Téléphone :",
                    user.telephone ?? "Non renseigné", isMobile),

                const SizedBox(height: 14),

                // ── INFOS ÉVÉNEMENT ───────────────────────────────
                _sectionLabel("INFOS ÉVÉNEMENT"),
                const SizedBox(height: 8),
                _infoRow("Titre :", ev.titre, isMobile),
                _infoRow("Type :", (ev.type ?? "N/A").toUpperCase(), isMobile),
                _infoRow("Date :",
                    DateFormat('dd/MM/yyyy HH:mm').format(ev.dateDebut),
                    isMobile),

                // CAS 1 : Dans le cinéma
                if (isAtCinema) ...[
                  _infoRow("Lieu :", "Dans le cinéma", isMobile),
                  if (ev.lieu != null && ev.lieu!.isNotEmpty)
                    _infoRow("Salle :", ev.lieu!, isMobile),
                  if (ev.ville != null)
                    _infoRow("Ville :", ev.ville!, isMobile),
                ],

                // CAS 2 : Hors cinéma
                if (!isAtCinema) ...[
                  _infoRow("Lieu :", ev.lieu ?? "N/A", isMobile),
                  _infoRow("Ville :", ev.ville ?? "N/A", isMobile),
                ],

                const SizedBox(height: 14),

                // ── INFOS RÉSERVATION ─────────────────────────────
                _sectionLabel("INFOS RÉSERVATION"),
                const SizedBox(height: 8),
                _infoRow("Montant :", "${res.montantTotal} DH", isMobile),
                _infoRow("Statut :",
                    (res.statut ?? "N/A").toUpperCase(), isMobile),

                // ── SIÈGES (cinéma uniquement) ────────────────────
                if (isAtCinema && res.id != null) ...[
                  const SizedBox(height: 14),
                  _sectionLabel("SIÈGES RÉSERVÉS"),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Siege>>(
                    future: client.admin.getSiegesByReservation(res.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox(
                          height: 30,
                          child: LinearProgressIndicator(
                              color: Colors.amber,
                              backgroundColor: Colors.white10),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("Aucun siège enregistré",
                            style: TextStyle(
                                color: Colors.white38, fontSize: 12));
                      }
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: snapshot.data!.map((siege) {
                          final isVip = siege.type == 'vip';
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isVip
                                  ? Colors.amber.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isVip
                                      ? Colors.amber.withOpacity(0.6)
                                      : Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.chair_alt,
                                    size: 13,
                                    color: isVip
                                        ? Colors.amber
                                        : Colors.white54),
                                const SizedBox(width: 5),
                                Text(siege.numero,
                                    style: TextStyle(
                                        color: isVip
                                            ? Colors.amber
                                            : Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
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
                ],

                // ── HORS CINÉMA : pas de sièges ───────────────────
                if (!isAtCinema) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.amber.withOpacity(0.2)),
                    ),
                    child: Row(children: const [
                      Icon(Icons.info_outline,
                          color: Colors.amber, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Événement hors cinéma — pas de sièges numérotés",
                          style: TextStyle(
                              color: Colors.amber, fontSize: 12),
                        ),
                      ),
                    ]),
                  ),
                ],

                // ── BOUTON REMBOURSEMENT ──────────────────────────
                if (isCancelled) ...[
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.currency_exchange, size: 18),
                      label: Text(isMobile
                          ? "REMBOURSER"
                          : "PROCÉDER AU REMBOURSEMENT"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () => _handleRefund(context, res),
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

  // ── Section label amber ───────────────────────────────────────────────────
  Widget _sectionLabel(String label) => Text(
    label,
    style: const TextStyle(
        color: Colors.amber,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2),
  );

  // ── Info row ──────────────────────────────────────────────────────────────
  Widget _infoRow(String label, String value, bool isMobile) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      SizedBox(
          width: isMobile ? 90 : 120,
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 12))),
      Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12))),
    ]),
  );

  // ── Remboursement ─────────────────────────────────────────────────────────
  void _handleRefund(BuildContext context, Reservation res) async {
    final ctrlPrice =
    TextEditingController(text: res.montantTotal.toString());
    final ctrlReason =
    TextEditingController(text: "Annulation de l'événement");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Confirmer le remboursement",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: ctrlPrice,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: "Montant (DH)"),
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            TextField(
                controller: ctrlReason,
                decoration:
                const InputDecoration(labelText: "Raison"),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () async {
              try {
                await client.admin.rembourserReservation(res.id!,
                    double.parse(ctrlPrice.text), ctrlReason.text);
                ref.invalidate(allReservationsProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Remboursement validé !"),
                        backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Erreur: $e"),
                    backgroundColor: Colors.redAccent));
              }
            },
            child: const Text("VALIDER"),
          ),
        ],
      ),
    );
  }
}