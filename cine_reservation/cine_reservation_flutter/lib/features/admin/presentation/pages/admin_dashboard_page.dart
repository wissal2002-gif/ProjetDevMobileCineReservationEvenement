import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);
    final reservationsAsync = ref.watch(allReservationsProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);
    final supportAsync = ref.watch(allDemandesSupportProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),

                  // ─── CARTES STATISTIQUES PRINCIPALES ───
                  statsAsync.when(
                    data: (stats) => _buildStatGrid(stats),
                    loading: () => const LinearProgressIndicator(color: AppColors.accent),
                    error: (err, _) => Text("Erreur stats: $err", style: const TextStyle(color: Colors.red)),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── ACTIONS REQUISES ───
                      Expanded(
                        flex: 3,
                        child: _buildActionList(context, supportAsync, reservationsAsync),
                      ),
                      const SizedBox(width: 32),
                      // ─── TOP FILMS ───
                      Expanded(
                        flex: 2,
                        child: _buildTopFilms(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ─── DERNIÈRES RÉSERVATIONS (TABLEAU) ───
                  _buildRecentReservationsTable(context, reservationsAsync, usersAsync),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tableau de Bord",
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Text(
              "Bienvenue 👋 Voici un aperçu de votre activité aujourd'hui",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.accent, size: 16),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now()),
                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _iconBadgeButton(Icons.notifications_none_rounded, true),
          ],
        )
      ],
    );
  }

  Widget _buildStatGrid(Map<String, int> stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = (constraints.maxWidth - 60) / 4;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _statCard("FILMS", "${stats['totalFilms'] ?? 0}", Icons.movie_outlined, Colors.blue, width),
            _statCard("ÉVÉNEMENTS", "${stats['totalEvents'] ?? 0}", Icons.event_available_outlined, Colors.orange, width),
            _statCard("RÉSERVATIONS", "${stats['totalReservations'] ?? 0}", Icons.confirmation_number_outlined, Colors.green, width),
            _statCard("UTILISATEURS", "${stats['totalUsers'] ?? 0}", Icons.people_outline, Colors.purple, width),
          ],
        );
      },
    );
  }

  Widget _buildActionList(BuildContext context, AsyncValue<List<DemandeSupport>> support, AsyncValue<List<Reservation>> res) {
    int pendingSupport = support.maybeWhen(data: (l) => l.where((d) => d.statut != 'traité').length, orElse: () => 0);
    int pendingRes = res.maybeWhen(data: (l) => l.where((r) => r.statut == 'en_attente').length, orElse: () => 0);

    return _dashboardBlock(
      title: "⚡ Actions Requises",
      headerAction: TextButton(onPressed: () {}, child: const Text("Voir tout", style: TextStyle(color: Colors.white38, fontSize: 12))),
      child: Column(
        children: [
          _actionRow(context, Icons.chat_bubble_outline, "$pendingSupport demandes support", "En attente de réponse", "Répondre", "/admin/support"),
          _actionRow(context, Icons.confirmation_number_outlined, "$pendingRes réservations en attente", "À confirmer", "Valider", "/admin/reservations"),
          _actionRow(context, Icons.local_offer_outlined, "codes promo expirés", "NOEL25, SUMMER25", "Gérer", "/admin/promos"),
          _actionRow(context, Icons.movie_filter_outlined, "Séance ce soir ", "Inception — Salle 1", "Détails", "/admin/seances"),
        ],
      ),
    );
  }

  Widget _buildTopFilms() {
    return _dashboardBlock(
      title: "🏆 Top Films",
      subtitle: "Par nombre de réservations",
      child: Column(
        children: [
          _topFilmItem("1", "Inception", "Sci-Fi • Nolan", 0.9, "45", Colors.amber),
          _topFilmItem("2", "Dune: Part 2", "Sci-Fi • Villeneuve", 0.75, "34", Colors.blue),
          _topFilmItem("3", "Gladiator II", "Action • Scott", 0.55, "25", Colors.orange),
          _topFilmItem("4", "Vaiana 2", "Animation • Disney", 0.4, "18", Colors.green),
          _topFilmItem("5", "Interstellar", "Sci-Fi • Nolan", 0.25, "12", Colors.purple),
        ],
      ),
    );
  }

  Widget _buildRecentReservationsTable(BuildContext context, AsyncValue<List<Reservation>> resAsync, AsyncValue<List<Utilisateur>> usersAsync) {
    return _dashboardBlock(
      title: "📋 Dernières Réservations",
      subtitle: "Activité en temps réel",
      headerAction: TextButton(onPressed: () => context.go('/admin/reservations'), child: const Text("Voir toutes →", style: TextStyle(color: Colors.white38, fontSize: 12))),
      child: resAsync.when(
        data: (reservations) => usersAsync.when(
          data: (users) {
            final recent = reservations.take(6).toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                horizontalMargin: 0,
                columnSpacing: 40,
                columns: const [
                  DataColumn(label: Text("#", style: TextStyle(color: Colors.white38, fontSize: 11))),
                  DataColumn(label: Text("UTILISATEUR", style: TextStyle(color: Colors.white38, fontSize: 11))),
                  DataColumn(label: Text("FILM / ÉVÉNEMENT", style: TextStyle(color: Colors.white38, fontSize: 11))),
                  DataColumn(label: Text("MONTANT", style: TextStyle(color: Colors.white38, fontSize: 11))),
                  DataColumn(label: Text("STATUT", style: TextStyle(color: Colors.white38, fontSize: 11))),
                  DataColumn(label: Text("HEURE", style: TextStyle(color: Colors.white38, fontSize: 11))),
                ],
                rows: recent.map((r) {
                  final user = users.firstWhere((u) => u.id == r.utilisateurId, orElse: () => Utilisateur(nom: "Inconnu", email: ""));
                  return DataRow(cells: [
                    DataCell(Text("#${r.id.toString().padLeft(3, '0')}", style: const TextStyle(color: Colors.white54, fontSize: 12))),
                    DataCell(Row(
                      children: [
                        CircleAvatar(radius: 12, backgroundColor: AppColors.accent.withOpacity(0.1), child: Text(user.nom[0], style: const TextStyle(color: AppColors.accent, fontSize: 10))),
                        const SizedBox(width: 8),
                        Text(user.nom, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    )),
                    DataCell(Text(r.typeReservation == 'cinema' ? "Film" : "Événement", style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text("${r.montantTotal} DH", style: TextStyle(color: r.statut == 'annule' ? Colors.redAccent : Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(_statusChip(r.statut)),
                    DataCell(Text(DateFormat('HH:mm').format(r.dateReservation), style: const TextStyle(color: Colors.white38, fontSize: 12))),
                  ]);
                }).toList(),
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox(),
        ),
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  // --- Helpers UI ---

  Widget _statCard(String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 24),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _dashboardBlock({required String title, String? subtitle, Widget? headerAction, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(0.4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                  ]
                ],
              ),
              if (headerAction != null) headerAction,
            ],
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context, IconData icon, String title, String sub, String btn, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: Colors.white54, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ]),
          ),
          OutlinedButton(
            onPressed: () => context.go(route),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white10),
              foregroundColor: Colors.white70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(btn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _topFilmItem(String rank, String title, String info, double progress, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(rank, style: TextStyle(color: Colors.white.withOpacity(0.1), fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Monospace')),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(info, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ]),
                    Text(count, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: progress, minHeight: 4, backgroundColor: Colors.white.withOpacity(0.05), color: color.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String? status) {
    Color color = Colors.orange;
    String label = "En attente";
    if (status == 'confirme') { color = Colors.green; label = "Confirmée"; }
    if (status == 'annule') { color = Colors.red; label = "Annulée"; }
    if (status == 'rembourse') { color = Colors.blue; label = "Remboursée"; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status == 'confirme' ? Icons.check : status == 'annule' ? Icons.close : Icons.access_time, color: color, size: 10),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _iconBadgeButton(IconData icon, bool hasAlert) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
          child: Icon(icon, color: Colors.white70, size: 22),
        ),
        if (hasAlert)
          Positioned(
            top: 10,
            right: 10,
            child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, border: Border.all(color: AppColors.background, width: 1.5))),
          ),
      ],
    );
  }
}
