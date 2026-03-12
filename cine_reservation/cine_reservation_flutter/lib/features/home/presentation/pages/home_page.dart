import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/programmation/presentation/providers/programmation_provider.dart';
import '../../../../features/evenements/presentation/providers/evenement_provider.dart';
import '../../../../features/admin/presentation/providers/admin_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  final Function(int)? onNavigate;
  const HomePage({super.key, this.onNavigate});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(filmsProvider);
    final eventsAsync = ref.watch(evenementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8B7355),
        onPressed: () => context.push('/support'),
        icon: const Icon(Icons.help_outline, color: Colors.white),
        label: const Text("Aide", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── HERO SECTION ───
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 60, left: 20, right: 20),
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
                    "Réservez vos billets de Cinéma et d’Événements en ligne",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, height: 1.1),
                  ),
                  const SizedBox(height: 40),
                  _buildMaquetteSearchBar(context),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () => context.push('/faq'),
                    icon: const Icon(Icons.help_center_outlined, color: Color(0xFF8B7355)),
                    label: const Text(
                      "Une question ? Consultez notre FAQ",
                      style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── FILMS À L'AFFICHE ───
          SliverToBoxAdapter(
            child: _buildSectionHeader("Films à l'affiche", () => widget.onNavigate?.call(1)),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: filmsAsync.when(
                data: (films) {
                  final filtered = films.where((f) {
                    final query = _searchQuery.toLowerCase();
                    return f.titre.toLowerCase().contains(query) ||
                        (f.genre?.toLowerCase().contains(query) ?? false);
                  }).toList();

                  if (filtered.isEmpty) return _buildNoResult();

                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _buildFilmCard(context, filtered[index]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (e, s) => const Center(child: Text("Erreur")),
              ),
            ),
          ),

          // ─── ÉVÉNEMENTS À L'AFFICHE ───
          SliverToBoxAdapter(child: const SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: _buildSectionHeader("Événements à l'affiche", () => widget.onNavigate?.call(2)),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: eventsAsync.when(
                data: (events) {
                  final filtered = events.where((e) {
                    final query = _searchQuery.toLowerCase();
                    final matchesTitle = e.titre.toLowerCase().contains(query);
                    final matchesLieu = (e.ville?.toLowerCase().contains(query) ?? false) || (e.lieu?.toLowerCase().contains(query) ?? false);
                    return matchesTitle || matchesLieu;
                  }).toList();

                  if (filtered.isEmpty) return _buildNoResult();

                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _buildHomeEventCard(context, filtered[index]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (e, s) => const Center(child: Text("Erreur de chargement")),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildMaquetteSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white)
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 15),
          Expanded(
              child: TextField(
                  onChanged: (value) {
                    setState(() { _searchQuery = value; }); 
                  },
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                      hintText: "Rechercher par nom ou lieu...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget _buildNoResult() {
    return const Center(child: Text("Aucun résultat", style: TextStyle(color: Colors.white54)));
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            TextButton(onPressed: onSeeAll, child: const Text("Voir tout", style: TextStyle(color: Colors.white54)))
          ]
      ),
    );
  }

  Widget _buildFilmCard(BuildContext context, dynamic film) {
    return GestureDetector(
        onTap: () => context.push('/film-detail', extra: film.id),
        child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(15), child: CachedNetworkImage(imageUrl: film.affiche ?? "", fit: BoxFit.cover))),
                  const SizedBox(height: 8),
                  Text(film.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]
            )
        )
    );
  }

  Widget _buildHomeEventCard(BuildContext context, dynamic event) {
    // Construction de l'info lieu (Ville + Salle/Lieu tiers)
    String displayLieu = event.ville ?? "";
    if (event.lieu != null && event.lieu!.isNotEmpty) {
      displayLieu += " • ${event.lieu}";
    }

    return GestureDetector(
      onTap: () => context.push('/event-detail', extra: event.id),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              CachedNetworkImage(imageUrl: event.affiche ?? "", width: double.infinity, height: double.infinity, fit: BoxFit.cover),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]))),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(displayLieu, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text("${event.prix} DH", style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
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
