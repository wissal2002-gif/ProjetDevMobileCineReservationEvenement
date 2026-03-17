import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(adminProfileProvider);

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Colors.white10)),
      ),
      child: profileAsync.when(
        data: (user) {
          final String email = (user?.email ?? "").toLowerCase().trim();
          final String role = user?.role ?? 'client';
          
          // RECONNAISSANCE AMÉLIORÉE
          final bool isSuperAdmin = email == 'elbouzidi.imane@etu.uae.ac.ma' || role == 'super_admin';
          final bool isAdminTanger = email == 'elbouzidiimane794@gmail.com' || (role == 'admin_local' && user?.cinemaId == 9);
          final bool isAdminCasa = email == 'elbouzidiingenieurimanee@gmail.com' || (role == 'admin_local' && user?.cinemaId == 2);
          final bool isRespEvents = role == 'resp_evenements' || email == 'aya.elbouzidi1@etu.uae.ac.ma';

          return Column(
            children: [
              _buildAdminHeader(isSuperAdmin, isAdminTanger, isAdminCasa, isRespEvents, user?.nom ?? "Admin"),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    // ✅ REDIRECTION INTELLIGENTE SELON LE RÔLE
                    _navItem(context, Icons.dashboard_outlined, "Tableau de Bord", 
                      isSuperAdmin ? "/admin" : (isAdminTanger ? "/admin/tanger" : (isRespEvents ? "/admin/events" : "/admin"))),
                    
                    // --- ESPACE SUPER ADMIN ---
                    if (isSuperAdmin) ...[
                      _sectionTitle("ADMINISTRATION GLOBALE"),
                      _navItem(context, Icons.business_outlined, "Gestion Cinémas", "/admin/cinemas"),
                      _navItem(context, Icons.people_outline, "Utilisateurs & Rôles", "/admin/users"),
                      _navItem(context, Icons.local_offer_outlined, "Codes Promotions", "/admin/promos"),
                    ],

                    // --- ESPACE ADMIN LOCAL (TANGER OU CASA) ---
                    if (isAdminTanger || isAdminCasa || isSuperAdmin) ...[
                      _sectionTitle(isSuperAdmin ? "GESTION LOCALE (DEBUG)" : "GESTION DU SITE"),
                      _navItem(context, Icons.movie_outlined, "Gérer Films & Séances", "/admin/seances"),
                      _navItem(context, Icons.grid_on_outlined, "Salles & Sièges", "/admin/sieges"),
                      _navItem(context, Icons.fastfood_outlined, "Snacks & Options", "/admin/options"),
                      _navItem(context, Icons.confirmation_number_outlined, "Réservations", "/admin/reservations"),
                      _navItem(context, Icons.badge_outlined, "Gérer le Staff", "/admin/users"),
                    ],

                    // --- ESPACE ÉVÉNEMENTS ---
                    if (isRespEvents || isSuperAdmin) ...[
                      _sectionTitle("SPECTACLES & FESTIVALS"),
                      _navItem(context, Icons.event_note_outlined, "Gestion Événements", "/admin/events/manage"),
                    ],

                    const Divider(color: Colors.white10, height: 40, indent: 20, endIndent: 20),
                    _navItem(context, Icons.support_agent_outlined, "Support Client", "/admin/support"),
                  ],
                ),
              ),

              const Divider(color: Colors.white10, height: 1),
              _navItem(context, Icons.logout, "Quitter Admin", "/home", color: Colors.redAccent),
              const SizedBox(height: 10),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Erreur profil")),
      ),
    );
  }

  Widget _buildAdminHeader(bool isSuper, bool isTanger, bool isCasa, bool isEvents, String name) {
    String roleLabel = "ADMINISTRATEUR";
    if (isSuper) roleLabel = "SUPER ADMIN";
    else if (isTanger) roleLabel = "ADMIN CINÉVENT TANGER";
    else if (isCasa) roleLabel = "ADMIN CINÉVENT CASA";
    else if (isEvents) roleLabel = "RESP. ÉVÉNEMENTS";

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent.withOpacity(0.1), Colors.transparent],
          begin: Alignment.topCenter, end: Alignment.bottomCenter
        )
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundColor: AppColors.accent.withOpacity(0.1), child: Text(name.isNotEmpty ? name[0] : "A", style: const TextStyle(color: AppColors.accent, fontSize: 24, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
            child: Text(roleLabel, style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 8),
      child: Text(title, style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, String route, {Color color = Colors.white}) {
    final bool isSelected = GoRouterState.of(context).uri.toString() == route;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: isSelected ? AppColors.accent : color.withOpacity(0.5), size: 20),
      title: Text(label, style: TextStyle(color: isSelected ? Colors.white : color.withOpacity(0.7), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
      selected: isSelected,
      onTap: () => context.go(route),
    );
  }
}
