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
    final resAsync     = ref.watch(allReservationsProvider);
    final usersAsync = ref.watch(allClientsProvider);

    final seancesAsync = ref.watch(allSeancesProvider);
    final filmsAsync   = ref.watch(allFilmsProvider);
    final sallesAsync  = ref.watch(allSallesProvider);

    // ✅ Attendre que TOUS les providers soient chargés
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
          const TangerSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── HEADER ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("GESTION DES RÉSERVATIONS",
                            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        Text("Cinéma Mégarama Tanger — ID: 9",
                            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                      ]),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white54),
                        tooltip: "Rafraîchir",
                        onPressed: () {
                          ref.invalidate(allReservationsProvider);
                          ref.invalidate(allUtilisateursProvider);
                          ref.invalidate(allSeancesProvider);
                          ref.invalidate(allFilmsProvider);
                          ref.invalidate(allSallesProvider);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // ─── CONTENU ───
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                        : hasError
                        ? Center(child: Text(
                        "Erreur de chargement",
                        style: const TextStyle(color: Colors.redAccent)))
                        : _buildList(context, ref,
                      reservations: resAsync.value ?? [],
                      users:        usersAsync.value ?? [],
                      seances:      seancesAsync.value ?? [],
                      films:        filmsAsync.value ?? [],
                      salles:       sallesAsync.value ?? [],
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

  Widget _buildList(
      BuildContext context,
      WidgetRef ref, {
        required List<Reservation> reservations,
        required List<Utilisateur> users,
        required List<Seance> seances,
        required List<Film> films,
        required List<Salle> salles,
      }) {
    if (reservations.isEmpty) {
      return const Center(
          child: Text("Aucune réservation.", style: TextStyle(color: Colors.white24)));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final res = reservations[index];

        // ✅ Jointure locale avec données complètes
        final user = users.firstWhere(
              (u) => u.id == res.utilisateurId,
          orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: "N/A"),
        );

        final seance = seances.firstWhere(
              (s) => s.id == res.seanceId,
          orElse: () => Seance(
            filmId: 0, salleId: 0, dateHeure: DateTime.now(),
            langue: "N/A", typeProjection: "N/A", typeSeance: "N/A",
            placesDisponibles: 0, prixNormal: 0, prixReduit: 0,
            prixSenior: 0, prixEnfant: 0,
          ),
        );

        final film = films.firstWhere(
              (f) => f.id == seance.filmId,
          orElse: () => Film(titre: "Film #${seance.filmId}"),
        );

        final salle = salles.firstWhere(
              (s) => s.id == seance.salleId,
          orElse: () => Salle(cinemaId: 0, codeSalle: "Salle #${seance.salleId}", capacite: 0, typeProjection: "N/A"),
        );

        return _buildResCard(context, ref, res, user, film, salle, seance);
      },
    );
  }

  Widget _buildResCard(
      BuildContext context,
      WidgetRef ref,
      Reservation res,
      Utilisateur user,
      Film film,
      Salle salle,
      Seance seance,
      ) {
    final bool isCancelled = res.statut == 'annule';
    final bool isRefunded  = res.statut == 'rembourse';
    final bool isConfirmed = res.statut == 'confirme';

    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.hourglass_empty;
    if (isConfirmed) { statusColor = Colors.green;  statusIcon = Icons.check_circle; }
    if (isCancelled) { statusColor = Colors.orange; statusIcon = Icons.cancel; }
    if (isRefunded)  { statusColor = Colors.blue;   statusIcon = Icons.currency_exchange; }

    return Card(
      color: Colors.white.withOpacity(0.04),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: statusColor.withOpacity(0.2))),
      child: ExpansionTile(
        iconColor: Colors.amber,
        collapsedIconColor: Colors.white38,
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        title: Text(user.nom,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${film.titre} • ${DateFormat('dd/MM/yyyy HH:mm').format(seance.dateHeure)}",
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text("${res.montantTotal} DH",
              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6)),
            child: Text((res.statut ?? 'inconnu').toUpperCase(),
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ]),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ─── CLIENT ───
              _sectionTitle("COORDONNÉES CLIENT"),
              const SizedBox(height: 8),
              _infoRow(Icons.person,  "Nom",       user.nom),
              _infoRow(Icons.email,   "Email",     user.email),
              _infoRow(Icons.phone,   "Téléphone", user.telephone ?? "N/A"),

              const Divider(color: Colors.white10, height: 24),

              // ─── SÉANCE ───
              _sectionTitle("DÉTAILS DE LA SÉANCE"),
              const SizedBox(height: 8),
              _infoRow(Icons.movie,        "Film",        film.titre),
              _infoRow(Icons.meeting_room, "Salle",       salle.codeSalle),
              _infoRow(Icons.schedule,     "Date & Heure",
                  DateFormat('dd/MM/yyyy à HH:mm').format(seance.dateHeure)),
              _infoRow(Icons.videocam,     "Projection",  seance.typeProjection ?? "N/A"),
              _infoRow(Icons.language,     "Langue",      seance.langue ?? "N/A"),

              const Divider(color: Colors.white10, height: 24),

              // ─── PAIEMENT ───
              _sectionTitle("PAIEMENT"),
              const SizedBox(height: 8),
              _infoRow(Icons.payments,     "Montant Total", "${res.montantTotal} DH"),
              if (res.montantApresReduction != null)
                _infoRow(Icons.currency_exchange, "Remboursé", "${res.montantApresReduction} DH"),
              _infoRow(Icons.info_outline, "Statut",
                  (res.statut ?? 'inconnu').toUpperCase()),

              // ─── BOUTON REMBOURSEMENT ───
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () => _showRefundDialog(context, ref, res, user),
                  ),
                ),
              ],

              if (isRefunded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3))),
                  child: Row(children: [
                    const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Text("Remboursement : ${res.montantApresReduction ?? res.montantTotal} DH",
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ],
            ]),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2));
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, color: Colors.white24, size: 16),
        const SizedBox(width: 8),
        SizedBox(width: 110,
            child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13))),
        Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13))),
      ]),
    );
  }

  void _showRefundDialog(
      BuildContext context, WidgetRef ref, Reservation res, Utilisateur user) {
    final montantCtrl =
    TextEditingController(text: res.montantTotal.toString());
    final raisonCtrl = TextEditingController(
        text: "Annulation de la réservation #${res.id}");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Confirmer le Remboursement",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Client : ${user.nom}",
                    style: const TextStyle(color: Colors.white70)),
                Text("Email  : ${user.email}",
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
                Text("Tél    : ${user.telephone ?? 'N/A'}",
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: montantCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Montant à rembourser (DH)",
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixText: "DH",
                suffixStyle: const TextStyle(color: Colors.amber),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: raisonCtrl,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Raison du remboursement",
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3))),
              child: Row(children: [
                const Icon(Icons.email, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Un email sera envoyé à ${user.email}",
                      style: const TextStyle(color: Colors.green, fontSize: 12)),
                ),
              ]),
            ),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("ANNULER",
                  style: TextStyle(color: Colors.white54))),
          ElevatedButton.icon(
            icon: const Icon(Icons.currency_exchange, size: 16),
            label: const Text("CONFIRMER & ENVOYER EMAIL"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white),
            onPressed: () async {
              try {
                await client.admin.rembourserReservation(
                  res.id!,
                  double.tryParse(montantCtrl.text) ?? res.montantTotal,
                );
                ref.invalidate(allReservationsProvider);
                ref.invalidate(allUtilisateursProvider);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Remboursement effectué !"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Erreur : $e"),
                      backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}