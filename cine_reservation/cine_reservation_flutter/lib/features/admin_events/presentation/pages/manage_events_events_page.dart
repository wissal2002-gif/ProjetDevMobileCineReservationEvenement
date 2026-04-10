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
    final isMobile = MediaQuery.of(context).size.width < 768;
    final eventsAsync = ref.watch(allEvenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (!isMobile) SizedBox(width: 280, child: const EventsSidebar()),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, ref, isMobile),
                Expanded(
                  child: eventsAsync.when(
                    data: (events) {
                      if (events.isEmpty) {
                        return const Center(
                            child: Text("Aucun événement trouvé.",
                                style: TextStyle(color: Colors.white24, fontSize: 16)));
                      }
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 32, vertical: 8),
                        itemCount: events.length,
                        itemBuilder: (context, index) =>
                            _buildEventCard(context, ref, events[index], isMobile),
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.accent)),
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

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("GESTION DES ÉVÉNEMENTS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _addButton(context, ref, isMobile),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer(
            builder: (context, ref, _) {
              final admin = ref.watch(adminProfileProvider).value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GESTION DES ÉVÉNEMENTS",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  if (admin?.nomCinema != null)
                    Text(
                      "${admin!.nomCinema} — Événements de votre ville",
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 13),
                    ),
                ],
              );
            },
          ),
          Row(children: [
            // ✅ Bouton suppression événements passés
            IconButton(
              icon: const Icon(Icons.cleaning_services, color: Colors.red),
              tooltip: "Supprimer les événements passés",
              onPressed: () => _deletePassedEvents(context, ref),
            ),
            const SizedBox(width: 8),
            _addButton(context, ref, isMobile),
          ]),
        ],
      ),
    );
  }

  Widget _addButton(BuildContext context, WidgetRef ref, bool isMobile) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.black,
        minimumSize: Size(isMobile ? double.infinity : 150, 45),
      ),
      onPressed: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddEventFormPage()));
        if (context.mounted) ref.invalidate(allEvenementsProvider);
      },
      icon: const Icon(Icons.add),
      label: Text(isMobile ? "AJOUTER ÉVÉNEMENT" : "NOUVEL ÉVÉNEMENT"),
    );
  }

  Widget _buildEventCard(
      BuildContext context, WidgetRef ref, Evenement event, bool isMobile) {
    final isPast = event.dateDebut.isBefore(DateTime.now());

    return Card(
      color: isPast ? AppColors.cardBg.withOpacity(0.4) : AppColors.cardBg,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: isPast ? Colors.red.withOpacity(0.3) : Colors.white10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: isMobile ? 50 : 60,
            height: 80,
            color: Colors.black26,
            child: (event.affiche != null && event.affiche!.isNotEmpty)
                ? Image.network(
              event.affiche!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, color: Colors.white24),
            )
                : const Icon(Icons.event, color: AppColors.accent),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                event.titre,
                style: TextStyle(
                    color: isPast ? Colors.white38 : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isPast)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: const Text("PASSÉ",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
                "${event.ville ?? 'Ville non définie'} • ${event.prix ?? 0} DH",
                style: TextStyle(
                    color: isPast ? Colors.white24 : AppColors.accent,
                    fontSize: 12)),
            Text(DateFormat('dd MMM yyyy').format(event.dateDebut),
                style: TextStyle(
                    color: isPast
                        ? Colors.red.withOpacity(0.5)
                        : Colors.white38,
                    fontSize: 11)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              icon: const Icon(Icons.edit_outlined,
                  color: Colors.blueAccent, size: 20),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddEventFormPage(event: event)));
                if (context.mounted) ref.invalidate(allEvenementsProvider);
              },
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              icon: const Icon(Icons.delete_outline,
                  color: Colors.redAccent, size: 20),
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
        title: const Text("Confirmer la suppression",
            style: TextStyle(color: Colors.white)),
        content: Text("Voulez-vous supprimer '${event.titre}' ?",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("ANNULER")),
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

  // ✅ Suppression des événements passés
  void _deletePassedEvents(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer les événements passés ?",
            style: TextStyle(color: Colors.white)),
        content: const Text(
            "Tous les événements dont la date est dépassée seront supprimés.",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("ANNULER")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final events = ref.read(allEvenementsProvider).value ?? [];
              final now = DateTime.now();
              final passes =
              events.where((e) => e.dateDebut.isBefore(now)).toList();
              for (final e in passes) {
                await client.admin.supprimerEvenement(e.id!);
              }
              ref.invalidate(allEvenementsProvider);
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                      Text("${passes.length} événement(s) supprimé(s)"),
                      backgroundColor: Colors.green),
                );
              }
            },
            child: const Text("SUPPRIMER"),
          ),
        ],
      ),
    );
  }
}