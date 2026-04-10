import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/reservation_provider.dart';
import 'dart:async';

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
  ConsumerState<SeatSelectionPage> createState() =>
      _SeatSelectionPageState();
}

class _SeatSelectionPageState extends ConsumerState<SeatSelectionPage>
    with WidgetsBindingObserver {
  String _typeTarifSelectionne = 'normal';
  final Map<int, String> _tarifParSiege = {};
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rafraichirSieges();
    });

    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) _rafraichirSieges();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _rafraichirSieges();
    }
  }

  void _rafraichirSieges() {
    if (widget.seance != null) {
      ref.invalidate(siegesOccupesSeanceProvider(widget.seance!.id!));
    } else if (widget.evenement != null) {
      ref.invalidate(
          siegesOccupesEvenementProvider(widget.evenement!.id!));
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ FIX : calculer le prix selon le type de tarif
  // pour séance ET pour événement cinéma
  double getPrixUnitaire(String typeTarif, Siege siege) {
    // Cas séance cinéma
    final s = widget.seance;
    if (s != null) {
      if (siege.type == 'vip') return s.prixVip ?? s.prixNormal;
      switch (typeTarif) {
        case 'reduit': return s.prixReduit ?? s.prixNormal;
        case 'enfant': return s.prixEnfant ?? s.prixNormal;
        case 'senior': return s.prixSenior ?? s.prixNormal;
        case 'vip':    return s.prixVip ?? s.prixNormal;
        default:       return s.prixNormal;
      }
    }

    // Cas événement cinéma avec plusieurs prix
    final e = widget.evenement;
    if (e != null) {
      if (siege.type == 'vip' && (e.prixVip ?? 0) > 0) {
        return e.prixVip!;
      }
      switch (typeTarif) {
        case 'vip':
          return (e.prixVip ?? 0) > 0 ? e.prixVip! : (e.prix ?? 0);
        case 'reduit':
          return (e.prixReduit ?? 0) > 0 ? e.prixReduit! : (e.prix ?? 0);
        case 'senior':
          return (e.prixSenior ?? 0) > 0 ? e.prixSenior! : (e.prix ?? 0);
        case 'enfant':
          return (e.prixEnfant ?? 0) > 0 ? e.prixEnfant! : (e.prix ?? 0);
        default:
          return e.prix ?? 0;
      }
    }

    return 0;
  }

  // ✅ FIX : tarifs disponibles pour séance ET événement
  List<_Tarif> get _tarifsDisponibles {
    // Cas séance
    final s = widget.seance;
    if (s != null) {
      final list = <_Tarif>[_Tarif('normal', 'Normal', s.prixNormal)];
      if ((s.prixReduit ?? 0) > 0)
        list.add(_Tarif('reduit', 'Réduit', s.prixReduit!));
      if ((s.prixEnfant ?? 0) > 0)
        list.add(_Tarif('enfant', 'Enfant', s.prixEnfant!));
      if ((s.prixSenior ?? 0) > 0)
        list.add(_Tarif('senior', 'Senior', s.prixSenior!));
      if ((s.prixVip ?? 0) > 0)
        list.add(_Tarif('vip', 'VIP', s.prixVip!));
      return list;
    }

    // ✅ FIX : Cas événement cinéma
    final e = widget.evenement;
    if (e != null) {
      final list = <_Tarif>[_Tarif('normal', 'Normal', e.prix ?? 0)];
      if ((e.prixVip ?? 0) > 0)
        list.add(_Tarif('vip', 'VIP', e.prixVip!));
      if ((e.prixReduit ?? 0) > 0)
        list.add(_Tarif('reduit', 'Réduit', e.prixReduit!));
      if ((e.prixSenior ?? 0) > 0)
        list.add(_Tarif('senior', 'Senior', e.prixSenior!));
      if ((e.prixEnfant ?? 0) > 0)
        list.add(_Tarif('enfant', 'Enfant', e.prixEnfant!));
      return list;
    }

    return [_Tarif('normal', 'Normal', 0)];
  }

  // ✅ FIX : afficher les tarifs pour séance ET événement
  bool get _afficherTarifs =>
      widget.seance != null || widget.evenement != null;

  @override
  Widget build(BuildContext context) {
    final siegesAsync =
    ref.watch(siegesBySalleProvider(widget.salleId));
    final occupesAsync = widget.seance != null
        ? ref.watch(siegesOccupesSeanceProvider(widget.seance!.id!))
        : widget.evenement != null
        ? ref.watch(
        siegesOccupesEvenementProvider(widget.evenement!.id!))
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
                style: const TextStyle(
                    color: Colors.white, fontSize: 16)),
            const Text('Sélectionnez vos sièges',
                style: TextStyle(
                    color: AppColors.accent, fontSize: 11)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: occupesAsync.isLoading
                ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _rafraichirSieges,
            tooltip: 'Actualiser les sièges',
          ),
        ],
      ),
      body: Column(
        children: [
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
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 4)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendItem(Colors.white12, 'Libre'),
                  const SizedBox(width: 20),
                  _legendItem(AppColors.accent, 'Sélectionné'),
                  const SizedBox(width: 20),
                  _legendItem(
                      Colors.red.withOpacity(0.6), 'Occupé'),
                  const SizedBox(width: 20),
                  _legendItem(
                      Colors.amber.withOpacity(0.4), 'VIP'),
                ]),
          ),
          occupesAsync.when(
            data: (_) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'Mis à jour à ${TimeOfDay.now().format(context)}',
                style: const TextStyle(
                    color: Colors.white24, fontSize: 10),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Actualisation...',
                  style: TextStyle(
                      color: AppColors.accent, fontSize: 10)),
            ),
            error: (_, __) => const SizedBox(),
          ),
          Expanded(
            child: siegesAsync.when(
              data: (sieges) => occupesAsync.when(
                data: (occupes) =>
                    _buildGrid(sieges, occupes, panier),
                loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.accent)),
                error: (e, _) =>
                    _buildGrid(sieges, [], panier),
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.accent)),
              error: (e, _) => Center(
                child: Text('Erreur: $e',
                    style: const TextStyle(
                        color: AppColors.textLight)),
              ),
            ),
          ),
          // ✅ FIX : afficher les tarifs pour séance ET événement
          if (_afficherTarifs) _buildTarifs(),
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
            style: TextStyle(
                color: AppColors.textLight, fontSize: 16)),
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
                          final occupe =
                          occupes.contains(siege.id);
                          final selectionne = panier.sieges
                              .any((s) => s.siege.id == siege.id);

                          if (occupe && selectionne) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) {
                              ref
                                  .read(panierProvider.notifier)
                                  .retirerSiege(siege.id!);
                              setState(() {
                                _tarifParSiege.remove(siege.id);
                              });
                            });
                          }

                          final tarifSiege =
                              _tarifParSiege[siege.id!] ??
                                  _typeTarifSelectionne;
                          return _buildSiege(siege, occupe,
                              selectionne && !occupe, tarifSiege);
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

  Widget _buildSiege(
      Siege siege, bool occupe, bool selectionne, String tarifSiege) {
    Color couleur;
    if (occupe) {
      couleur = Colors.red.withOpacity(0.5);
    } else if (selectionne) {
      switch (tarifSiege) {
        case 'vip':    couleur = Colors.purple.withOpacity(0.7); break;
        case 'enfant': couleur = Colors.green.withOpacity(0.7); break;
        case 'senior': couleur = Colors.orange.withOpacity(0.7); break;
        case 'reduit': couleur = Colors.blue.withOpacity(0.7); break;
        default:       couleur = AppColors.accent;
      }
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
          ref
              .read(panierProvider.notifier)
              .retirerSiege(siege.id!);
          setState(() {
            _tarifParSiege.remove(siege.id);
          });
        } else {
          final tarifChoisi = _typeTarifSelectionne;
          final prix = getPrixUnitaire(tarifChoisi, siege);
          ref.read(panierProvider.notifier).ajouterSiege(
            SiegeSelectionne(
              siege: siege,
              typeBillet: tarifChoisi,
              prix: prix,
            ),
          );
          setState(() {
            _tarifParSiege[siege.id!] = tarifChoisi;
          });
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
            color: occupe
                ? Colors.red.withOpacity(0.3)
                : selectionne
                ? (tarifSiege == 'vip'
                ? Colors.purple
                : AppColors.accent)
                : Colors.white12,
            width: selectionne ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            siege.numero.replaceAll(RegExp(r'[A-Z]'), ''),
            style: TextStyle(
              color: occupe ? Colors.white24 : Colors.white70,
              fontSize: 9,
              fontWeight: selectionne
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTarifs() {
    final tarifs = _tarifsDisponibles;
    // Ne pas afficher la section si un seul prix
    if (tarifs.length <= 1) return const SizedBox();

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
          const Text('Choisissez le tarif pour le prochain siège',
              style:
              TextStyle(color: AppColors.textLight, fontSize: 9)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tarifs.map((t) {
                final sel = _typeTarifSelectionne == t.key;
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
                    _typeTarifSelectionne = t.key;
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
                              color: sel
                                  ? chipColor
                                  : AppColors.textLight,
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
    final Map<String, int> siegeParTarif = {};
    for (final s in panier.sieges) {
      siegeParTarif[s.typeBillet] =
          (siegeParTarif[s.typeBillet] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (siegeParTarif.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: siegeParTarif.entries.map((entry) {
                  String label;
                  Color color;
                  switch (entry.key) {
                    case 'vip':    label = 'VIP';    color = Colors.purple; break;
                    case 'enfant': label = 'Enfant'; color = Colors.green; break;
                    case 'senior': label = 'Senior'; color = Colors.orange; break;
                    case 'reduit': label = 'Réduit'; color = Colors.blue; break;
                    default:       label = 'Normal'; color = AppColors.accent;
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${entry.value} x $label',
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
              ),
            ),
          Row(
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
                      style:
                      TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
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
              color: c,
              borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(
              color: Colors.white54, fontSize: 11)),
    ],
  );
}

class _Tarif {
  final String key, label;
  final double prix;
  _Tarif(this.key, this.label, this.prix);
}