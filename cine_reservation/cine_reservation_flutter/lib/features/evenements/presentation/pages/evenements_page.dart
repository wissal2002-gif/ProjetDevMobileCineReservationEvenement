import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/evenement_provider.dart';
import '../../../../core/theme/app_theme.dart';

class EvenementsPage extends ConsumerStatefulWidget {
  const EvenementsPage({super.key});

  @override
  ConsumerState<EvenementsPage> createState() => _EvenementsPageState();
}

class _EvenementsPageState extends ConsumerState<EvenementsPage> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(evenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tous les Événements",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ─── BARRE DE RECHERCHE BLANCHE ───
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: "Rechercher un événement ou lieu...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // ─── GRILLE D'ÉVÉNEMENTS (CARREAUX) ───
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                final filtered = events.where((e) {
                  return e.titre.toLowerCase().contains(_searchQuery) ||
                      (e.ville?.toLowerCase().contains(_searchQuery) ?? false);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("Aucun résultat", style: TextStyle(color: Colors.white54)));
                }

                // Utilisation de GridView pour faire des carreaux
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,          // 2 carreaux par ligne
                    crossAxisSpacing: 15,       // Espace entre colonnes
                    mainAxisSpacing: 15,        // Espace entre lignes
                    childAspectRatio: 0.8,      // Ratio pour faire des rectangles verticaux/carreaux
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final event = filtered[index];
                    return _buildEventTile(context, event);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, s) => Center(child: Text("Erreur: $e")),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour un carreau d'événement
  Widget _buildEventTile(BuildContext context, dynamic event) {
    return GestureDetector(
      onTap: () => context.push('/event-detail', extra: event.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Image de fond
              CachedNetworkImage(
                imageUrl: event.affiche ?? "",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              // Dégradé pour la lisibilité
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                  ),
                ),
              ),
              // Infos texte en bas
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.titre,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${event.ville} • ${event.prix}€",
                      style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}