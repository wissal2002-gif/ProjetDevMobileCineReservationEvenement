import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../admin/presentation/providers/admin_provider.dart';

class LocalAdminSidebar extends ConsumerWidget {
  const LocalAdminSidebar({super.key});

  // Couleur accent Tanger
  static const Color _accent = Color(0xFF8B7355);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(adminProfileProvider).value;
    final String nomCine = admin?.nomCinema?.toUpperCase() ?? "CINÉMA";
    final String nom     = admin?.nom ?? "Admin";

    return Container(
      width: 280,
      color: const Color(0xFF0D0A08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER PROFIL ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 28),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _accent.withOpacity(0.15),
                  child: Text(
                    nom.isNotEmpty ? nom[0].toUpperCase() : "A",
                    style: const TextStyle(
                        color: _accent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  nom,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "ADMIN $nomCine",
                    style: const TextStyle(
                        color: _accent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                ),
              ],
            ),
          ),

          // ── MENU ──────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _sectionLabel("NAVIGATION"),
                _navItem(context, Icons.grid_view_rounded,
                    "Tableau de Bord",        "/admin/local"),
                _navItem(context, Icons.movie_filter_rounded,
                    "Gérer les Films",        "/admin/local/films"),
                _navItem(context, Icons.schedule_rounded,
                    "Gérer les Séances",      "/admin/local/seances"),
                _navItem(context, Icons.chair_rounded,
                    "Salles & Sièges",        "/admin/local/salles"),
                _navItem(context, Icons.fastfood_rounded,
                    "Snacks & Options",       "/admin/local/options"),

                const SizedBox(height: 8),
                _sectionLabel("GESTION"),
                _navItem(context, Icons.confirmation_number_rounded,
                    "Réservations",           "/admin/local/reservations"),
                _navItem(context, Icons.payments_rounded,
                    "Voir Revenus",           "/admin/local/revenus"),
              ],
            ),
          ),

          // ── FOOTER LOGOUT ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.06))),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              leading: const Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 18),
              title: const Text("Quitter Admin",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              onTap: () => context.go('/home'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── SECTION LABEL ─────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16, bottom: 6),
      child: Text(
        label,
        style: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4),
      ),
    );
  }

  // ── NAV ITEM ──────────────────────────────────────────────────────────────

  Widget _navItem(
      BuildContext context, IconData icon, String label, String route) {
    final bool isSelected =
        GoRouterState.of(context).matchedLocation == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? _accent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: _accent.withOpacity(0.2))
            : Border.all(color: Colors.transparent),
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Icon(icon,
            color: isSelected ? _accent : Colors.white.withOpacity(0.4),
            size: 18),
        title: Text(
          label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.normal),
        ),
        trailing: isSelected
            ? Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(2)),
        )
            : null,
        onTap: () => context.go(route),
      ),
    );
  }
}