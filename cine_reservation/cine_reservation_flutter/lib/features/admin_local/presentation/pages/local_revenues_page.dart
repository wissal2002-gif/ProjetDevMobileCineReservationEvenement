import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import 'package:intl/intl.dart';

class LocalRevenuesPage extends ConsumerWidget {
  const LocalRevenuesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final adminAsync   = ref.watch(adminProfileProvider);
    final resAsync     = ref.watch(allReservationsProvider);
    final seancesAsync = ref.watch(allSeancesProvider);
    final filmsAsync   = ref.watch(allFilmsProvider);
    final sallesAsync  = ref.watch(allSallesProvider);
    final usersAsync   = ref.watch(allClientsProvider);

    return adminAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Erreur: $e"))),
      data: (admin) {
        final cinemaId   = admin?.cinemaId;
        final cinemaName = admin?.nomCinema ?? "Cinéma";

        return Scaffold(
          backgroundColor: const Color(0xFF0D0A08),
          body: Row(
            children: [
              if (!isMobile) const LocalAdminSidebar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── HEADER ───────────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "REVENUS DU CINÉMA",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 20 : 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$cinemaName — ID: ${cinemaId ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
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
                      const SizedBox(height: 32),

                      // ─── CONTENU ──────────────────────────────────────────
                      resAsync.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        ),
                        error: (e, _) => Center(
                          child: Text("Erreur: $e", style: const TextStyle(color: Colors.red)),
                        ),
                        data: (reservations) {
                          final seances = seancesAsync.value ?? [];
                          final films   = filmsAsync.value ?? [];
                          final salles  = sallesAsync.value ?? [];
                          final users   = usersAsync.value ?? [];

                          // ─── Filtre : cinemaId direct sur Reservation ────
                          final resLocales = reservations.where((r) {
                            if (r.cinemaId == null) return false;
                            if (r.typeReservation == 'evenement') return false;
                            return r.cinemaId == cinemaId;
                          }).toList();

                          // ─── Calculs KPI ────────────────────────────────
                          final double revenuTotal = resLocales.fold(
                              0.0, (sum, r) => sum + r.montantTotal);
                          final double revenuConfirme = resLocales
                              .where((r) => r.statut == 'confirme')
                              .fold(0.0, (sum, r) => sum + r.montantTotal);
                          final int nbAnnulees =
                              resLocales.where((r) => r.statut == 'annule').length;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ─── KPI CARDS ─────────────────────────────
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isNarrow = constraints.maxWidth < 500;
                                  return isNarrow
                                      ? GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.3,
                                    children: [
                                      _kpiCard(
                                          "REVENU TOTAL",
                                          "${revenuTotal.toStringAsFixed(0)} DH",
                                          Icons.account_balance_wallet,
                                          Colors.amber),
                                      _kpiCard(
                                          "CONFIRMÉES",
                                          "${revenuConfirme.toStringAsFixed(0)} DH",
                                          Icons.check_circle,
                                          Colors.green),
                                      _kpiCard(
                                          "RÉSERVATIONS",
                                          "${resLocales.length}",
                                          Icons.confirmation_number,
                                          Colors.blue),
                                      _kpiCard("ANNULÉES",
                                          "$nbAnnulees", Icons.cancel,
                                          Colors.red),
                                    ],
                                  )
                                      : Row(children: [
                                    Expanded(
                                        child: _kpiCard(
                                            "REVENU TOTAL",
                                            "${revenuTotal.toStringAsFixed(0)} DH",
                                            Icons.account_balance_wallet,
                                            Colors.amber)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: _kpiCard(
                                            "CONFIRMÉES",
                                            "${revenuConfirme.toStringAsFixed(0)} DH",
                                            Icons.check_circle,
                                            Colors.green)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: _kpiCard(
                                            "RÉSERVATIONS",
                                            "${resLocales.length}",
                                            Icons.confirmation_number,
                                            Colors.blue)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: _kpiCard(
                                            "ANNULÉES",
                                            "$nbAnnulees",
                                            Icons.cancel,
                                            Colors.red)),
                                  ]);
                                },
                              ),
                              const SizedBox(height: 32),

                              // ─── REVENUS PAR FILM ──────────────────────
                              _buildRevenuParFilm(resLocales, seances, films),
                              const SizedBox(height: 32),

                              // ─── LISTE DÉTAILLÉE ───────────────────────
                              _buildListeDetail(
                                  context, resLocales, seances, films, salles, users),
                            ],
                          );
                        },
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

  // ── KPI Card ────────────────────────────────────────────────────────────────
  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 12),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 11,
                letterSpacing: 1.1)),
      ]),
    );
  }

  // ── Revenus par film ─────────────────────────────────────────────────────────
  Widget _buildRevenuParFilm(
      List<Reservation> reservations, List<Seance> seances, List<Film> films) {
    final Map<String, double> revParFilm = {};
    final Map<String, int>    nbParFilm  = {};

    for (var r in reservations) {
      if (r.seanceId == null) continue;
      Seance? seance;
      try { seance = seances.firstWhere((s) => s.id == r.seanceId); } catch (_) {}
      if (seance == null) continue;

      Film? film;
      try { film = films.firstWhere((f) => f.id == seance!.filmId); } catch (_) {}
      final titre = film?.titre ?? "Film #${seance.filmId}";

      revParFilm[titre] = (revParFilm[titre] ?? 0) + r.montantTotal;
      nbParFilm[titre]  = (nbParFilm[titre] ?? 0) + 1;
    }

    if (revParFilm.isEmpty) {
      return const SizedBox.shrink();
    }

    final double maxRev = revParFilm.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("🎬 REVENUS PAR FILM",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ...revParFilm.entries.map((entry) {
          final pct = maxRev > 0 ? entry.value / maxRev : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(entry.key,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                Row(children: [
                  Text("${nbParFilm[entry.key]} rés.",
                      style:
                      const TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(width: 12),
                  Text("${entry.value.toStringAsFixed(0)} DH",
                      style: const TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold)),
                ]),
              ]),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.05),
                valueColor: const AlwaysStoppedAnimation(Colors.amber),
              ),
            ]),
          );
        }).toList(),
      ]),
    );
  }

  // ── Liste détaillée ──────────────────────────────────────────────────────────
  Widget _buildListeDetail(
      BuildContext context,
      List<Reservation> reservations,
      List<Seance> seances,
      List<Film> films,
      List<Salle> salles,
      List<Utilisateur> users,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("📋 DÉTAIL DES RÉSERVATIONS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // ─── EN-TÊTES desktop ──────────────────────────────────────
            if (!isNarrow)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(children: [
                  Expanded(
                      flex: 2,
                      child: Text("CLIENT",
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              letterSpacing: 1))),
                  Expanded(
                      flex: 2,
                      child: Text("FILM",
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              letterSpacing: 1))),
                  Expanded(
                      flex: 2,
                      child: Text("SÉANCE",
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              letterSpacing: 1))),
                  Expanded(
                      flex: 1,
                      child: Text("MONTANT",
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              letterSpacing: 1))),
                  Expanded(
                      flex: 1,
                      child: Text("STATUT",
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              letterSpacing: 1))),
                ]),
              ),
            if (!isNarrow) const SizedBox(height: 8),

            // ─── LIGNES ────────────────────────────────────────────────
            ...reservations.map((r) {
              Seance? seance;
              Film?   film;
              Utilisateur? user;

              if (r.seanceId != null) {
                try { seance = seances.firstWhere((s) => s.id == r.seanceId); } catch (_) {}
                if (seance != null) {
                  try { film = films.firstWhere((f) => f.id == seance!.filmId); } catch (_) {}
                }
              }
              try {
                user = users.firstWhere((u) => u.id == r.utilisateurId);
              } catch (_) {
                user = Utilisateur(nom: "Client #${r.utilisateurId}", email: "N/A");
              }

              final seanceDisplay = seance ??
                  Seance(
                      filmId: 0,
                      salleId: 0,
                      dateHeure: r.dateReservation,
                      langue: '',
                      typeProjection: '',
                      typeSeance: '',
                      placesDisponibles: 0,
                      prixNormal: 0,
                      prixReduit: 0,
                      prixSenior: 0,
                      prixEnfant: 0);

              Color statusColor = Colors.orange;
              if (r.statut == 'confirme')  statusColor = Colors.green;
              if (r.statut == 'rembourse') statusColor = Colors.blue;
              if (r.statut == 'annule')    statusColor = Colors.orange;

              // ─── CARTE MOBILE ────────────────────────────────────────
              if (isNarrow) {
                return GestureDetector(
                  onTap: () => _showDetail(
                      context, r, user!, film ?? Film(titre: "N/A"), seanceDisplay),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.07)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(user!.nom,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                      (r.statut ?? '').toUpperCase(),
                                      style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ]),
                          const SizedBox(height: 6),
                          Text(film?.titre ?? "N/A",
                              style: const TextStyle(
                                  color: Colors.amber, fontSize: 13)),
                          const SizedBox(height: 4),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(seanceDisplay.dateHeure),
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 11)),
                                Text("${r.montantTotal} DH",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ]),
                        ]),
                  ),
                );
              }

              // ─── LIGNE DESKTOP ───────────────────────────────────────
              return GestureDetector(
                onTap: () => _showDetail(
                    context, r, user!, film ?? Film(titre: "N/A"), seanceDisplay),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(8),
                    border:
                    Border.all(color: Colors.white.withOpacity(0.03)),
                  ),
                  child: Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(user!.nom,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13))),
                    Expanded(
                        flex: 2,
                        child: Text(film?.titre ?? "N/A",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13))),
                    Expanded(
                        flex: 2,
                        child: Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(seanceDisplay.dateHeure),
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12))),
                    Expanded(
                        flex: 1,
                        child: Text("${r.montantTotal} DH",
                            style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 13))),
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text((r.statut ?? '').toUpperCase(),
                              style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ]),
                ),
              );
            }).toList(),
          ]),
        );
      },
    );
  }

  // ── Dialog détail ────────────────────────────────────────────────────────────
  void _showDetail(BuildContext context, Reservation r, Utilisateur user,
      Film film, Seance seance) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("Réservation #${r.id}",
            style: const TextStyle(
                color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow("Client",    user.nom),
              _detailRow("Email",     user.email),
              _detailRow("Téléphone", user.telephone ?? "N/A"),
              const Divider(color: Colors.white10),
              _detailRow("Film",       film.titre),
              _detailRow("Date",
                  DateFormat('dd/MM/yyyy à HH:mm').format(seance.dateHeure)),
              _detailRow("Projection", seance.typeProjection ?? "N/A"),
              _detailRow("Langue",     seance.langue ?? "N/A"),
              const Divider(color: Colors.white10),
              _detailRow("Montant", "${r.montantTotal} DH"),
              _detailRow("Statut",  (r.statut ?? 'inconnu').toUpperCase()),
              if (r.montantApresReduction != null)
                _detailRow("Remboursé", "${r.montantApresReduction} DH"),
            ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
              const Text("FERMER", style: TextStyle(color: Colors.amber))),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        SizedBox(
            width: 100,
            child: Text(label,
                style:
                const TextStyle(color: Colors.white38, fontSize: 13))),
        Expanded(
            child: Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 13))),
      ]),
    );
  }
}