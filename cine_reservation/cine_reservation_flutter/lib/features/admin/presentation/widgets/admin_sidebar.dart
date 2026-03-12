import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(right: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          // En-tête fixe
          const DrawerHeader(
            child: Center(
              child: Text(
                "CineReservation\nADMIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Partie défilable
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _navItem(context, Icons.dashboard_outlined, "Tableau de Bord", "/admin"),
                const Divider(color: Colors.white10, indent: 20, endIndent: 20),
                _navItem(context, Icons.movie_outlined, "Gestion Films", "/admin/films"),
                _navItem(context, Icons.calendar_month_outlined, "Gestion Séances", "/admin/seances"),
                _navItem(context, Icons.business_outlined, "Gestion Cinémas", "/admin/cinemas"),
                _navItem(context, Icons.grid_on_outlined, "Gestion Sièges", "/admin/sieges"),
                _navItem(context, Icons.fastfood_outlined, "Gestion Options", "/admin/options"),
                _navItem(context, Icons.event_note_outlined, "Gestion Événements", "/admin/evenements"),
                _navItem(context, Icons.local_offer_outlined, "Gestion Promotions", "/admin/promos"),
                const Divider(color: Colors.white10, indent: 20, endIndent: 20),
                _navItem(context, Icons.people_outline, "Utilisateurs", "/admin/users"),
                _navItem(context, Icons.confirmation_number_outlined, "Réservations", "/admin/reservations"),
                _navItem(context, Icons.support_agent_outlined, "Support & FAQ", "/admin/support"),
              ],
            ),
          ),

          // Bas de la barre (Fixe)
          const Divider(color: Colors.white10, height: 1),
          _navItem(context, Icons.logout, "Quitter Admin", "/home", color: Colors.redAccent),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, String route, {Color color = Colors.white}) {
    final bool isSelected = GoRouterState.of(context).uri.toString() == route;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.accent : color.withOpacity(0.6)),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : color.withOpacity(0.8),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14, // Taille légèrement réduite pour tout faire tenir
        ),
      ),
      selected: isSelected,
      onTap: () => context.go(route),
    );
  }
}
