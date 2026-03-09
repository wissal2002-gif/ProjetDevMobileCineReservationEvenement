import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/programmation_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FilmsListPage extends ConsumerStatefulWidget {
  const FilmsListPage({super.key});

  @override
  ConsumerState<FilmsListPage> createState() => _FilmsListPageState();
}

class _FilmsListPageState extends ConsumerState<FilmsListPage> {
  String _searchQuery = "";
  String _selectedGenre = "Tous";
  final List<String> _genres = ["Tous", "Action", "Animation", "Drame", "Sci-Fi", "Thriller", "Comédie"];

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(filmsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("PARCOURIR LES FILMS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              _buildSearchBar(),
              _buildGenreFilters(),
            ],
          ),
        ),
      ),
      body: filmsAsync.when(
        data: (films) {
          final filtered = films.where((f) {
            final matchesSearch = f.titre.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesGenre = _selectedGenre == "Tous" || (f.genre?.contains(_selectedGenre) ?? false);
            return matchesSearch && matchesGenre;
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) => _buildFilmCard(context, filtered[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, s) => const Center(child: Text("Erreur de chargement")),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 45,
        decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10)),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Titre, acteur, réalisateur...",
            prefixIcon: Icon(Icons.search, color: AppColors.accent, size: 20),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGenreFilters() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        itemCount: _genres.length,
        itemBuilder: (context, index) {
          final genre = _genres[index];
          final isSelected = _selectedGenre == genre;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (v) => setState(() => _selectedGenre = genre),
              backgroundColor: AppColors.cardBg,
              selectedColor: AppColors.accent,
              labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilmCard(BuildContext context, dynamic film) {
    return GestureDetector(
      onTap: () => context.push('/film-detail', extra: film.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(imageUrl: film.affiche ?? "", fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(film.titre, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          Text("${film.genre} • ${film.noteMoyenne} ⭐", style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}