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
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _selectedIndex = 0;

  final Color kBackground = const Color(0xFF0D0A08);
  final Color kAccent = const Color(0xFF8B7355);

  final List<String> _navLabels = [
    "Accueil",
    "Films",
    "Événements",
    "Mes Réservations",
    "Cinémas",
    "Profil",
  ];

  final List<IconData> _navIcons = [
    Icons.home_outlined,
    Icons.movie_outlined,
    Icons.event_outlined,
    Icons.bookmark_outline,
    Icons.location_on_outlined,
    Icons.person_outline,
  ];

  void _openMobileMenu(BuildContext context, bool isAdmin, bool isAuthenticated, String adminEmail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1612),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Nav items
                ...List.generate(_navLabels.length, (index) {
                  final isSelected = _selectedIndex == index;
                  return ListTile(
                    leading: Icon(
                      _navIcons[index],
                      color: isSelected ? kAccent : Colors.white60,
                    ),
                    title: Text(
                      _navLabels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.circle, size: 8, color: kAccent)
                        : null,
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      Navigator.pop(context);
                    },
                  );
                }),
                const Divider(color: Colors.white12),
                // Admin button
                if (isAdmin)
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings, color: kAccent),
                    title: Text("Admin",
                        style: TextStyle(
                            color: kAccent, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      if (adminEmail == 'elbouzidiimane794@gmail.com') {
                        context.push('/admin/tanger');
                      } else {
                        context.push('/admin');
                      }
                    },
                  ),
                // Auth buttons
                if (!isAuthenticated) ...[
                  ListTile(
                    leading: const Icon(Icons.login, color: Colors.white70),
                    title: const Text("Connexion",
                        style: TextStyle(color: Colors.white70)),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/login');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person_add, color: kAccent),
                    title: Text("Inscription",
                        style: TextStyle(
                            color: kAccent, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/register');
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text("Déconnexion",
                        style: TextStyle(color: Colors.redAccent)),
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(authProvider.notifier).logout();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAdminAsync = ref.watch(isUserAdminProvider);
    final adminProfile = ref.watch(adminProfileProvider).value;
    final isAdmin = isAdminAsync.value ?? false;
    final adminEmail = (adminProfile?.email ?? "").toLowerCase().trim();

    // Détection mobile vs desktop
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: kBackground,
            border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: Row(
                      children: [
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
                        const Text(
                          "CinéVent",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // ── DESKTOP : afficher tous les boutons ──
                  if (!isMobile) ...[
                    _buildNavItem("Accueil", 0),
                    _buildNavItem("Films", 1),
                    _buildNavItem("Événements", 2),
                    _buildNavItem("Mes Réservations", 3),
                    _buildNavItem("Cinémas", 4),
                    _buildNavItem("Profil", 5),
                    const SizedBox(width: 24),
                    if (isAdmin)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: TextButton.icon(
                          onPressed: () {
                            if (adminEmail == 'elbouzidiimane794@gmail.com') {
                              context.push('/admin/tanger');
                            } else {
                              context.push('/admin');
                            }
                          },
                          icon: Icon(Icons.admin_panel_settings,
                              color: kAccent, size: 20),
                          label: Text("ADMIN",
                              style: TextStyle(
                                  color: kAccent,
                                  fontWeight: FontWeight.bold)),
                          style: TextButton.styleFrom(
                            backgroundColor: kAccent.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    const Icon(Icons.search, color: Colors.white70, size: 22),
                    const SizedBox(width: 24),
                    if (!authState.isAuthenticated) ...[
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text("Connexion",
                            style: TextStyle(color: Colors.white70)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => context.go('/register'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size.zero,
                        ),
                        child: const Text("Inscription",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ] else ...[
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: Colors.redAccent),
                        tooltip: "Déconnexion",
                        onPressed: () =>
                            ref.read(authProvider.notifier).logout(),
                      ),
                    ],
                  ],

                  // ── MOBILE : icône recherche + hamburger ──
                  if (isMobile) ...[
                    const Icon(Icons.search, color: Colors.white70, size: 22),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => _openMobileMenu(
                          context, isAdmin, authState.isAuthenticated, adminEmail),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/support'),
        label: const Text("Aide",
            style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.help_outline),
        backgroundColor: kAccent,
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}