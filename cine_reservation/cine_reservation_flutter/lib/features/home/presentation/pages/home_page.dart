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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── HERO SECTION (GOLDEN/BLACK DESIGN) ───
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2C1810).withOpacity(0.8),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Réservez vos billets de cinéma en\nligne",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Films à l'affiche, événements culturels et bien plus encore",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  const SizedBox(height: 50),
                  _buildMaquetteSearchBar(context),
                ],
              ),
            ),
          ),

          // ─── FILMS À L'AFFICHE ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildSectionHeader("Films à l'affiche", () => onNavigate?.call(1)),
            ),
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
                error: (e, s) => const Center(child: Text("Erreur de chargement")),
              ),
            ),
          ),

          // ─── ÉVÉNEMENTS ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: _buildSectionHeader("Événements à venir", () => onNavigate?.call(2)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: eventsAsync.when(
                data: (events) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: events.length > 4 ? 4 : events.length,
                  itemBuilder: (context, index) => _buildEventCard(context, events[index]),
                ),
                loading: () => const SizedBox(),
                error: (e, s) => const SizedBox(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildMaquetteSearchBar(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 15),
            const Expanded(
              child: TextField(
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Rechercher un film ou un événement...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: Size.zero,
              ),
              child: const Text("Rechercher", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onSeeAll,
            child: const Row(
              children: [
                Text("Voir tout", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward, size: 14, color: AppColors.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmCard(BuildContext context, dynamic film) {
    return GestureDetector(
      onTap: () => context.push('/film-detail', extra: film.id),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(imageUrl: film.affiche ?? "", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Text(film.titre, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("${film.genre} • ${film.noteMoyenne} ⭐",
                style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, dynamic event) {
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
                fit: BoxFit.cover),
            Container(color: Colors.black45),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.titre, maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("${event.prix} €",
                      style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}