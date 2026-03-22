import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_sidebar.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  
  @override
  void initState() {
    super.initState();
    // Redirection automatique dès l'ouverture si c'est un admin local
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRedirection();
    });
  }

  void _checkRedirection() async {
    final profile = await ref.read(adminProfileProvider.future);
    if (profile == null) return;
    
    final email = profile.email.toLowerCase().trim();
    if (email == 'elbouzidiimane794@gmail.com' || (profile.role == 'admin_local' && profile.cinemaId == 9)) {
      if (mounted) context.go('/admin/tanger');
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionsAsync = ref.watch(dashboardActionsProvider);
    final statsAsync = ref.watch(adminStatsProvider);
    final reservationsAsync = ref.watch(allReservationsProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
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

                  statsAsync.when(
                    data: (stats) => _buildStatGrid(stats),
                    loading: () => const LinearProgressIndicator(color: Color(0xFF8B7355)),
                    error: (err, _) => Text("Erreur stats: $err"),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: actionsAsync.when(
                          data: (actions) => _buildActionList(context, actions),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text("Erreur actions: $e"),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(flex: 2, child: _buildTopFilms()),
                    ],
                  ),

                  const SizedBox(height: 40),
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
            const Text("Tableau de Bord Global", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Vision d'ensemble pour le Super Admin", 
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
          ],
        ),
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

  Widget _buildActionList(BuildContext context, Map<String, dynamic> actions) {
    return _dashboardBlock(
      title: "⚡ Actions Requises",
      subtitle: "${actions['totalItems'] ?? 0} éléments en attente",
      child: Column(
        children: [
          _actionRow(context, Icons.chat_bubble_outline, "${actions['pendingSupport']} demandes support", "Support", "Répondre", "/admin/support"),
          _actionRow(context, Icons.currency_exchange, "${actions['cancelledReservations']} annulations", "Remboursement", "Gérer", "/admin/reservations"),
        ],
      ),
    );
  }

  Widget _buildTopFilms() {
    return _dashboardBlock(
      title: "🏆 Top Films",
      child: Column(
        children: [
          _topFilmItem("1", "Inception", 0.9, "45", Colors.amber),
          _topFilmItem("2", "Dune: Part 2", 0.75, "34", Colors.blue),
        ],
      ),
    );
  }

  Widget _buildRecentReservationsTable(BuildContext context, AsyncValue<List<Reservation>> resAsync, AsyncValue<List<Utilisateur>> usersAsync) {
    return _dashboardBlock(
      title: "📋 Dernières Réservations",
      child: resAsync.when(
        data: (reservations) => usersAsync.when(
          data: (users) => _buildTable(reservations.take(5).toList(), users),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  Widget _buildTable(List<Reservation> recent, List<Utilisateur> users) {
    return DataTable(
      columns: const [
        DataColumn(label: Text("CLIENT")),
        DataColumn(label: Text("MONTANT")),
        DataColumn(label: Text("STATUT")),
      ],
      rows: recent.map((r) {
        final user = users.firstWhere((u) => u.id == r.utilisateurId, orElse: () => Utilisateur(nom: "Inconnu", email: ""));
        return DataRow(cells: [
          DataCell(Text(user.nom)),
          DataCell(Text("${r.montantTotal} DH")),
          DataCell(Text(r.statut ?? "")),
        ]);
      }).toList(),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 24),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _dashboardBlock({required String title, String? subtitle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(28)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        if (subtitle != null) Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
        const SizedBox(height: 32),
        child,
      ]),
    );
  }

  Widget _actionRow(BuildContext context, IconData i, String t, String s, String b, String r) {
    return ListTile(
      leading: Icon(i, color: Colors.white54),
      title: Text(t, style: const TextStyle(color: Colors.white)),
      subtitle: Text(s, style: const TextStyle(color: Colors.white24)),
      trailing: TextButton(onPressed: () => context.go(r), child: Text(b)),
    );
  }

  Widget _topFilmItem(String rank, String title, double progress, String count, Color color) {
    return ListTile(
      leading: Text(rank, style: const TextStyle(color: Colors.white24, fontSize: 20)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Text(count, style: const TextStyle(color: Colors.white54)),
    );
  }
}
