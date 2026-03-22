import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/programmation/presentation/providers/programmation_provider.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String _query = "";

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(filmsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Rechercher un film, un genre...",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: AppColors.accent),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
      ),
      body: filmsAsync.when(
        data: (films) {
          final filteredFilms = films.where((f) =>
          f.titre.toLowerCase().contains(_query.toLowerCase()) ||
              (f.genre?.toLowerCase().contains(_query.toLowerCase()) ?? false)
          ).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: filteredFilms.length,
            itemBuilder: (context, index) {
              final film = filteredFilms[index];
              return GestureDetector(
                onTap: () => context.push('/film-detail', extra: film.id),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(film.affiche ?? "", fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(film.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(film.genre ?? "", style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(child: Text("Erreur")),
      ),
    );
  }
}
