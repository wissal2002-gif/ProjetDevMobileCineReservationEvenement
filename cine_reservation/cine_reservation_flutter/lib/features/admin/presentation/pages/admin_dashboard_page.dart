import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_sidebar.dart';
import '../providers/admin_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkRedirection());
  }

  void _checkRedirection() async {
    final profile = await ref.read(adminProfileProvider.future);
    if (profile == null) return;
    final email = profile.email.toLowerCase().trim();
    if (email == 'elbouzidiimane794@gmail.com' ||
        (profile.role == 'admin_local' && profile.cinemaId == 9)) {
      if (mounted) context.go('/admin/tanger');
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionsAsync = ref.watch(dashboardActionsProvider);
    final statsAsync = ref.watch(adminStatsProvider);
    final reservationsAsync = ref.watch(allReservationsProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final content = SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDesktop),
          const SizedBox(height: 24),

          statsAsync.when(
            data: (stats) => _buildStatGrid(stats, isDesktop),
            loading: () => const LinearProgressIndicator(
                color: Color(0xFF8B7355)),
            error: (err, _) =>
                Text("Erreur stats: $err",
                    style: const TextStyle(color: Colors.red)),
          ),

          const SizedBox(height: 32),

          // Sur mobile : colonne, sur desktop : row
          isDesktop
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: actionsAsync.when(
                  data: (a) => _buildActionList(context, a),
                  loading: () => const Center(
                      child: CircularProgressIndicator()),
                  error: (e, _) => Text("Erreur: $e"),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: _buildTopFilms()),
            ],
          )
              : Column(
            children: [
              actionsAsync.when(
                data: (a) => _buildActionList(context, a),
                loading: () => const Center(
                    child: CircularProgressIndicator()),
                error: (e, _) => Text("Erreur: $e"),
              ),
              const SizedBox(height: 16),
              _buildTopFilms(),
            ],
          ),

          const SizedBox(height: 32),
          _buildRecentReservationsTable(
              context, reservationsAsync, usersAsync, isDesktop),
        ],
      ),
    );

    // ── Desktop : sidebar fixe à gauche ──────────────────
    if (isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0A08),
        body: Row(
          children: [
            const AdminSidebar(),
            Expanded(child: content),
          ],
        ),
      );
    }

    // ── Mobile : drawer ───────────────────────────────────
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0A08),
        title: const Text('Admin Dashboard',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Drawer(
        backgroundColor: Color(0xFF1A1410),
        child: AdminSidebar(),
      ),
      body: content,
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tableau de Bord Global",
            style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 32 : 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("Vision d'ensemble pour le Super Admin",
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isDesktop ? 14 : 12)),
      ],
    );
  }

  Widget _buildStatGrid(Map<String, int> stats, bool isDesktop) {
    final items = [
      _StatItem("FILMS", "${stats['totalFilms'] ?? 0}",
          Icons.movie_outlined, Colors.blue),
      _StatItem("ÉVÉNEMENTS", "${stats['totalEvents'] ?? 0}",
          Icons.event_available_outlined, Colors.orange),
      _StatItem("RÉSERVATIONS", "${stats['totalReservations'] ?? 0}",
          Icons.confirmation_number_outlined, Colors.green),
      _StatItem("UTILISATEURS", "${stats['totalUsers'] ?? 0}",
          Icons.people_outline, Colors.purple),
    ];

    if (isDesktop) {
      return Row(
        children: items
            .map((item) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _statCard(item),
          ),
        ))
            .toList(),
      );
    }

    // Mobile : grille 2x2
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: items.map((item) => _statCard(item)).toList(),
    );
  }

  Widget _statCard(_StatItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(item.icon, color: item.color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              Text(item.title,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionList(
      BuildContext context, Map<String, dynamic> actions) {
    return _dashboardBlock(
      title: "⚡ Actions Requises",
      subtitle: "${actions['totalItems'] ?? 0} éléments en attente",
      child: Column(children: [
        _actionRow(context, Icons.chat_bubble_outline,
            "${actions['pendingSupport']} demandes support",
            "Support", "Répondre", "/admin/support"),
        _actionRow(context, Icons.currency_exchange,
            "${actions['cancelledReservations']} annulations",
            "Remboursement", "Gérer", "/admin/reservations"),
      ]),
    );
  }

  Widget _buildTopFilms() {
    return _dashboardBlock(
      title: "🏆 Top Films",
      child: Column(children: [
        _topFilmItem("1", "Inception", "45", Colors.amber),
        _topFilmItem("2", "Dune: Part 2", "34", Colors.blue),
      ]),
    );
  }

  Widget _buildRecentReservationsTable(
      BuildContext context,
      AsyncValue<List<Reservation>> resAsync,
      AsyncValue<List<Utilisateur>> usersAsync,
      bool isDesktop,
      ) {
    return _dashboardBlock(
      title: "📋 Dernières Réservations",
      child: resAsync.when(
        data: (reservations) => usersAsync.when(
          data: (users) =>
              _buildTable(reservations.take(5).toList(), users, isDesktop),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  Widget _buildTable(
      List<Reservation> recent, List<Utilisateur> users, bool isDesktop) {
    if (recent.isEmpty) {
      return const Text('Aucune réservation',
          style: TextStyle(color: Colors.white54));
    }

    // Mobile : liste de cards au lieu d'un DataTable qui déborde
    if (!isDesktop) {
      return Column(
        children: recent.map((r) {
          final user = users.firstWhere((u) => u.id == r.utilisateurId,
              orElse: () => Utilisateur(nom: "Inconnu", email: ""));
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(user.nom,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Text("${r.montantTotal} MAD",
                    style: const TextStyle(color: Color(0xFF8B7355))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statutColor(r.statut).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(r.statut ?? '',
                      style: TextStyle(
                          color: _statutColor(r.statut), fontSize: 10)),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    // Desktop : DataTable classique
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
              label: Text("CLIENT",
                  style: TextStyle(color: Colors.white54))),
          DataColumn(
              label: Text("MONTANT",
                  style: TextStyle(color: Colors.white54))),
          DataColumn(
              label: Text("STATUT",
                  style: TextStyle(color: Colors.white54))),
        ],
        rows: recent.map((r) {
          final user = users.firstWhere((u) => u.id == r.utilisateurId,
              orElse: () => Utilisateur(nom: "Inconnu", email: ""));
          return DataRow(cells: [
            DataCell(Text(user.nom,
                style: const TextStyle(color: Colors.white))),
            DataCell(Text("${r.montantTotal} MAD",
                style: const TextStyle(color: Colors.white))),
            DataCell(Text(r.statut ?? '',
                style: const TextStyle(color: Colors.white))),
          ]);
        }).toList(),
      ),
    );
  }

  Color _statutColor(String? s) {
    switch (s) {
      case 'confirmee': return Colors.green;
      case 'en_attente': return Colors.orange;
      case 'annule': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _dashboardBlock(
      {required String title, String? subtitle, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        if (subtitle != null)
          Text(subtitle,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.3), fontSize: 11)),
        const SizedBox(height: 20),
        child,
      ]),
    );
  }

  Widget _actionRow(BuildContext context, IconData i, String t, String s,
      String b, String r) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(i, color: Colors.white54, size: 20),
      title: Text(t,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      subtitle: Text(s,
          style: const TextStyle(color: Colors.white24, fontSize: 11)),
      trailing: TextButton(
        onPressed: () => context.go(r),
        child: Text(b,
            style: const TextStyle(color: Color(0xFF8B7355))),
      ),
    );
  }

  Widget _topFilmItem(
      String rank, String title, String count, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(rank,
          style: TextStyle(
              color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
      trailing: Text(count,
          style: const TextStyle(color: Colors.white54)),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatItem(this.title, this.value, this.icon, this.color);
}