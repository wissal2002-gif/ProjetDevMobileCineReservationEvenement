import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/programmation/presentation/providers/programmation_provider.dart';
import '../../../../features/evenements/presentation/providers/evenement_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  final Function(int)? onNavigate;
  const HomePage({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmsAsync = ref.watch(filmsProvider);
    final eventsAsync = ref.watch(evenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      // UNIQUE BOUTON D'AIDE
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8B7355),
        onPressed: () => context.go('/support'),
        icon: const Icon(Icons.help_outline, color: Colors.white),
        label: const Text(
          "Aide",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 100, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFF2C1810).withOpacity(0.8), AppColors.background],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Réservez vos billets de cinéma en\nligne",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900, height: 1.1),
                  ),
                  const SizedBox(height: 50),
                  _buildMaquetteSearchBar(context),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader("Films à l'affiche", () => onNavigate?.call(1)),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 320,
              child: filmsAsync.when(
                data: (films) => ListView.builder(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: films.length,
                  itemBuilder: (context, index) => _buildFilmCard(context, films[index]),
                ),
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (e, s) => const Center(child: Text("Erreur")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaquetteSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: const Row(children: [Icon(Icons.search, color: Colors.grey), Expanded(child: TextField(decoration: InputDecoration(hintText: "Rechercher...", border: InputBorder.none)))]),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), TextButton(onPressed: onSeeAll, child: const Text("Voir tout"))]),
    );
  }

  Widget _buildFilmCard(BuildContext context, dynamic film) {
    return GestureDetector(
        onTap: () => context.push('/film-detail', extra: film.id),
        child: Container(width: 180, margin: const EdgeInsets.only(right: 20), child: Column(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(15), child: CachedNetworkImage(imageUrl: film.affiche ?? "", fit: BoxFit.cover)))]))
    );
  }
}