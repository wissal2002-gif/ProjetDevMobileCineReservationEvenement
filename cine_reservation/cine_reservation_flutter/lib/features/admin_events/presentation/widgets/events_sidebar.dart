import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

class EventsSidebar extends ConsumerWidget {
  const EventsSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(adminProfileProvider).value;
    final String currentRoute = GoRouterState.of(context).uri.path;

    // ✅ Même logique que LocalDashboardPage
    final cinemas = ref.watch(allCinemasProvider).value ?? [];
    final nomCinema = admin?.cinemaId != null
        ? cinemas.firstWhere(
          (c) => c.id == admin!.cinemaId,
      orElse: () => Cinema(nom: '', adresse: '', ville: ''),
    ).nom
        : null;

    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        children: [
          _buildHeader(admin, nomCinema),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: [
                _sectionTitle("PRINCIPAL"),
                _navItem(context, Icons.dashboard_customize_rounded, "Tableau de Bord", "/admin/events", currentRoute),

                const SizedBox(height: 15),
                _sectionTitle("GESTION ÉVÉNEMENTIELLE"),
                _navItem(context, Icons.event_available_rounded, "Gérer les Événements", "/admin/events/manage", currentRoute),
                _navItem(context, Icons.add_circle_outline_rounded, "Nouvel Événement", "/admin/events/add", currentRoute),

                const SizedBox(height: 15),
                _sectionTitle("SUIVI & FINANCES"),
                _navItem(context, Icons.confirmation_num_rounded, "Réservations Tickets", "/admin/events/reservations", currentRoute),
                _navItem(context, Icons.account_balance_wallet_rounded, "Revenus & Stats", "/admin/events/revenus", currentRoute),
                // Dans la section SUIVI & FINANCES, ajouter :
                _navItem(context, Icons.bar_chart_rounded, "Statistiques Globales", "/admin/events/stats", currentRoute),
              ],
            ),
          ),
          const Divider(color: Colors.white10, indent: 20, endIndent: 20),
          _navItem(context, Icons.logout_rounded, "Quitter l'Espace", "/home", currentRoute, isExit: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, String route, String currentRoute, {bool isExit = false}) {
    final bool isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () {
          if (currentRoute != route) {
            context.push(route);
          }
        },
        mouseCursor: SystemMouseCursors.click,
        hoverColor: Colors.white.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isSelected ? AppColors.accent.withOpacity(0.15) : Colors.transparent,
        leading: Icon(
          icon,
          color: isSelected ? AppColors.accent : (isExit ? Colors.redAccent : Colors.white54),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isExit ? Colors.redAccent : Colors.white70),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      ),
    );
  }

  Widget _buildHeader(Utilisateur? admin, String? nomCinema) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.accent.withOpacity(0.2), Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.accent,
            child: const Icon(Icons.star_rounded, color: Colors.black, size: 30),
          ),
          const SizedBox(height: 15),

          // ✅ Nom du responsable
          if (admin?.nom != null)
            Text(
              admin!.nom.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2),
            ),

          const SizedBox(height: 4),
          const Text(
            "RESP. ÉVÉNEMENTS",
            style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
                letterSpacing: 1),
          ),

          const SizedBox(height: 8),

          // ✅ Nom du cinéma récupéré via allCinemasProvider
          if (nomCinema != null && nomCinema.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: Text(
                nomCinema.toUpperCase(),
                style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),

          const SizedBox(height: 6),
          Text(
            "Gestion des Spectacles & Festivals",
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
            color: AppColors.accent.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1),
      ),
    );
  }
}