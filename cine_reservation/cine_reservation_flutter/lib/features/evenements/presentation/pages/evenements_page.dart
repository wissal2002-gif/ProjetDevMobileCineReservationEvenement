import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/evenement_provider.dart';
import 'package:go_router/go_router.dart';

class EvenementsPage extends ConsumerWidget {
  const EvenementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(evenementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Tous les Événements")),
      body: eventsAsync.when(
        data: (events) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              child: InkWell(
                onTap: () => context.push('/event-detail', extra: event.id),
                child: Column(
                  children: [
                    Image.network(event.affiche ?? "", height: 150, width: double.infinity, fit: BoxFit.cover),
                    ListTile(
                      title: Text(event.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${event.ville} • ${event.prix} €"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(child: Text("Erreur")),
      ),
    );
  }
}