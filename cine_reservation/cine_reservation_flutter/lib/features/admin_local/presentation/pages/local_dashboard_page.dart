import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

class LocalDashboardPage extends ConsumerWidget {
  const LocalDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminAsync   = ref.watch(adminProfileProvider);
    final filmsAsync   = ref.watch(allFilmsProvider);
    final seancesAsync = ref.watch(allSeancesProvider);
    final resAsync     = ref.watch(allReservationsProvider);
    final usersAsync   = ref.watch(allClientsProvider);
    final sallesAsync  = ref.watch(allSallesProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);
    final isMobile     = MediaQuery.of(context).size.width < 768;

    return adminAsync.when(
      data: (admin) {
        final cinemaId = admin?.cinemaId;
        final nomCine = cinemasAsync.value
            ?.firstWhere((c) => c.id == cinemaId, orElse: () => Cinema(nom: "LOCAL", adresse: "", ville: ""))
            .nom ?? "LOCAL";

        final allSeances = seancesAsync.value ?? [];
        final allSalles  = sallesAsync.value  ?? [];
        final allFilms   = filmsAsync.value   ?? [];
        final allUsers   = usersAsync.value   ?? [];

        // ✅ Filtre double : cinemaId direct OU via seance → salle
        final listRes = (resAsync.value ?? []).where((r) {
          if (r.typeReservation == 'evenement') return false;
          if (r.cinemaId != null) return r.cinemaId == cinemaId;
          if (r.seanceId != null) {
            try {
              final seance = allSeances.firstWhere((s) => s.id == r.seanceId);
              final salle  = allSalles.firstWhere((s) => s.id == seance.salleId);
              return salle.cinemaId == cinemaId;
            } catch (_) { return false; }
          }
          return false;
        }).toList()
          ..sort((a, b) => b.dateReservation.compareTo(a.dateReservation));

        final totalFilms   = allFilms.where((f) => f.cinemaId == cinemaId).length;
        final totalSeances = allSeances.where((s) {
          try {
            final salle = allSalles.firstWhere((sl) => sl.id == s.salleId);
            return salle.cinemaId == cinemaId;
          } catch (_) { return false; }
        }).length;
        final double revenu = listRes.fold(0.0, (sum, r) => sum + r.montantTotal);

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: isMobile ? const Drawer(
            backgroundColor: Color(0xFF0D0A08),
            child: LocalAdminSidebar(),
          ) : null,
          appBar: isMobile ? AppBar(
            backgroundColor: const Color(0xFF0D0A08),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              nomCine.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : null,
          body: Row(
          children: [
              if (!isMobile) const LocalAdminSidebar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 20 : 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(nomCine, cinemaId, isMobile),
                      const SizedBox(height: 40),

                      // ── Stats ──────────────────────────────────────────
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isMobile ? 2 : 4,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: isMobile ? 1.1 : 1.3,
                        children: [
                          _statCard("FILMS",        "$totalFilms",               Icons.movie_rounded,               Colors.blue,   isMobile),
                          _statCard("SÉANCES",      "$totalSeances",             Icons.schedule_rounded,            Colors.orange, isMobile),
                          _statCard("RÉSERVATIONS", "${listRes.length}",         Icons.confirmation_number_rounded, Colors.green,  isMobile),
                          _statCard("REVENUS",      "${revenu.toStringAsFixed(0)} DH", Icons.payments_rounded,     Colors.amber,  isMobile),
                        ],
                      ),

                      const SizedBox(height: 40),
                      const Text(
                        "DERNIÈRES RÉSERVATIONS",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // ── Recent reservations ────────────────────────────
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listRes.length > 5 ? 5 : listRes.length,
                        itemBuilder: (context, index) {
                          final res = listRes[index];

                          // Infos client
                          final user = allUsers.firstWhere(
                                (u) => u.id == res.utilisateurId,
                            orElse: () => Utilisateur(nom: "Client #${res.utilisateurId}", email: ""),
                          );

                          // Infos film
                          String filmTitre = "—";
                          String salleNom  = "—";
                          if (res.seanceId != null) {
                            try {
                              final seance = allSeances.firstWhere((s) => s.id == res.seanceId);
                              final film   = allFilms.firstWhere((f) => f.id == seance.filmId);
                              final salle  = allSalles.firstWhere((s) => s.id == seance.salleId);
                              filmTitre = film.titre;
                              salleNom  = salle.codeSalle;
                            } catch (_) {}
                          }

                          return Card(
                            color: AppColors.cardBg,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  // Icône statut
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _statutColor(res.statut).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.confirmation_number_rounded,
                                      color: _statutColor(res.statut),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Infos
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.nom,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          filmTitre != "—"
                                              ? "$filmTitre • $salleNom"
                                              : "Réservation #${res.id}",
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateFormat('dd MMM HH:mm').format(res.dateReservation),
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Montant + statut
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${res.montantTotal.toStringAsFixed(0)} DH",
                                        style: const TextStyle(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _statutColor(res.statut).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          (res.statut ?? "N/A").toUpperCase(),
                                          style: TextStyle(
                                            color: _statutColor(res.statut),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Erreur: $e"))),
    );
  }

  Color _statutColor(String? statut) {
    switch (statut) {
      case 'confirme':  return Colors.green;
      case 'annule':    return Colors.orange;
      case 'rembourse': return Colors.blue;
      default:          return Colors.white54;
    }
  }

  Widget _buildHeader(String nom, int? id, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PANEL DE GESTION $nom",
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
          "MÉGARAMA $nom",
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 15),
          Text(value, style: TextStyle(color: Colors.white, fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}