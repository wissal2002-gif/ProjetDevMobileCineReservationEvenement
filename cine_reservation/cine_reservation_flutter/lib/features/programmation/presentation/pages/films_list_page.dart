import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Importé pour la recherche par date
import '../providers/programmation_provider.dart';
import '../../../../core/theme/app_theme.dart';

class FilmsListPage extends ConsumerStatefulWidget {
  const FilmsListPage({super.key});

  @override
  ConsumerState<FilmsListPage> createState() => _FilmsListPageState();
}

class _FilmsListPageState extends ConsumerState<FilmsListPage> {
  String _searchQuery = "";
  String _selectedGenre = "Tous les genres";
  String _sortBy = "Titre";

  final List<String> _genres = [
    "Tous les genres",
    "Action",
    "Aventure",
    "Drame",
    "Science-Fiction",
    "Thriller",
    "Romance",
    "Comédie",
    "Horreur"
  ];

  final List<String> _sortOptions = ["Titre", "Note", "Durée"];

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(filmsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Films à l'affiche",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text("Découvrez tous les films actuellement au cinéma",
                style: TextStyle(color: Colors.white54, fontSize: 14)),
          ),
          const SizedBox(height: 20),

          // ─── BARRE DE FILTRES FILMS (Taille optimisée) ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 1. Recherche textuelle (Prend 50% de l'espace)
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
                        hintText: "Titre, note, date (jj/mm)...",
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                        icon: Icon(Icons.search, color: Colors.white38, size: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // 2. Filtre Genre (Plus étroit)
                Expanded(
                  flex: 3,
                  child: _buildDropdown(_selectedGenre, _genres, (val) {
                    setState(() => _selectedGenre = val!);
                  }),
                ),
                const SizedBox(width: 10),

                // 3. Tri (Le plus étroit)
                Expanded(
                  flex: 2,
                  child: _buildDropdown(_sortBy, _sortOptions, (val) {
                    setState(() => _sortBy = val!);
                  }, icon: Icons.sort),
                ),
              ],
            ),
          ),

          // ─── GRILLE DE RÉSULTATS ───
          Expanded(
            child: filmsAsync.when(
              data: (films) {
                // Logique de Filtrage Avancée
                var filtered = films.where((f) {
                  final query = _searchQuery.toLowerCase();

                  // Préparation des données pour la recherche
                  final dateStr = f.dateDebut != null ? DateFormat('dd/MM/yyyy').format(f.dateDebut!) : "";
                  final noteStr = f.noteMoyenne?.toString() ?? "";

                  final matchesText = f.titre.toLowerCase().contains(query) ||
                      (f.realisateur?.toLowerCase().contains(query) ?? false) ||
                      dateStr.contains(query) ||
                      noteStr.contains(query);

                  final matchesGenre = _selectedGenre == "Tous les genres" ||
                      (f.genre?.toLowerCase().contains(_selectedGenre.toLowerCase()) ?? false);

                  return matchesText && matchesGenre;
                }).toList();

                // Logique de Tri
                if (_sortBy == "Note") {
                  filtered.sort((a, b) => (b.noteMoyenne ?? 0).compareTo(a.noteMoyenne ?? 0));
                } else if (_sortBy == "Durée") {
                  filtered.sort((a, b) => (b.duree ?? 0).compareTo(a.duree ?? 0));
                } else {
                  filtered.sort((a, b) => a.titre.compareTo(b.titre));
                }

                if (filtered.isEmpty) {
                  return const Center(child: Text("Aucun film trouvé", style: TextStyle(color: Colors.white38)));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: Text("${filtered.length} films trouvés",
                          style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _buildFilmTile(context, filtered[index]),
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

  Widget _buildFilmTile(BuildContext context, dynamic film) {
    return GestureDetector(
      onTap: () => context.push('/film-detail', extra: film.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: film.affiche ?? "",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (film.classification != null)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white24, width: 0.5)
                        ),
                        child: Text(film.classification!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            film.titre,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${film.genre?.split(',').first ?? 'N/A'} • ⭐ ${film.noteMoyenne}",
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}