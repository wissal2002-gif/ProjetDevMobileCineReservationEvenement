import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/events_sidebar.dart';
import '../../../admin/presentation/providers/admin_provider.dart';

class EventsDashboardPage extends ConsumerWidget {
  const EventsDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(allEvenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const EventsSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TABLEAU DE BORD ÉVÉNEMENTS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Stats Row
                  eventsAsync.when(
                    data: (events) {
                      final totalEvents = events.length;
                      final activeEvents = events.where((e) => e.statut == 'actif').length;
                      
                      return Row(
                        children: [
                          _buildStatCard("Total Événements", totalEvents.toString(), Icons.event),
                          const SizedBox(width: 20),
                          _buildStatCard("Événements Actifs", activeEvents.toString(), Icons.check_circle_outline),
                          const SizedBox(width: 20),
                          _buildStatCard("Billets Vendus", "---", Icons.confirmation_number_outlined), // Placeholder
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text("Erreur stats: $e", style: const TextStyle(color: Colors.red)),
                  ),
                  
                  const SizedBox(height: 40),
                  const Text(
                    "DERNIERS ÉVÉNEMENTS",
                    style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  
                  Expanded(
                    child: eventsAsync.when(
                      data: (events) {
                        if (events.isEmpty) return const Center(child: Text("Aucun événement", style: TextStyle(color: Colors.white24)));
                        
                        return ListView.builder(
                          itemCount: events.length > 5 ? 5 : events.length,
                          itemBuilder: (context, index) {
                            final ev = events[index];
                            return Card(
                              color: Colors.white.withOpacity(0.05),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: ev.affiche != null ? NetworkImage(ev.affiche!) : null,
                                  child: ev.affiche == null ? const Icon(Icons.event) : null,
                                ),
                                title: Text(ev.titre, style: const TextStyle(color: Colors.white)),
                                subtitle: Text("${ev.ville} - ${ev.prix} DH", style: const TextStyle(color: Colors.white54)),
                                trailing: const Icon(Icons.chevron_right, color: Colors.white24),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (e, _) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accent, size: 30),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
