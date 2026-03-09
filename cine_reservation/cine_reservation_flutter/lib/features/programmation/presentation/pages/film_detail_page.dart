import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/programmation_provider.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:url_launcher/url_launcher.dart';

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
            ? const Center(child: Text("Film non trouvé"))
            : _buildBody(context, film, seancesAsync, optionsAsync, cinemasAsync, sallesAsync),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, s) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Film film,
      AsyncValue<List<Seance>> seances,
      AsyncValue<List<OptionSupplementaire>> options,
      AsyncValue<List<Cinema>> cinemas,
      AsyncValue<List<Salle>> salles) {

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
                    imageUrl: film.affiche ?? "",
                    fit: BoxFit.cover,
                    errorWidget: (c,u,e) => const Icon(Icons.movie, size: 50)
                ),
                const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.background]
                        )
                    )
                ),
                // Section Bande Annonce Corrigée
                if (film.bandeAnnonce != null && film.bandeAnnonce!.isNotEmpty)
                  Center(
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        final Uri url = Uri.parse(film.bandeAnnonce!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Lien de la bande annonce invalide")),
                            );
                          }
                        }
                      },
                      label: const Text("BANDE ANNONCE"),
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
                Row(
                  children: [
                    Expanded(child: Text(film.titre, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))),
                    if (film.classification != null)
                      _badge(film.classification!, film.classification!.contains('18') ? Colors.red : Colors.orange),
                  ],
                ),
                if (film.classification != null && film.classification!.contains('18'))
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("⚠️ Ce film est interdit aux mineurs.", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _info(Icons.movie, film.genre ?? "N/A"),
                    const SizedBox(width: 20),
                    _info(Icons.timer, "${film.duree ?? 0} min"),
                    const SizedBox(width: 20),
                    _info(Icons.language, film.langue ?? "VF"),
                  ],
                ),
                const SizedBox(height: 30),
                _sectionTitle("SYNOPSIS"),
                const SizedBox(height: 10),
                Text(film.synopsis ?? "", style: const TextStyle(color: Colors.white70, height: 1.5)),

                const SizedBox(height: 30),
                _sectionTitle("RÉALISATEUR & CASTING"),
                const SizedBox(height: 10),
                Text("Réalisé par : ${film.realisateur ?? 'N/A'}", style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                Text("Casting : ${film.casting ?? 'N/A'}", style: const TextStyle(color: Colors.white70)),

                const SizedBox(height: 25),
                _sectionTitle("PLACES DISPONIBLES"),
                seances.when(
                  data: (list) {
                    final totalPlaces = list.fold<int>(0, (sum, s) => sum + s.placesDisponibles);
                    return Text("$totalPlaces places disponibles sur l'ensemble des séances", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16));
                  },
                  loading: () => const CircularProgressIndicator(strokeWidth: 2),
                  error: (_, __) => const Text("N/A", style: TextStyle(color: Colors.white70)),
                ),

                const SizedBox(height: 40),
                const Text("SÉANCES & CINÉMAS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 15),
                seances.when(
                  data: (list) => Column(children: list.map((s) => _buildSeanceItem(context, s, film.duree ?? 0, cinemas, salles)).toList()),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => const SizedBox(),
                ),

                const SizedBox(height: 40),
                const Text("OPTIONS SUPPLÉMENTAIRES", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 15),
                options.when(
                  data: (list) => _buildOptions(list),
                  loading: () => const CircularProgressIndicator(),
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

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2));
  }

  Widget _buildSeanceItem(BuildContext context, Seance seance, int duree, AsyncValue<List<Cinema>> cinemas, AsyncValue<List<Salle>> salles) {
    String cinemaName = "CINÉMA";
    String cinemaLieu = "Lieu inconnu";

    salles.whenData((sList) {
      final salle = sList.firstWhere((s) => s.id == seance.salleId, orElse: () => sList.first);
      cinemas.whenData((cList) {
        final cinema = cList.firstWhere((c) => c.id == salle.cinemaId, orElse: () => cList.first);
        cinemaName = cinema.nom;
        cinemaLieu = "${cinema.ville}, ${cinema.adresse}";
      });
    });

    final startTime = seance.dateHeure;
    final endTime = startTime.add(Duration(minutes: duree));
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.divider)),
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
                    Text(cinemaName.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(cinemaLieu, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                    const SizedBox(height: 5),
                    Text(
                      "${dateFormat.format(startTime)} de ${timeFormat.format(startTime)} à ${timeFormat.format(endTime)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _badge(seance.typeProjection ?? "2D", Colors.white),
                  const SizedBox(height: 5),
                  Text("${seance.placesDisponibles} places", style: const TextStyle(color: Colors.green, fontSize: 11)),
                ],
              ),
            ],
          ),
          const Divider(height: 30, color: Colors.white10),
          _prices(seance),
          const SizedBox(height: 15),
          ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Réservation pour ${cinemaName} à ${timeFormat.format(startTime)}")),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
              child: const Text("RÉSERVER")
          ),
        ],
      ),
    );
  }

  Widget _prices(Seance s) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _p("Normal", s.prixNormal),
          const SizedBox(width: 15),
          _p("Réduit", s.prixReduit ?? 0),
          const SizedBox(width: 15),
          _p("Enfant", s.prixEnfant ?? 0),
          const SizedBox(width: 15),
          _p("Senior", s.prixSenior ?? 0),
          const SizedBox(width: 15),
          _p("VIP", s.prixVip ?? 0),
        ],
      ),
    );
  }

  Widget _p(String l, double p) => Column(children: [Text(l, style: const TextStyle(color: Colors.white38, fontSize: 10)), Text("${p}€", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);

  Widget _buildOptions(List<OptionSupplementaire> list) {
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
            child: Center(child: Text("${opt.nom}\n${opt.prix}€", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12))),
          );
        },
      ),
    );
  }

  Widget _badge(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(border: Border.all(color: c), borderRadius: BorderRadius.circular(5)), child: Text(t, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)));
  Widget _info(IconData i, String t) => Row(children: [Icon(i, color: AppColors.accent, size: 16), const SizedBox(width: 5), Text(t, style: const TextStyle(color: Colors.white70, fontSize: 12))]);
}