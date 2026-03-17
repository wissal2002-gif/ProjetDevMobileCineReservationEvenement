import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../../../profil/pages/profil_page.dart'; 
import 'home_page.dart';
import '../../../programmation/presentation/pages/films_list_page.dart';
import '../../../evenements/presentation/pages/evenements_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _selectedIndex = 0;

  // Couleurs en dur pour éviter les problèmes avec le fichier thème
  final Color kBackground = const Color(0xFF0D0A08);
  final Color kAccent = const Color(0xFF8B7355);

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAdminAsync = ref.watch(isUserAdminProvider);
    final adminProfile = ref.watch(adminProfileProvider).value;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: kBackground,
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
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
                          child: Icon(Icons.confirmation_number, color: kAccent, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "CinéVent",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildNavItem("Accueil", 0),
                  _buildNavItem("Films", 1),
                  _buildNavItem("Événements", 2),
                  _buildNavItem("Mes Réservations", 3),
                  _buildNavItem("Profil", 4),

                  const SizedBox(width: 24),

                  if (isAdminAsync.value ?? false)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: TextButton.icon(
                        onPressed: () {
                          final email = (adminProfile?.email ?? "").toLowerCase().trim();
                          if (email == 'elbouzidiimane794@gmail.com') {
                            context.push('/admin/tanger');
                          } else {
                            context.push('/admin');
                          }
                        },
                        icon: Icon(Icons.admin_panel_settings, color: kAccent, size: 20),
                        label: Text(
                          "ADMIN",
                          style: TextStyle(color: kAccent, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: kAccent.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),

                  const Icon(Icons.search, color: Colors.white70, size: 22),
                  const SizedBox(width: 24),

                  if (!authState.isAuthenticated) ...[
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text("Connexion", style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size.zero,
                      ),
                      child: const Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      tooltip: "Déconnexion",
                      onPressed: () => ref.read(authProvider.notifier).logout(),
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
          HomePage(onNavigate: (index) => setState(() => _selectedIndex = index)),
          const FilmsListPage(),
          const EvenementsPage(),
          const Center(child: Text("Mes Réservations", style: TextStyle(color: Colors.white))),
          const ProfilPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/support'),
        label: const Text("Aide", style: TextStyle(fontWeight: FontWeight.bold)),
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
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
