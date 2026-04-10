import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/events_sidebar.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../../../../main.dart'; // ✅ AJOUTER pour accéder à client

class EventsDashboardPage extends ConsumerStatefulWidget {
  const EventsDashboardPage({super.key});

  @override
  ConsumerState<EventsDashboardPage> createState() =>
      _EventsDashboardPageState();
}

class _EventsDashboardPageState extends ConsumerState<EventsDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ✅ AJOUTER après "final GlobalKey<ScaffoldState> _scaffoldKey..."
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.invalidate(allEvenementsProvider);
      ref.invalidate(allReservationsProvider);
      await _supprimerEvenementsExpires();
    });
  }

  Future<void> _supprimerEvenementsExpires() async {
    try {
      final events = ref.read(allEvenementsProvider).value ?? [];
      final now = DateTime.now();
      final expires = events.where((e) => e.dateDebut.isBefore(now)).toList();
      for (final e in expires) {
        await client.admin.supprimerEvenement(e.id!);
      }
      if (expires.isNotEmpty) {
        ref.invalidate(allEvenementsProvider);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Recharger si l'admin change
    ref.listen(adminProfileProvider, (previous, next) {
      if (previous?.value?.id != next.value?.id) {
        ref.invalidate(allEvenementsProvider);
        ref.invalidate(allReservationsProvider);
      }
    });

    final eventsAsync = ref.watch(allEvenementsProvider);
    final resAsync    = ref.watch(allReservationsProvider);
    final isMobile    = MediaQuery.of(context).size.width < 768;
    final admin       = ref.watch(adminProfileProvider).value;

    final billetsVendus = resAsync.when(
      data: (res) {
        var filtered = res.where((r) =>
        r.typeReservation == 'evenement' && r.statut != 'annule').toList();

        // ✅ Filtrer par cinéma du resp_evenements
        if (admin?.role == 'resp_evenements' && admin?.cinemaId != null) {
          final mesEventIds = (eventsAsync.value ?? [])
              .where((e) => e.cinemaId == admin!.cinemaId)
              .map((e) => e.id)
              .toSet();
          filtered = filtered
              .where((r) => mesEventIds.contains(r.evenementId))
              .toList();
        }

        return filtered.length.toString();
      },
      loading: () => "...",
      error: (_, __) => "0",
    );
    final mainContent = SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TABLEAU DE BORD ÉVÉNEMENTS",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // ─── Stats ───────────────────────────────────────────
          eventsAsync.when(
            data: (events) {
              final totalEvents  = events.length;
              final activeEvents =
                  events.where((e) => e.statut == 'actif').length;

              if (isMobile) {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    _buildStatCard("Total Événements",
                        totalEvents.toString(), Icons.event, isMobile),
                    _buildStatCard("Événements Actifs",
                        activeEvents.toString(),
                        Icons.check_circle_outline, isMobile),
                    _buildStatCard("Billets Vendus", billetsVendus,
                        Icons.confirmation_number_outlined, isMobile),
                  ],
                );
              }

              return Row(
                children: [
                  _buildStatCard("Total Événements",
                      totalEvents.toString(), Icons.event, isMobile),
                  const SizedBox(width: 20),
                  _buildStatCard("Événements Actifs",
                      activeEvents.toString(),
                      Icons.check_circle_outline, isMobile),
                  const SizedBox(width: 20),
                  _buildStatCard("Billets Vendus", billetsVendus,
                      Icons.confirmation_number_outlined, isMobile),
                ],
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accent)),
            error: (e, _) => Text("Erreur stats: $e",
                style: const TextStyle(color: Colors.red)),
          ),

          const SizedBox(height: 40),
          const Text(
            "DERNIERS ÉVÉNEMENTS",
            style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const SizedBox(height: 20),

          // ─── Liste événements ─────────────────────────────────
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return const Center(
                  child: Text("Aucun événement",
                      style: TextStyle(color: Colors.white24)),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length > 5 ? 5 : events.length,
                itemBuilder: (context, index) {
                  final ev = events[index];
                  return Card(
                    color: Colors.white.withOpacity(0.05),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: ev.affiche != null
                            ? NetworkImage(ev.affiche!)
                            : null,
                        child: ev.affiche == null
                            ? const Icon(Icons.event)
                            : null,
                      ),
                      title: Text(ev.titre,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      subtitle: Text(
                          "${ev.ville} - ${ev.prix} DH",
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right,
                          color: Colors.white24),
                      onTap: () =>
                          context.push('/event-detail', extra: ev.id),
                    ),
                  );
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );

    // ── Mobile ────────────────────────────────────────────────────
    if (isMobile) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: const Text("Tableau de bord",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        drawer: Drawer(
          backgroundColor: AppColors.background,
          child: const EventsSidebar(),
        ),
        body: mainContent,
      );
    }

    // ── Desktop ───────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const EventsSidebar(),
          Expanded(child: mainContent),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, bool isMobile) {
    Widget card = Container(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accent, size: isMobile ? 24 : 30),
          SizedBox(height: isMobile ? 8 : 16),
          Text(
            value,
            style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 28,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isMobile ? 10 : 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return isMobile ? card : Expanded(child: card);
  }
}