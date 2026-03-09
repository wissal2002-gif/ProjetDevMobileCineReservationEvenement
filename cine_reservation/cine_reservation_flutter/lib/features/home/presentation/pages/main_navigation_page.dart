import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
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
                            color: AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.confirmation_number, color: AppColors.accent, size: 24),
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
                  // Nav Items
                  _buildNavItem("Accueil", 0),
                  _buildNavItem("Films", 1),
                  _buildNavItem("Événements", 2),
                  _buildNavItem("Mes Réservations", 3),
                  _buildNavItem("Profil", 4),
                  const SizedBox(width: 24),
                  // Search & Auth
                  const Icon(Icons.search, color: Colors.white70, size: 22),
                  const SizedBox(width: 24),
                  if (!authState.isAuthenticated) ...[
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: const Text("Connexion", style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => context.push('/register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
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
          const Center(child: Text("Profil", style: TextStyle(color: Colors.white))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action Aide
        },
        label: const Text("Aide", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.help_outline),
        backgroundColor: AppColors.accent,
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
              color: isSelected ? AppColors.accent : Colors.transparent,
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
