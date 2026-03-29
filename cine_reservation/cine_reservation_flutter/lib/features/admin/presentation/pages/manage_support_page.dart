import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManageSupportPage extends ConsumerStatefulWidget {
  const ManageSupportPage({super.key});

  @override
  ConsumerState<ManageSupportPage> createState() =>
      _ManageSupportPageState();
}

class _ManageSupportPageState extends ConsumerState<ManageSupportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _filtreCinemaId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supportAsync = ref.watch(allDemandesSupportProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "SUPPORT CLIENT — VUE GLOBALE",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            tooltip: "Actualiser",
            onPressed: () {
              ref.invalidate(allDemandesSupportProvider);
              ref.invalidate(allUtilisateursProvider);
              ref.invalidate(allCinemasProvider);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(icon: Icon(Icons.bar_chart_rounded, size: 18),
                text: "STATS"),
            Tab(icon: Icon(Icons.business_rounded, size: 18),
                text: "PAR CINÉMA"),
            Tab(icon: Icon(Icons.list_alt_rounded, size: 18),
                text: "DEMANDES"),
          ],
        ),
      ),
      body: supportAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(
            child: Text("Erreur: $e",
                style: const TextStyle(color: Colors.redAccent))),
        data: (demandes) => usersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Erreur: $e")),
          data: (users) => cinemasAsync.when(
            loading: () =>
            const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Erreur: $e")),
            data: (cinemas) {
              // Filtrage
              final filtered = _filtreCinemaId == null
                  ? demandes
                  : demandes
                  .where((d) => d.cinemaId == _filtreCinemaId)
                  .toList();

              return TabBarView(
                controller: _tabController,
                children: [
                  // ── Tab 1 : Stats globales ──────────────────
                  _buildStatsTab(demandes, cinemas),

                  // ── Tab 2 : Par cinéma ──────────────────────
                  _buildParCinemaTab(demandes, cinemas),

                  // ── Tab 3 : Liste demandes ──────────────────
                  _buildDemandesTab(
                      filtered, users, cinemas),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ── TAB 1 : STATS GLOBALES ────────────────────────────────────────────────
  Widget _buildStatsTab(
      List<DemandeSupport> demandes, List<Cinema> cinemas) {
    final total = demandes.length;
    final enAttente =
        demandes.where((d) => d.statut == 'ouvert').length;
    final traitees =
        demandes.where((d) => d.statut == 'traité').length;
    final tauxReponse =
    total > 0 ? (traitees / total * 100).toStringAsFixed(0) : '0';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Cards stats ──────────────────────────────────────
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _statCard("TOTAL", "$total",
                Icons.inbox_rounded, Colors.blue),
            _statCard("EN ATTENTE", "$enAttente",
                Icons.pending_rounded, Colors.orange),
            _statCard("TRAITÉS", "$traitees",
                Icons.check_circle_rounded, Colors.green),
            _statCard("TAUX RÉPONSE", "$tauxReponse%",
                Icons.percent_rounded, AppColors.accent),
          ],
        ),

        const SizedBox(height: 28),

        // ── Progression globale ──────────────────────────────
        const Text("PROGRESSION GLOBALE",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border:
            Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            children: [
              _progressRow("Traitées", traitees, total,
                  Colors.green),
              const SizedBox(height: 12),
              _progressRow("En attente", enAttente, total,
                  Colors.orange),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // ── Dernières demandes non traitées ──────────────────
        const Text("NON TRAITÉES — PRIORITÉ",
            style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        ...demandes
            .where((d) => d.statut == 'ouvert')
            .take(5)
            .map((d) {
          final cinemaName = cinemas
              .firstWhere((c) => c.id == d.cinemaId,
              orElse: () =>
                  Cinema(nom: 'Super Admin', adresse: '', ville: ''))
              .nom;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.orange.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.pending_rounded,
                    color: Colors.orange, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(d.sujet,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      Text(cinemaName,
                          style: TextStyle(
                              color: Colors.white
                                  .withOpacity(0.4),
                              fontSize: 11)),
                    ],
                  ),
                ),
                Text(
                  DateFormat('dd/MM').format(
                      d.createdAt ?? DateTime.now()),
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 11),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── TAB 2 : PAR CINÉMA ───────────────────────────────────────────────────
  Widget _buildParCinemaTab(
      List<DemandeSupport> demandes, List<Cinema> cinemas) {
    // Grouper par cinéma
    final Map<String, Map<String, int>> statsParCinema = {};

    // Super Admin (cinemaId == null)
    final superAdmin = demandes.where((d) => d.cinemaId == null);
    statsParCinema['Super Admin'] = {
      'total': superAdmin.length,
      'ouvert': superAdmin.where((d) => d.statut == 'ouvert').length,
      'traite': superAdmin.where((d) => d.statut == 'traité').length,
    };

    for (final cinema in cinemas) {
      final cinemaD =
      demandes.where((d) => d.cinemaId == cinema.id).toList();
      statsParCinema[cinema.nom] = {
        'total': cinemaD.length,
        'ouvert':
        cinemaD.where((d) => d.statut == 'ouvert').length,
        'traite':
        cinemaD.where((d) => d.statut == 'traité').length,
        'cinemaId': cinema.id ?? 0,
      };
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("STATISTIQUES PAR CINÉMA",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.2)),
        const SizedBox(height: 16),

        ...statsParCinema.entries.map((entry) {
          final nom = entry.key;
          final stats = entry.value;
          final total = stats['total'] ?? 0;
          final ouvert = stats['ouvert'] ?? 0;
          final traite = stats['traite'] ?? 0;
          final cinemaId = stats['cinemaId'];
          final pct = total > 0 ? traite / total : 0.0;

          return GestureDetector(
            onTap: () {
              // Naviguer vers l'onglet demandes filtré
              setState(() => _filtreCinemaId =
              cinemaId == 0 ? null : cinemaId);
              _tabController.animateTo(2);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accent
                                  .withOpacity(0.1),
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Icon(
                              nom == 'Super Admin'
                                  ? Icons.admin_panel_settings_rounded
                                  : Icons.business_rounded,
                              color: AppColors.accent,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(nom,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Voir →",
                            style: TextStyle(
                                color: AppColors.accent
                                    .withOpacity(0.6),
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Barre progression
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor:
                      Colors.white.withOpacity(0.06),
                      valueColor: AlwaysStoppedAnimation(
                        pct == 1.0
                            ? Colors.green
                            : pct > 0.5
                            ? Colors.lightGreen
                            : Colors.orange,
                      ),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _badge("$total total", Colors.blue),
                      const SizedBox(width: 8),
                      _badge("$ouvert en attente",
                          Colors.orange),
                      const SizedBox(width: 8),
                      _badge("$traite traités", Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── TAB 3 : LISTE DEMANDES ────────────────────────────────────────────────
  Widget _buildDemandesTab(List<DemandeSupport> demandes,
      List<Utilisateur> users, List<Cinema> cinemas) {
    return Column(
      children: [
        // Filtre cinéma
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip("Tous", null, cinemas),
                ...cinemas.map(
                        (c) => _filterChip(c.nom, c.id, cinemas)),
              ],
            ),
          ),
        ),

        // Compteur
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${demandes.length} demande(s)",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 12),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: demandes.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.support_agent_outlined,
                    size: 48,
                    color: Colors.white.withOpacity(0.1)),
                const SizedBox(height: 12),
                Text("Aucune demande",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.3))),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: 16),
            itemCount: demandes.length,
            itemBuilder: (context, index) {
              final d = demandes[index];
              final user = users.firstWhere(
                      (u) => u.id == d.utilisateurId,
                  orElse: () =>
                      Utilisateur(nom: "Client", email: ""));
              final cinemaName = d.cinemaId == null
                  ? "Super Admin"
                  : cinemas
                  .firstWhere((c) => c.id == d.cinemaId,
                  orElse: () => Cinema(
                      nom: 'Cinéma',
                      adresse: '',
                      ville: ''))
                  .nom;
              return _buildDemandeCard(
                  context, d, user, cinemaName);
            },
          ),
        ),
      ],
    );
  }

  // ── Card Demande ──────────────────────────────────────────────────────────
  Widget _buildDemandeCard(BuildContext context,
      DemandeSupport d, Utilisateur user, String cinemaName) {
    final isClosed = d.statut == 'traité';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isClosed
              ? Colors.green.withOpacity(0.15)
              : Colors.orange.withOpacity(0.15),
        ),
      ),
      child: Theme(
        data: Theme.of(context)
            .copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isClosed
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isClosed
                  ? Icons.check_circle_rounded
                  : Icons.pending_rounded,
              color: isClosed ? Colors.green : Colors.orange,
              size: 18,
            ),
          ),
          title: Text(d.sujet,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(cinemaName,
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                Text(
                  "${user.nom} • ${DateFormat('dd/MM/yyyy HH:mm').format(d.createdAt ?? DateTime.now())}",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                  const Text("MESSAGE",
                      style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Text(d.message,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13)),
                  ),
                  const SizedBox(height: 14),
                  if (d.reponse != null) ...[
                    const Text("RÉPONSE",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Text(d.reponse!,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontStyle: FontStyle.italic)),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showReplyDialog(context, d),
                        icon: const Icon(Icons.reply_rounded,
                            size: 16),
                        label: const Text("RÉPONDRE"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog Réponse ────────────────────────────────────────────────────────
  void _showReplyDialog(BuildContext context, DemandeSupport d) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("RÉPONDRE",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Votre réponse...",
            hintStyle:
            TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              const BorderSide(color: AppColors.accent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ANNULER",
                style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (ctrl.text.isEmpty) return;
              await client.admin.repondreDemande(d.id!, ctrl.text);
              ref.invalidate(allDemandesSupportProvider);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Réponse envoyée !"),
                      backgroundColor: Colors.green),
                );
              }
            },
            child: const Text("ENVOYER",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Widgets utilitaires ───────────────────────────────────────────────────

  Widget _statCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _progressRow(
      String label, int value, int total, Color color) {
    final pct = total > 0 ? value / total : 0.0;
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text("$value",
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _filterChip(
      String label, int? cinemaId, List<Cinema> cinemas) {
    final isSelected = _filtreCinemaId == cinemaId;
    return GestureDetector(
      onTap: () => setState(() => _filtreCinemaId = cinemaId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withOpacity(0.15)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accent.withOpacity(0.5)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected
                    ? AppColors.accent
                    : Colors.white54,
                fontSize: 12,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal)),
      ),
    );
  }
}