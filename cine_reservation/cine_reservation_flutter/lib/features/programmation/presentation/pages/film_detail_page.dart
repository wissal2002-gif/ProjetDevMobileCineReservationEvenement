import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/navigation_state_provider.dart';
import '../providers/programmation_provider.dart';
import '../../../reservation/presentation/pages/seat_selection_page.dart';

class FilmDetailPage extends ConsumerWidget {
  final int filmId;
  const FilmDetailPage({super.key, required this.filmId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmAsync = ref.watch(filmDetailProvider(filmId));
    final seancesAsync = ref.watch(seancesFilmProvider(filmId));
    final optionsAsync = ref.watch(optionsProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);
    final sallesAsync = ref.watch(allSallesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: filmAsync.when(
        data: (film) => film == null
            ? const Center(child: Text('Film non trouve', style: TextStyle(color: Colors.white)))
            : _buildBody(context, ref, film, seancesAsync, optionsAsync, cinemasAsync, sallesAsync),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, s) => Center(child: Text('Erreur: $e', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      WidgetRef ref,
      Film film,
      AsyncValue<List<Seance>> seancesAsync,
      AsyncValue<List<OptionSupplementaire>> optionsAsync,
      AsyncValue<List<Cinema>> cinemasAsync,
      AsyncValue<List<Salle>> sallesAsync,
      ) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 500,
          backgroundColor: AppColors.background,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: film.affiche ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (c, u, e) => Container(
                    color: AppColors.cardBg,
                    child: const Icon(Icons.movie, size: 50, color: Colors.white24),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.background],
                    ),
                  ),
                ),
                if (film.bandeAnnonce != null && film.bandeAnnonce!.isNotEmpty)
                  Center(
                    child: FloatingActionButton.extended(
                      heroTag: 'bande_annonce_${film.id}',
                      onPressed: () async {
                        final uri = Uri.parse(film.bandeAnnonce!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      label: const Text('BANDE ANNONCE'),
                      icon: const Icon(Icons.play_arrow),
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(film.titre,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  if (film.classification != null)
                    _badge(film.classification!,
                        film.classification!.contains('18') ? Colors.red : Colors.orange),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  _info(Icons.movie, film.genre ?? 'N/A'),
                  const SizedBox(width: 20),
                  _info(Icons.timer, '${film.duree ?? 0} min'),
                  const SizedBox(width: 20),
                  _info(Icons.language, film.langue ?? 'VF'),
                ]),
                const SizedBox(height: 30),
                _sectionTitle('SYNOPSIS'),
                const SizedBox(height: 10),
                Text(film.synopsis ?? '', style: const TextStyle(color: Colors.white70, height: 1.5)),
                const SizedBox(height: 30),
                _sectionTitle('REALISATEUR & CASTING'),
                const SizedBox(height: 10),
                Text('Realise par : ${film.realisateur ?? "N/A"}',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                Text('Casting : ${film.casting ?? "N/A"}',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 25),
                _sectionTitle('PLACES DISPONIBLES'),
                seancesAsync.when(
                  data: (list) {
                    final total = list.fold<int>(0, (s, e) => s + e.placesDisponibles);
                    return Text('$total places disponibles',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16));
                  },
                  loading: () => const CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                  error: (_, __) => const Text('N/A', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 40),
                const Text('SEANCES & CINEMAS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 15),
                seancesAsync.when(
                  data: (list) => list.isEmpty
                      ? const Text('Aucune seance disponible',
                      style: TextStyle(color: AppColors.textLight))
                      : Column(
                    children: list
                        .map((s) => _buildSeanceItem(
                      context,
                      ref,
                      s,
                      film.titre,
                      film.duree ?? 120,
                      cinemasAsync,
                      sallesAsync,
                    ))
                        .toList(),
                  ),
                  loading: () => const CircularProgressIndicator(color: AppColors.accent),
                  error: (e, s) => const SizedBox(),
                ),
                const SizedBox(height: 40),
                const Text('OPTIONS SUPPLEMENTAIRES',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 15),
                optionsAsync.when(
                  data: (list) => _buildOptions(list),
                  loading: () => const CircularProgressIndicator(color: AppColors.accent),
                  error: (e, s) => const SizedBox(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeanceItem(
      BuildContext context,
      WidgetRef ref,
      Seance seance,
      String filmTitre,
      int duree,
      AsyncValue<List<Cinema>> cinemasAsync,
      AsyncValue<List<Salle>> sallesAsync,
      ) {
    // salleId lu directement depuis seance — toujours correct
    final int salleId = seance.salleId;
    String cinemaName = 'CINEMA';
    String cinemaLieu = '';

    sallesAsync.whenData((salles) {
      try {
        final salle = salles.firstWhere((s) => s.id == seance.salleId);
        cinemasAsync.whenData((cinemas) {
          try {
            final cinema = cinemas.firstWhere((c) => c.id == salle.cinemaId);
            cinemaName = cinema.nom;
            cinemaLieu = '${cinema.ville}, ${cinema.adresse}';
          } catch (_) {}
        });
      } catch (_) {}
    });

    final start = seance.dateHeure;
    final end = start.add(Duration(minutes: duree));
    final timeFmt = DateFormat('HH:mm');
    final dateFmt = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cinemaName.toUpperCase(),
                        style: const TextStyle(
                            color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                    if (cinemaLieu.isNotEmpty)
                      Text(cinemaLieu,
                          style: const TextStyle(color: Colors.white54, fontSize: 10)),
                    const SizedBox(height: 5),
                    Text(
                      '${dateFmt.format(start)} de ${timeFmt.format(start)} a ${timeFmt.format(end)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Column(children: [
                _badge(seance.typeProjection ?? '2D', Colors.white),
                const SizedBox(height: 5),
                Text('${seance.placesDisponibles} places',
                    style: TextStyle(
                        color: seance.placesDisponibles > 10 ? Colors.green : Colors.orange,
                        fontSize: 11)),
              ]),
            ],
          ),
          const Divider(height: 30, color: Colors.white10),
          _prices(seance),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: seance.placesDisponibles <= 0
                ? null
                : () {
              // Stocker dans navigationProvider AVANT context.push
              // (évite le bug JSON GoRouter sur Flutter Web)
              ref.read(navigationProvider.notifier).setContext(
                seance: seance,
                evenement: null,
                filmTitre: filmTitre,
                salleId: salleId,
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => SeatSelectionPage(
                    seance: seance,
                    evenement: null,
                    salleId: salleId,
                    filmTitre: filmTitre,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
            child: Text(
              seance.placesDisponibles <= 0 ? 'COMPLET' : 'RESERVER',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prices(Seance s) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: [
      _p('Normal', s.prixNormal),
      const SizedBox(width: 15),
      _p('Reduit', s.prixReduit ?? 0),
      const SizedBox(width: 15),
      _p('Enfant', s.prixEnfant ?? 0),
      const SizedBox(width: 15),
      _p('Senior', s.prixSenior ?? 0),
      const SizedBox(width: 15),
      _p('VIP', s.prixVip ?? 0),
    ]),
  );

  Widget _p(String l, double p) => Column(children: [
    Text(l, style: const TextStyle(color: Colors.white38, fontSize: 10)),
    Text('${p.toStringAsFixed(0)} MAD',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  ]);

  Widget _buildOptions(List<OptionSupplementaire> list) {
    if (list.isEmpty) {
      return const Text('Aucune option disponible', style: TextStyle(color: AppColors.textLight));
    }
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final opt = list[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text('${opt.nom}\n${opt.prix} MAD',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2));

  Widget _badge(String t, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(border: Border.all(color: c), borderRadius: BorderRadius.circular(5)),
    child: Text(t, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
  );

  Widget _info(IconData i, String t) => Row(children: [
    Icon(i, color: AppColors.accent, size: 16),
    const SizedBox(width: 5),
    Text(t, style: const TextStyle(color: Colors.white70, fontSize: 12)),
  ]);
}


