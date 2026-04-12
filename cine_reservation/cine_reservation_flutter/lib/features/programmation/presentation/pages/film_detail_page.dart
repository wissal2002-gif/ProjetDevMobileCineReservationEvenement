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
import '../providers/avis_provider.dart';
import '../../../reservation/presentation/pages/seat_selection_page.dart';
import '../../../reservation/presentation/providers/reservation_provider.dart';
import '../../../profil/presentation/widgets/bouton_favori.dart';

class FilmDetailPage extends ConsumerWidget {
  final int filmId;
  const FilmDetailPage({super.key, required this.filmId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmAsync = ref.watch(filmDetailProvider(filmId));
    final seancesAsync = ref.watch(seancesFilmProvider(filmId));
    final cinemasAsync = ref.watch(allCinemasProvider);
    final sallesAsync = ref.watch(allSallesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: filmAsync.when(
        data: (film) => film == null
            ? const Center(
            child: Text('Film non trouve',
                style: TextStyle(color: Colors.white)))
            : _buildBody(context, ref, film, seancesAsync,
            cinemasAsync, sallesAsync),
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, s) => Center(
            child: Text('Erreur: $e',
                style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      WidgetRef ref,
      Film film,
      AsyncValue<List<Seance>> seancesAsync,
      AsyncValue<List<Cinema>> cinemasAsync,
      AsyncValue<List<Salle>> sallesAsync,
      ) {
    return CustomScrollView(
      slivers: [
        // ─── APP BAR avec affiche ────────────────────────
        SliverAppBar(
          expandedHeight: 500,
          backgroundColor: AppColors.background,
          pinned: true,
          actions: [BoutonFavoriFilm(filmId: filmId)],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: film.affiche ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (c, u, e) => Container(
                    color: AppColors.cardBg,
                    child: const Icon(Icons.movie,
                        size: 50, color: Colors.white24),
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
                if (film.bandeAnnonce != null &&
                    film.bandeAnnonce!.isNotEmpty)
                  Center(
                    child: FloatingActionButton.extended(
                      heroTag: 'bande_annonce_${film.id}',
                      onPressed: () async {
                        final uri = Uri.parse(film.bandeAnnonce!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
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
                // ─── Titre + classification ──────────────
                Row(children: [
                  Expanded(
                    child: Text(film.titre,
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  if (film.classification != null)
                    _badge(
                        film.classification!,
                        film.classification!.contains('18')
                            ? Colors.red
                            : Colors.orange),
                ]),
                const SizedBox(height: 12),

                // ─── Infos rapides ───────────────────────
                Row(children: [
                  _info(Icons.movie, film.genre ?? 'N/A'),
                  const SizedBox(width: 20),
                  _info(Icons.timer, '${film.duree ?? 0} min'),
                  const SizedBox(width: 20),
                  _info(Icons.language, film.langue ?? 'VF'),
                ]),
                const SizedBox(height: 20),

                // ─── NOTE MOYENNE + WIDGET NOTATION ─────
                _buildNotationSection(context, ref, film),

                const SizedBox(height: 30),

                // ─── Synopsis ───────────────────────────
                _sectionTitle('SYNOPSIS'),
                const SizedBox(height: 10),
                Text(film.synopsis ?? '',
                    style: const TextStyle(
                        color: Colors.white70, height: 1.5)),
                const SizedBox(height: 30),

                // ─── Réalisateur & casting ───────────────
                _sectionTitle('REALISATEUR & CASTING'),
                const SizedBox(height: 10),
                Text('Realise par : ${film.realisateur ?? "N/A"}',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                Text('Casting : ${film.casting ?? "N/A"}',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 25),

                // ─── Places disponibles ──────────────────
                _sectionTitle('PLACES DISPONIBLES'),
                seancesAsync.when(
                  data: (list) {
                    final total = list.fold<int>(
                        0, (s, e) => s + e.placesDisponibles);
                    return Text('$total places disponibles',
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16));
                  },
                  loading: () => const CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.accent),
                  error: (_, __) => const Text('N/A',
                      style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 40),

                // ─── Séances ────────────────────────────
                const Text('SEANCES & CINEMAS',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
                  loading: () => const CircularProgressIndicator(
                      color: AppColors.accent),
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

  // ═══════════════════════════════════════════════════════
  // SECTION NOTATION
  // ═══════════════════════════════════════════════════════

  Widget _buildNotationSection(
      BuildContext context, WidgetRef ref, Film film) {
    final statsAsync = ref.watch(statsFilmProvider(film.id!));
    final monAvisAsync = ref.watch(monAvisProvider(film.id!));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          statsAsync.when(
            data: (stats) {
              final moyenne = (stats['moyenne'] as num).toDouble();
              final total = stats['total'] as int;
              return Row(children: [
                ...List.generate(5, (i) {
                  if (i < moyenne.floor()) {
                    return const Icon(Icons.star,
                        color: Colors.amber, size: 22);
                  } else if (i < moyenne) {
                    return const Icon(Icons.star_half,
                        color: Colors.amber, size: 22);
                  } else {
                    return const Icon(Icons.star_border,
                        color: Colors.amber, size: 22);
                  }
                }),
                const SizedBox(width: 10),
                Text(
                  moyenne > 0
                      ? '${moyenne.toStringAsFixed(1)} / 5'
                      : 'Pas encore noté',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(width: 8),
                if (total > 0)
                  Text('($total avis)',
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 12)),
              ]);
            },
            loading: () => const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.accent)),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          const Text('VOTRE NOTE',
              style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2)),
          const SizedBox(height: 10),
          monAvisAsync.when(
            data: (noteActuelle) => _StarRatingWidget(
              filmId: film.id!,
              noteInitiale: noteActuelle,
            ),
            loading: () => const SizedBox(
                height: 36,
                width: 36,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.accent)),
            error: (_, __) => const Text(
                'Connectez-vous pour noter ce film',
                style:
                TextStyle(color: AppColors.textLight, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // SÉANCE ITEM — cinemaId passé au navigationProvider
  // ═══════════════════════════════════════════════════════

  Widget _buildSeanceItem(
      BuildContext context,
      WidgetRef ref,
      Seance seance,
      String filmTitre,
      int duree,
      AsyncValue<List<Cinema>> cinemasAsync,
      AsyncValue<List<Salle>> sallesAsync,
      ) {
    final int salleId = seance.salleId;

    // ✅ FIX : résoudre cinemaId depuis la salle
    int? cinemaId;
    String cinemaName = 'CINEMA';
    String salleName = '';
    String cinemaLieu = '';

    sallesAsync.whenData((salles) {
      try {
        final salle = salles.firstWhere((s) => s.id == seance.salleId);
        salleName = ' — ${salle.codeSalle}';
        cinemaId = salle.cinemaId; // ✅ récupérer cinemaId
        cinemasAsync.whenData((cinemas) {
          try {
            final cinema =
            cinemas.firstWhere((c) => c.id == salle.cinemaId);
            cinemaName = cinema.nom;
            cinemaLieu = '${cinema.ville}, ${cinema.adresse}';
          } catch (_) {}
        });
      } catch (_) {}
    });

    final start = seance.dateHeure.toLocal();
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
                    Text('$cinemaName$salleName'.toUpperCase(),
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                    if (cinemaLieu.isNotEmpty)
                      Text(cinemaLieu,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 10)),
                    const SizedBox(height: 5),
                    Text(
                      '${dateFmt.format(start)} de ${timeFmt.format(start)} a ${timeFmt.format(end)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Column(children: [
                _badge(seance.typeProjection ?? '2D', Colors.white),
                const SizedBox(height: 5),
                Text('${seance.placesDisponibles} places',
                    style: TextStyle(
                        color: seance.placesDisponibles > 10
                            ? Colors.green
                            : Colors.orange,
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
              // ✅ FIX : passer cinemaId dans setContext
              ref.read(navigationProvider.notifier).setContext(
                seance: seance,
                evenement: null,
                filmTitre: filmTitre,
                salleId: salleId,
                cinemaId: cinemaId, // ✅ NOUVEAU
              );
              // ✅ FIX : vider le panier avant de choisir les sièges
              ref.read(panierProvider.notifier).vider();
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
              minimumSize: const Size(double.infinity, 45),
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
    Text(l,
        style: const TextStyle(color: Colors.white38, fontSize: 10)),
    Text('${p.toStringAsFixed(0)} MAD',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold)),
  ]);

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2));

  Widget _badge(String t, Color c) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(5)),
    child: Text(t,
        style: TextStyle(
            color: c,
            fontSize: 10,
            fontWeight: FontWeight.bold)),
  );

  Widget _info(IconData i, String t) => Row(children: [
    Icon(i, color: AppColors.accent, size: 16),
    const SizedBox(width: 5),
    Text(t,
        style:
        const TextStyle(color: Colors.white70, fontSize: 12)),
  ]);
}

// ═══════════════════════════════════════════════════════
// WIDGET ÉTOILES INTERACTIF
// ═══════════════════════════════════════════════════════

class _StarRatingWidget extends ConsumerStatefulWidget {
  final int filmId;
  final int? noteInitiale;

  const _StarRatingWidget({required this.filmId, this.noteInitiale});

  @override
  ConsumerState<_StarRatingWidget> createState() =>
      _StarRatingWidgetState();
}

class _StarRatingWidgetState extends ConsumerState<_StarRatingWidget> {
  int _noteSelectionnee = 0;
  bool _enCours = false;

  @override
  void initState() {
    super.initState();
    _noteSelectionnee = widget.noteInitiale ?? 0;
  }

  Future<void> _soumettre(int note) async {
    if (_enCours) return;
    setState(() {
      _noteSelectionnee = note;
      _enCours = true;
    });

    final ok = await ref
        .read(avisNotifierProvider(widget.filmId).notifier)
        .soumettre(widget.filmId, note, ref);

    setState(() => _enCours = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            Icon(ok ? Icons.check_circle : Icons.error,
                color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(ok
                ? 'Note $note/5 enregistrée !'
                : 'Erreur — connectez-vous pour noter'),
          ]),
          backgroundColor: ok ? AppColors.success : AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );

      if (ok) {
        ref.invalidate(statsFilmProvider(widget.filmId));
        ref.invalidate(monAvisProvider(widget.filmId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (i) {
            final etoile = i + 1;
            return GestureDetector(
              onTap: _enCours ? null : () => _soumettre(etoile),
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _enCours
                    ? const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.accent))
                    : Icon(
                  etoile <= _noteSelectionnee
                      ? Icons.star
                      : Icons.star_border,
                  color: etoile <= _noteSelectionnee
                      ? Colors.amber
                      : Colors.white38,
                  size: 36,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          _noteSelectionnee == 0
              ? 'Appuyez sur une étoile pour noter'
              : _labelNote(_noteSelectionnee),
          style: TextStyle(
            color: _noteSelectionnee == 0
                ? AppColors.textLight
                : Colors.amber,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _labelNote(int note) {
    switch (note) {
      case 1:
        return '⭐ Très mauvais';
      case 2:
        return '⭐⭐ Mauvais';
      case 3:
        return '⭐⭐⭐ Moyen';
      case 4:
        return '⭐⭐⭐⭐ Bon';
      case 5:
        return '⭐⭐⭐⭐⭐ Excellent !';
      default:
        return '';
    }
  }
}