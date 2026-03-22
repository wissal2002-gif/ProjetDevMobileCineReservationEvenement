import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/reservation_provider.dart';

class SeatSelectionPage extends ConsumerStatefulWidget {
  final Seance? seance;
  final Evenement? evenement;
  final int salleId;
  final String filmTitre;

  const SeatSelectionPage({
    super.key,
    this.seance,
    this.evenement,
    required this.salleId,
    required this.filmTitre,
  });

  @override
  ConsumerState<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends ConsumerState<SeatSelectionPage> {
  String _typeTarif = 'normal';

  double get _prixUnitaire {
    final s = widget.seance;
    if (s == null) return widget.evenement?.prix ?? 0;
    switch (_typeTarif) {
      case 'reduit': return s.prixReduit ?? s.prixNormal;
      case 'enfant': return s.prixEnfant ?? s.prixNormal;
      case 'senior': return s.prixSenior ?? s.prixNormal;
      case 'vip':    return s.prixVip    ?? s.prixNormal;
      default:       return s.prixNormal;
    }
  }

  List<_Tarif> get _tarifsDisponibles {
    final s = widget.seance;
    if (s == null) return [_Tarif('normal', 'Normal', widget.evenement?.prix ?? 0)];
    final list = <_Tarif>[_Tarif('normal', 'Normal', s.prixNormal)];
    if ((s.prixReduit ?? 0) > 0) list.add(_Tarif('reduit', 'Réduit', s.prixReduit!));
    if ((s.prixEnfant ?? 0) > 0) list.add(_Tarif('enfant', 'Enfant', s.prixEnfant!));
    if ((s.prixSenior ?? 0) > 0) list.add(_Tarif('senior', 'Senior', s.prixSenior!));
    if ((s.prixVip    ?? 0) > 0) list.add(_Tarif('vip',    'VIP',    s.prixVip!));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final siegesAsync = ref.watch(siegesBySalleProvider(widget.salleId));
    final occupesAsync = widget.seance != null
        ? ref.watch(siegesOccupesSeanceProvider(widget.seance!.id!))
        : widget.evenement != null
        ? ref.watch(siegesOccupesEvenementProvider(widget.evenement!.id!))
        : const AsyncValue.data(<int>[]);
    final panier = ref.watch(panierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.filmTitre,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            const Text('Sélectionnez vos sièges',
                style: TextStyle(color: AppColors.accent, fontSize: 11)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // ── Écran ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 16, 60, 8),
            child: Column(children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 4),
              const Text('ÉCRAN',
                  style: TextStyle(
                      color: Colors.white38, fontSize: 10, letterSpacing: 4)),
            ]),
          ),

          // ── Légende ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _legendItem(Colors.white12, 'Libre'),
              const SizedBox(width: 20),
              _legendItem(AppColors.accent, 'Sélectionné'),
              const SizedBox(width: 20),
              _legendItem(Colors.red.withOpacity(0.6), 'Occupé'),
              const SizedBox(width: 20),
              _legendItem(Colors.amber.withOpacity(0.4), 'VIP'),
            ]),
          ),

          // ── Grille sièges ────────────────────────────────────────────────
          Expanded(
            child: siegesAsync.when(
              data: (sieges) => occupesAsync.when(
                data: (occupes) => _buildGrid(sieges, occupes, panier),
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.accent)),
                error: (e, _) => _buildGrid(sieges, [], panier),
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, _) => Center(
                child: Text('Erreur: $e',
                    style: const TextStyle(color: AppColors.textLight)),
              ),
            ),
          ),

          // ── Tarifs ───────────────────────────────────────────────────────
          if (widget.seance != null) _buildTarifs(),

          // ── Barre bas ───────────────────────────────────────────────────
          _buildBottomBar(context, panier),
        ],
      ),
    );
  }

  Widget _buildGrid(
      List<Siege> sieges, List<int> occupes, PanierState panier) {
    if (sieges.isEmpty) {
      return const Center(
        child: Text('Aucun siège pour cette salle',
            style: TextStyle(color: AppColors.textLight, fontSize: 16)),
      );
    }

    final Map<String, List<Siege>> parRangee = {};
    for (final s in sieges) {
      parRangee.putIfAbsent(s.rangee ?? 'A', () => []).add(s);
    }
    final rangees = parRangee.keys.toList()..sort();

    return LayoutBuilder(
      builder: (context, constraints) {
        const labelWidth = 20.0;
        const spacing = 5.0;
        final availableWidth =
            constraints.maxWidth - 32 - (labelWidth * 2) - 16;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: rangees.map((rangee) {
              final liste = parRangee[rangee]!
                ..sort((a, b) => a.numero.compareTo(b.numero));
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: labelWidth,
                      child: Text(rangee,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: availableWidth,
                      child: Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        children: liste.map((siege) {
                          final occupe = occupes.contains(siege.id);
                          final selectionne = panier.sieges
                              .any((s) => s.siege.id == siege.id);
                          return _buildSiege(siege, occupe, selectionne);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: labelWidth,
                      child: Text(rangee,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSiege(Siege siege, bool occupe, bool selectionne) {
    Color couleur;
    if (occupe) {
      couleur = Colors.red.withOpacity(0.5);
    } else if (selectionne) {
      couleur = AppColors.accent;
    } else if (siege.type == 'vip') {
      couleur = Colors.amber.withOpacity(0.3);
    } else {
      couleur = Colors.white12;
    }

    return GestureDetector(
      onTap: occupe
          ? null
          : () {
        if (selectionne) {
          ref.read(panierProvider.notifier).retirerSiege(siege.id!);
        } else {
          // Prix selon le type de tarif sélectionné
          final prix = siege.type == 'vip'
              ? (widget.seance?.prixVip ?? _prixUnitaire)
              : _prixUnitaire;
          ref.read(panierProvider.notifier).ajouterSiege(
            SiegeSelectionne(
              siege: siege,
              typeBillet: _typeTarif,
              prix: prix,
            ),
          );
        }
      },
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: couleur,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selectionne ? AppColors.accent : Colors.white12,
            width: selectionne ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            siege.numero.replaceAll(RegExp(r'[A-Z]'), ''),
            style: TextStyle(
              color: occupe ? Colors.white24 : Colors.white70,
              fontSize: 9,
              fontWeight: selectionne ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTarifs() {
    return Container(
      color: AppColors.cardBg.withOpacity(0.6),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('TYPE DE TARIF',
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 10,
                  letterSpacing: 1.5)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tarifsDisponibles.map((t) {
                final sel = _typeTarif == t.key;
                Color chipColor;
                switch (t.key) {
                  case 'vip':    chipColor = Colors.purple; break;
                  case 'enfant': chipColor = Colors.green; break;
                  case 'senior': chipColor = Colors.orange; break;
                  case 'reduit': chipColor = Colors.blue; break;
                  default:       chipColor = AppColors.accent;
                }
                return GestureDetector(
                  onTap: () => setState(() {
                    _typeTarif = t.key;
                    // Vider la sélection si on change de tarif
                    ref.read(panierProvider.notifier).vider();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? chipColor.withOpacity(0.2)
                          : AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel ? chipColor : AppColors.divider,
                        width: sel ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.label,
                            style: TextStyle(
                              color: sel ? chipColor : AppColors.textLight,
                              fontSize: 11,
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            )),
                        Text('${t.prix.toStringAsFixed(0)} MAD',
                            style: TextStyle(
                              color: sel ? chipColor : AppColors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, PanierState panier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${panier.nombreSieges} siège(s)',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
                Text(
                  '${panier.sousTotalSieges.toStringAsFixed(2)} MAD',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: panier.nombreSieges == 0
                  ? null
                  : () => context.push('/panier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('CONTINUER',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color c, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
              color: c, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 4),
      Text(label,
          style:
          const TextStyle(color: Colors.white54, fontSize: 11)),
    ],
  );
}

class _Tarif {
  final String key, label;
  final double prix;
  _Tarif(this.key, this.label, this.prix);
}