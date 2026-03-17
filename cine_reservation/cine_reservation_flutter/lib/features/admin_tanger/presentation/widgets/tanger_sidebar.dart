import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TangerSidebar extends StatelessWidget {
  const TangerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération sécurisée de la route
    final String currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      width: 280,
      // Fix : On s'assure que la sidebar ne prend pas une hauteur infinie sans contrainte
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: [
                _sectionTitle("PRINCIPAL"),
                _navItem(context, Icons.dashboard_rounded, "Tableau de Bord", "/admin/tanger", currentRoute),

                const SizedBox(height: 15),
                _sectionTitle("GESTION OPÉRATIONNELLE"),
                _navItem(context, Icons.movie_filter_rounded, "Gérer les Films", "/admin/tanger/films", currentRoute),
                _navItem(context, Icons.calendar_month_rounded, "Gérer les Séances", "/admin/tanger/seances", currentRoute),
                _navItem(context, Icons.meeting_room_rounded, "Gérer les Salles", "/admin/tanger/salles", currentRoute),
                _navItem(context, Icons.grid_on_rounded, "Gérer les Sièges", "/admin/tanger/sieges", currentRoute),
                _navItem(context, Icons.confirmation_number_outlined, "Codes Promo", "/admin/tanger/promos", currentRoute),

                const SizedBox(height: 15),
                _sectionTitle("RESERVATIONS & STAFF"),
                _navItem(context, Icons.confirmation_number_rounded, "Réservations", "/admin/tanger/reservations", currentRoute),
                _navItem(context, Icons.badge_rounded, "Gestion Staff", "/admin/tanger/staff", currentRoute),
                _navItem(context, Icons.account_balance_wallet_outlined, "Voir Revenus", "/admin/tanger/revenus", currentRoute),
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
        // ✅ FIX : Utilisation de push au lieu de go pour éviter le crash MouseTracker sur Chrome
        onTap: () {
          if (currentRoute != route) {
            context.push(route);
          }
        },
        // ✅ FIX : Améliore la détection du clic sur le Web
        mouseCursor: SystemMouseCursors.click,
        hoverColor: Colors.white.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isSelected ? const Color(0xFF8B7355).withOpacity(0.15) : Colors.transparent,
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF8B7355) : (isExit ? Colors.redAccent : Colors.white54),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF8B7355).withOpacity(0.2), Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF8B7355),
            child: Icon(Icons.location_city, color: Colors.black, size: 30),
          ),
          const SizedBox(height: 15),
          const Text("ADMIN TANGER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          Text("Cinéma Mégarama ID: 9", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(title, style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }
}