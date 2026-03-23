import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../../../profil/presentation/pages/profil_page.dart';
import 'home_page.dart';
import '../../../programmation/presentation/pages/cinemas_page.dart';
import '../../../programmation/presentation/pages/films_list_page.dart';
import '../../../evenements/presentation/pages/evenements_page.dart';
import '../../../reservation/presentation/pages/mes_reservations_page.dart';
import '../../../billets/presentation/pages/billets_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _selectedIndex = 0;

  final Color kBackground = const Color(0xFF0D0A08);
  final Color kAccent = const Color(0xFF8B7355);

  final List<_NavItem> _navItems = [
    _NavItem('Accueil', Icons.home_outlined, Icons.home),
    _NavItem('Films', Icons.movie_outlined, Icons.movie),
    _NavItem('Événements', Icons.event_outlined, Icons.event),
    _NavItem('Réservations', Icons.confirmation_number_outlined,
        Icons.confirmation_number),
    _NavItem('Cinémas', Icons.movie_filter_outlined, Icons.movie_filter),
    _NavItem('Profil', Icons.person_outline, Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAdminAsync = ref.watch(isUserAdminProvider);
    final adminProfile = ref.watch(adminProfileProvider).value;
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: kBackground,

      // ── AppBar desktop ────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: kBackground,
            border: Border(
                bottom:
                BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.confirmation_number,
                            color: kAccent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text("CinéVent",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5)),
                    ]),
                  ),

                  // Nav items desktop uniquement
                  if (isDesktop) ...[
                    const Spacer(),
                    ..._navItems.asMap().entries.map((e) =>
                        _buildNavItemDesktop(e.key, e.value.label)),
                    const SizedBox(width: 16),
                  ] else
                    const Spacer(),

                  // Admin button
                  if (isAdminAsync.value ?? false)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton.icon(
                        onPressed: () {
                          final email = (adminProfile?.email ?? "")
                              .toLowerCase()
                              .trim();
                          if (email ==
                              'elbouzidiimane794@gmail.com') {
                            context.push('/admin/tanger');
                          } else {
                            context.push('/admin');
                          }
                        },
                        icon: Icon(Icons.admin_panel_settings,
                            color: kAccent, size: 18),
                        label: Text("ADMIN",
                            style: TextStyle(
                                color: kAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        style: TextButton.styleFrom(
                          backgroundColor: kAccent.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),

                  // Auth buttons
                  if (!authState.isAuthenticated) ...[
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text("Connexion",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => context.go('/register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size.zero,
                      ),
                      child: const Text("Inscription",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.logout,
                          color: Colors.redAccent, size: 20),
                      tooltip: "Déconnexion",
                      onPressed: () =>
                          ref.read(authProvider.notifier).logout(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),

      // ── Body ──────────────────────────────────────────────────────────
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
              onNavigate: (index) =>
                  setState(() => _selectedIndex = index)),
          const FilmsListPage(),
          const EvenementsPage(),
          MesReservationsPage(),
          const CinemasPage(),
          const ProfilPage(),
        ],
      ),

      // ── Bottom Navigation Bar (mobile uniquement) ─────────────────────
      bottomNavigationBar: isDesktop
          ? null
          : Container(
        decoration: BoxDecoration(
          color: kBackground,
          border: Border(
              top: BorderSide(
                  color: Colors.white.withOpacity(0.08))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.asMap().entries.map((e) =>
                  _buildNavItemMobile(e.key, e.value)).toList(),
            ),
          ),
        ),
      ),

      // FAB support
      floatingActionButton: isDesktop
          ? FloatingActionButton.extended(
        heroTag: 'main_support_fab',
        onPressed: () => context.go('/support'),
        label: const Text("Aide",
            style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.help_outline),
        backgroundColor: kAccent,
      )
          : null,
    );
  }

  // ── Nav item desktop ───────────────────────────────────────────────
  Widget _buildNavItemDesktop(int index, String title) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? kAccent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight:
            isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ── Nav item mobile ────────────────────────────────────────────────
  Widget _buildNavItemMobile(int index, _NavItem item) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? item.iconSelected : item.icon,
                color: isSelected ? kAccent : Colors.white38,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                style: TextStyle(
                  color: isSelected ? kAccent : Colors.white38,
                  fontSize: 9,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData iconSelected;
  const _NavItem(this.label, this.icon, this.iconSelected);
}
