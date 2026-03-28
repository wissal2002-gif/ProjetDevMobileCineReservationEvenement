import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import 'dart:convert';


// ── Provider ──────────────────────────────────────────────────────────────────
final avisFilmsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final jsonStr = await client.admin.getAvisFilmsCinema();
  final list = jsonDecode(jsonStr) as List<dynamic>;
  return list.cast<Map<String, dynamic>>();
});

// ── Page ──────────────────────────────────────────────────────────────────────
class AvisClientsPage extends ConsumerStatefulWidget {
  const AvisClientsPage({super.key});

  @override
  ConsumerState<AvisClientsPage> createState() => _AvisClientsPageState();
}

class _AvisClientsPageState extends ConsumerState<AvisClientsPage> {
  String _filtreFilm = 'Tous';
  int? _filtreNote;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final admin = ref.watch(adminProfileProvider).value;
    final avisAsync = ref.watch(avisFilmsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (!isMobile) const LocalAdminSidebar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AVIS CLIENTS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 20 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            admin?.nomCinema ?? "Cinéma",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.amber, size: 26),
                        tooltip: "Actualiser",
                        onPressed: () => ref.invalidate(avisFilmsProvider),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Contenu ───────────────────────────────────────────
                  Expanded(
                    child: avisAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      ),
                      error: (e, _) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.redAccent, size: 48),
                            const SizedBox(height: 12),
                            Text("Erreur: $e",
                                style: const TextStyle(
                                    color: Colors.redAccent)),
                          ],
                        ),
                      ),
                      data: (avis) {
                        if (avis.isEmpty) {
                          return _buildEmpty();
                        }

                        // Films uniques pour le filtre
                        final films = ['Tous'] +
                            avis
                                .map((a) => a['filmTitre'] as String)
                                .toSet()
                                .toList();

                        // Filtrage
                        final filtered = avis.where((a) {
                          final matchFilm = _filtreFilm == 'Tous' ||
                              a['filmTitre'] == _filtreFilm;
                          final matchNote = _filtreNote == null ||
                              a['note'] == _filtreNote;
                          return matchFilm && matchNote;
                        }).toList();

                        // Stats globales
                        final totalAvis = avis.length;
                        final moyenneNote = avis.isEmpty
                            ? 0.0
                            : avis.fold<double>(
                            0,
                                (sum, a) =>
                            sum + (a['note'] as int)) /
                            avis.length;

                        final Map<int, int> parNote = {
                          5: 0, 4: 0, 3: 0, 2: 0, 1: 0
                        };
                        for (final a in avis) {
                          final n = a['note'] as int;
                          parNote[n] = (parNote[n] ?? 0) + 1;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Stats résumé ──────────────────────────
                            _buildStatsHeader(
                                totalAvis, moyenneNote, parNote, isMobile),

                            const SizedBox(height: 24),

                            // ── Filtres ───────────────────────────────
                            _buildFiltres(films),

                            const SizedBox(height: 16),

                            // ── Compteur résultats ────────────────────
                            Text(
                              "${filtered.length} avis trouvés",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ── Liste avis ────────────────────────────
                            Expanded(
                              child: filtered.isEmpty
                                  ? _buildEmpty(filtered: true)
                                  : ListView.builder(
                                physics:
                                const BouncingScrollPhysics(),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) =>
                                    _buildAvisCard(
                                        filtered[index], isMobile),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Header ──────────────────────────────────────────────────────────
  Widget _buildStatsHeader(int total, double moyenne,
      Map<int, int> parNote, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: isMobile
          ? Column(
        children: [
          _moyenneWidget(moyenne, total),
          const SizedBox(height: 16),
          _barresNotes(parNote, total),
        ],
      )
          : Row(
        children: [
          _moyenneWidget(moyenne, total),
          const SizedBox(width: 40),
          Expanded(child: _barresNotes(parNote, total)),
        ],
      ),
    );
  }

  Widget _moyenneWidget(double moyenne, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          moyenne.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 52,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
                (i) => Icon(
              i < moyenne.round() ? Icons.star_rounded : Icons.star_outline_rounded,
              color: Colors.amber,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$total avis au total",
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _barresNotes(Map<int, int> parNote, int total) {
    return Column(
      children: [5, 4, 3, 2, 1].map((note) {
        final count = parNote[note] ?? 0;
        final pct = total > 0 ? count / total : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // Étoiles
              Row(
                children: List.generate(
                  note,
                      (_) => const Icon(Icons.star_rounded,
                      color: Colors.amber, size: 12),
                ),
              ),
              const SizedBox(width: 8),
              // Barre
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.white.withOpacity(0.06),
                    valueColor:
                    AlwaysStoppedAnimation(_noteColor(note)),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Compteur
              SizedBox(
                width: 24,
                child: Text(
                  "$count",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Filtres ───────────────────────────────────────────────────────────────
  Widget _buildFiltres(List<String> films) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filtre film
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: films.map((film) {
              final sel = _filtreFilm == film;
              return GestureDetector(
                onTap: () => setState(() => _filtreFilm = film),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: sel
                        ? Colors.amber.withOpacity(0.15)
                        : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sel
                          ? Colors.amber.withOpacity(0.5)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Text(
                    film,
                    style: TextStyle(
                      color: sel ? Colors.amber : Colors.white54,
                      fontSize: 12,
                      fontWeight: sel
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),

        // Filtre note
        Row(
          children: [
            Text("Note : ",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12)),
            const SizedBox(width: 8),
            ...([null, 5, 4, 3, 2, 1].map((note) {
              final sel = _filtreNote == note;
              return GestureDetector(
                onTap: () => setState(() => _filtreNote = note),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: sel
                        ? _noteColor(note ?? 0).withOpacity(0.15)
                        : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel
                          ? _noteColor(note ?? 0).withOpacity(0.5)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: note == null
                      ? Text("Tous",
                      style: TextStyle(
                          color:
                          sel ? Colors.white : Colors.white38,
                          fontSize: 11))
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded,
                          color: _noteColor(note), size: 12),
                      const SizedBox(width: 3),
                      Text("$note",
                          style: TextStyle(
                              color: _noteColor(note),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            })),
          ],
        ),
      ],
    );
  }

  // ── Card Avis ─────────────────────────────────────────────────────────────
  Widget _buildAvisCard(Map<String, dynamic> avis, bool isMobile) {
    final note = (avis['note'] as int?) ?? 0;
    final nom = (avis['utilisateurNom'] as String?) ?? 'Client';
    final film = (avis['filmTitre'] as String?) ?? 'Film inconnu';
    final commentaire = (avis['commentaire'] as String?) ?? '';
    final dateStr = (avis['dateAvis'] as String?) ?? '';
    final date = DateTime.tryParse(dateStr);
    final dateFormatted = date != null
        ? DateFormat('dd MMM yyyy • HH:mm').format(date)
        : dateStr;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _noteColor(note).withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ligne 1 : Avatar + Nom + Note + Date ──────────────
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _noteColor(note).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    nom.isNotEmpty ? nom[0].toUpperCase() : "?",
                    style: TextStyle(
                      color: _noteColor(note),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Nom + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nom,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      dateFormatted,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Note étoiles
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _noteColor(note).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded,
                        color: _noteColor(note), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "$note/5",
                      style: TextStyle(
                        color: _noteColor(note),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Film badge ────────────────────────────────────────
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.movie_outlined,
                    color: Colors.white.withOpacity(0.4), size: 12),
                const SizedBox(width: 6),
                Text(
                  film,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ── Commentaire ───────────────────────────────────────
          if (commentaire.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Colors.white.withOpacity(0.06)),
              ),
              child: Text(
                '"$commentaire"',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
          ],

          // ── Étoiles visuelles ─────────────────────────────────
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < note
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: i < note
                    ? _noteColor(note)
                    : Colors.white.withOpacity(0.15),
                size: 16,
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmpty({bool filtered = false}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            filtered ? Icons.filter_alt_off : Icons.star_border_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            filtered
                ? "Aucun avis pour ces filtres."
                : "Aucun avis pour vos films pour l'instant.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Color _noteColor(int note) {
    switch (note) {
      case 5: return Colors.green;
      case 4: return Colors.lightGreen;
      case 3: return Colors.amber;
      case 2: return Colors.orange;
      case 1: return Colors.redAccent;
      default: return Colors.amber;
    }
  }
}