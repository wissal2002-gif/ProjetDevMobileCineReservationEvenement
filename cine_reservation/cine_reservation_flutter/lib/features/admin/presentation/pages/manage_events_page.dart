import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'add_event_form_page.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';

class ManageEventsPage extends ConsumerWidget {
  const ManageEventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(allEvenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION ÉVÉNEMENTS"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEventFormPage()),
        ).then((_) => ref.refresh(allEvenementsProvider)),
        label: const Text("Ajouter", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_box_rounded, color: Colors.black),
      ),
      body: eventsAsync.when(
        data: (events) => events.isEmpty
            ? const Center(child: Text("Aucun événement créé", style: TextStyle(color: Colors.white54)))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) => _buildEventCard(context, ref, events[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, WidgetRef ref, Evenement event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  event.affiche ?? 'https://via.placeholder.com/400x150',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => Container(height: 140, color: Colors.grey[900], child: const Icon(Icons.event, size: 50)),
                ),
              ),
              Positioned(
                top: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                  child: Text(event.type?.toUpperCase() ?? 'EVENT',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(event.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("${event.ville} • ${DateFormat('dd MMM yyyy').format(event.dateDebut)}",
                style: TextStyle(color: Colors.white.withOpacity(0.6))),
            trailing: Text("${event.prix} DH", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoBadge(Icons.people, "${event.placesDisponibles}/${event.placesTotales}"),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Colors.blueAccent),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddEventFormPage(event: event))
                      ).then((_) => ref.refresh(allEvenementsProvider)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                      onPressed: () => _deleteDialog(context, ref, event),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white38),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  void _deleteDialog(BuildContext context, WidgetRef ref, Evenement event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer l'événement ?", style: TextStyle(color: Colors.white)),
        content: Text("Voulez-vous supprimer '${event.titre}' ? Cette action est irréversible.", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await client.admin.supprimerEvenement(event.id!);
                ref.invalidate(allEvenementsProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Événement supprimé"), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }
}
