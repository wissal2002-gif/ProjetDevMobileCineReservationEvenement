import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../../../admin/presentation/pages/add_event_form_page.dart';
import '../widgets/events_sidebar.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';

class ManageEventsEventsPage extends ConsumerWidget {
  const ManageEventsEventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(allEvenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const EventsSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, ref),
                Expanded(
                  child: eventsAsync.when(
                    data: (events) {
                      if (events.isEmpty) {
                        return const Center(
                            child: Text("Aucun événement trouvé.",
                                style: TextStyle(color: Colors.white24, fontSize: 16))
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        itemCount: events.length,
                        itemBuilder: (context, index) => _buildEventCard(context, ref, events[index]),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                    error: (e, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Erreur serveur : $e",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("GESTION DES ÉVÉNEMENTS",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              minimumSize: const Size(150, 45),
            ),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEventFormPage()));
              if (context.mounted) ref.invalidate(allEvenementsProvider);
            },
            icon: const Icon(Icons.add),
            label: const Text("NOUVEL ÉVÉNEMENT"),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, WidgetRef ref, Evenement event) {
    return Card(
      color: AppColors.cardBg,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 80,
            color: Colors.black26,
            child: (event.affiche != null && event.affiche!.isNotEmpty)
                ? Image.network(
              event.affiche!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white24),
            )
                : const Icon(Icons.event, color: AppColors.accent),
          ),
        ),
        title: Text(event.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("${event.ville ?? 'Ville non définie'} • ${event.prix ?? 0} DH",
                style: const TextStyle(color: AppColors.accent, fontSize: 13)),
            Text(DateFormat('dd MMMM yyyy').format(event.dateDebut),
                style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventFormPage(event: event)));
                if (context.mounted) ref.invalidate(allEvenementsProvider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              onPressed: () => _deleteDialog(context, ref, event),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteDialog(BuildContext context, WidgetRef ref, Evenement event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Confirmer la suppression"),
        content: Text("Voulez-vous supprimer l'événement '${event.titre}' ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ANNULER")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await client.admin.supprimerEvenement(event.id!);
              if (context.mounted) {
                ref.invalidate(allEvenementsProvider);
                Navigator.pop(ctx);
              }
            },
            child: const Text("SUPPRIMER"),
          ),
        ],
      ),
    );
  }
}