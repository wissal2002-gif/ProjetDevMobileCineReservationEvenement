import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Importé pour la gestion des dates
import '../providers/evenement_provider.dart';
import '../../../../core/theme/app_theme.dart';

class EvenementsPage extends ConsumerStatefulWidget {
  const EvenementsPage({super.key});

  @override
  ConsumerState<EvenementsPage> createState() => _EvenementsPageState();
}

class _EvenementsPageState extends ConsumerState<EvenementsPage> {
  String _searchQuery = "";
  String _selectedType = "Tous les types";
  String _sortBy = "Date";

  final List<String> _types = ["Tous les types", "Concert", "Théâtre", "Sport", "Humour"];
  final List<String> _sortOptions = ["Date", "Note", "Prix"];

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(evenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Événements à venir",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text("Découvrez tous les événements disponibles",
                style: TextStyle(color: Colors.white54, fontSize: 14)),
          ),
          const SizedBox(height: 20),

          // ─── BARRE DE FILTRES AVANCÉE (Taille optimisée) ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 1. Recherche textuelle (Titre, Ville, Prix, Note, Date)
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Nom, ville, prix, note ou date...",
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                        icon: Icon(Icons.search, color: Colors.white38, size: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // 2. Filtre Type
                Expanded(
                  flex: 3,
                  child: _buildDropdown(_selectedType, _types, (val) {
                    setState(() => _selectedType = val!);
                  }),
                ),
                const SizedBox(width: 10),

                // 3. Tri
                Expanded(
                  flex: 2,
                  child: _buildDropdown(_sortBy, _sortOptions, (val) {
                    setState(() => _sortBy = val!);
                  }, icon: Icons.sort),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ─── GRILLE DE RÉSULTATS ───
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                // LOGIQUE DE FILTRAGE AVANCÉE
                var filtered = events.where((e) {
                  final query = _searchQuery.toLowerCase();

                  // Préparation des chaînes pour la recherche
                  final dateStr = DateFormat('dd/MM/yyyy').format(e.dateDebut);
                  final priceStr = e.prix?.toString() ?? "";
                  final noteStr = e.noteMoyenne?.toString() ?? "";

                  // Recherche textuelle sur plusieurs champs
                  final matchesText = e.titre.toLowerCase().contains(query) ||
                      (e.ville?.toLowerCase().contains(query) ?? false) ||
                      dateStr.contains(query) ||
                      priceStr.contains(query) ||
                      noteStr.contains(query);

                  // Filtre par type d'événement
                  final matchesType = _selectedType == "Tous les types" ||
                      e.type?.toLowerCase() == _selectedType.toLowerCase();

                  return matchesText && matchesType;
                }).toList();

                // LOGIQUE DE TRI
                if (_sortBy == "Prix") {
                  filtered.sort((a, b) => (a.prix ?? 0).compareTo(b.prix ?? 0));
                } else if (_sortBy == "Note") {
                  filtered.sort((a, b) => (b.noteMoyenne ?? 0).compareTo(a.noteMoyenne ?? 0));
                } else {
                  filtered.sort((a, b) => a.dateDebut.compareTo(b.dateDebut));
                }

                if (filtered.isEmpty) {
                  return const Center(child: Text("Aucun événement trouvé", style: TextStyle(color: Colors.white38)));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: Text("${filtered.length} événements trouvés",
                          style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _buildEventTile(context, filtered[index]),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, s) => Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, Function(String?) onChanged, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A1A1A),
          icon: Icon(icon ?? Icons.keyboard_arrow_down, color: Colors.white38, size: 18),
          style: const TextStyle(color: Colors.white, fontSize: 11),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, dynamic event) {
    return GestureDetector(
      onTap: () => context.push('/event-detail', extra: event.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: event.affiche ?? "",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              top: 8, left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFF8B7355).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Text(event.type?.toUpperCase() ?? "EVENT",
                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.titre,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text("${event.ville} • ${event.prix}€",
                      style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}