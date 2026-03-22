import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/reservation_provider.dart';
import '../../data/reservation_remote_datasource.dart';

class PanierPage extends ConsumerStatefulWidget {
  final Seance? seance;
  final Evenement? evenement;
  final String filmTitre;

  const PanierPage({
    super.key,
    this.seance,
    this.evenement,
    required this.filmTitre,
  });

  @override
  ConsumerState<PanierPage> createState() => _PanierPageState();
}

class _PanierPageState extends ConsumerState<PanierPage> {
  final _promoCtrl = TextEditingController();
  bool _promoLoading = false;
  String? _promoError;
  CodePromo? _promoApplique;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  double _montantApresReduction(PanierState panier) {
    final sous = panier.sousTotalSieges + panier.sousTotalOptions;
    if (_promoApplique == null) return sous;
    if (_promoApplique!.typeReduction == 'pourcentage') {
      return sous * (1 - _promoApplique!.reduction / 100);
    } else {
      return (sous - _promoApplique!.reduction).clamp(0, double.infinity);
    }
  }

  Future<void> _appliquerPromo(PanierState panier) async {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      _promoLoading = true;
      _promoError = null;
      _promoApplique = null;
    });

    try {
      final ds = ReservationRemoteDatasource();
      final promo = await ds.validerCodePromo(code);

      if (promo == null) {
        setState(() {
          _promoError = 'Code promo invalide ou expiré.';
          _promoLoading = false;
        });
        return;
      }

      // Vérifier montant minimum
      final sous = panier.sousTotalSieges + panier.sousTotalOptions;
      if ((promo.montantMinimum ?? 0) > sous) {
        setState(() {
          _promoError =
          'Montant minimum requis : ${promo.montantMinimum!.toStringAsFixed(2)} MAD.';
          _promoLoading = false;
        });
        return;
      }

      setState(() {
        _promoApplique = promo;
        _promoLoading = false;
      });

      // Appliquer la réduction dans le panier
      double taux = 0;
      if (promo.typeReduction == 'pourcentage') {
        taux = promo.reduction / 100;
      }
      ref
          .read(panierProvider.notifier)
          .appliquerCodePromo(code, taux);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Code "$code" appliqué ! -${promo.typeReduction == 'pourcentage' ? '${promo.reduction.toStringAsFixed(0)}%' : '${promo.reduction.toStringAsFixed(0)} MAD'}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _promoError = 'Erreur: $e';
        _promoLoading = false;
      });
    }
  }

  void _supprimerPromo() {
    setState(() {
      _promoApplique = null;
      _promoError = null;
      _promoCtrl.clear();
    });
    ref.read(panierProvider.notifier).appliquerCodePromo('', 0);
  }

  @override
  Widget build(BuildContext context) {
    final panier = ref.watch(panierProvider);
    final notifier = ref.read(panierProvider.notifier);
    final optionsAsync = ref.watch(optionsSupplementairesProvider);
    final total = _montantApresReduction(panier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.filmTitre,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const Text('Votre panier',
              style: TextStyle(color: AppColors.accent, fontSize: 11)),
        ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: panier.nombreSieges == 0
          ? const Center(
        child: Text('Votre panier est vide',
            style:
            TextStyle(color: AppColors.textLight, fontSize: 16)),
      )
          : Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Sièges ──────────────────────────────────────
              _sectionTitle('SIÈGES SÉLECTIONNÉS'),
              const SizedBox(height: 12),
              ...panier.sieges.map((s) => _siegeItem(notifier, s)),
              const SizedBox(height: 24),

              // ── Options ──────────────────────────────────────
              _sectionTitle('OPTIONS SUPPLÉMENTAIRES'),
              const SizedBox(height: 12),
              optionsAsync.when(
                data: (options) {
                  if (options.isEmpty) {
                    return const Text('Aucune option disponible',
                        style: TextStyle(
                            color: AppColors.textLight));
                  }
                  final Map<String,
                      List<OptionSupplementaire>> parCat = {};
                  for (final o in options) {
                    if (o.disponible != true) continue;
                    parCat
                        .putIfAbsent(
                        o.categorie ?? 'autre', () => [])
                        .add(o);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: parCat.entries
                        .expand((entry) => [
                      _categorieTitle(entry.key),
                      const SizedBox(height: 8),
                      ...entry.value.map((opt) =>
                          _optionRow(notifier, opt, panier)),
                      const SizedBox(height: 16),
                    ])
                        .toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.accent,
                          strokeWidth: 2)),
                ),
                error: (e, _) => Text('Erreur options: $e',
                    style: const TextStyle(
                        color: AppColors.textLight)),
              ),
              const SizedBox(height: 24),

              // ── Code Promo ────────────────────────────────────
              _buildCodePromo(panier),
              const SizedBox(height: 24),

              // ── Récap ─────────────────────────────────────────
              _recap(panier, total),
            ],
          ),
        ),
        _bottomBar(context, total),
      ]),
    );
  }

  // ── Code Promo Widget ─────────────────────────────────────────────────────
  Widget _buildCodePromo(PanierState panier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _promoApplique != null
              ? Colors.green.withOpacity(0.5)
              : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.local_offer_outlined,
                color: AppColors.accent, size: 16),
            const SizedBox(width: 8),
            const Text('CODE PROMO',
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.5)),
          ]),
          const SizedBox(height: 12),

          // Si promo appliquée
          if (_promoApplique != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Colors.green.withOpacity(0.4)),
              ),
              child: Row(children: [
                const Icon(Icons.check_circle,
                    color: Colors.green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${_promoApplique!.code}" appliqué !',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _promoApplique!.typeReduction == 'pourcentage'
                            ? '-${_promoApplique!.reduction.toStringAsFixed(0)}% de réduction'
                            : '-${_promoApplique!.reduction.toStringAsFixed(0)} MAD de réduction',
                        style: const TextStyle(
                            color: Colors.green, fontSize: 12),
                      ),
                      if (_promoApplique!.description != null)
                        Text(_promoApplique!.description!,
                            style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 11)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _supprimerPromo,
                  child: const Icon(Icons.close,
                      color: Colors.red, size: 18),
                ),
              ]),
            ),
          ] else ...[
            // Champ code promo
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _promoCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  decoration: InputDecoration(
                    hintText: 'Ex: CINE10',
                    hintStyle: const TextStyle(
                        color: Colors.white24,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal),
                    prefixIcon: const Icon(Icons.discount_outlined,
                        color: AppColors.accent, size: 18),
                    filled: true,
                    fillColor: AppColors.inputBg,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.accent, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: AppColors.error),
                    ),
                    errorText: _promoError,
                    errorStyle:
                    const TextStyle(color: AppColors.error),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                width: 90,
                child: ElevatedButton(
                  onPressed: _promoLoading
                      ? null
                      : () => _appliquerPromo(panier),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.zero,
                  ),
                  child: _promoLoading
                      ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : const Text('Appliquer',
                      style: TextStyle(fontSize: 12)),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            const Text('Codes disponibles: CINE10, CINE20, REDUC50, WELCOME',
                style: TextStyle(
                    color: AppColors.textLight, fontSize: 10)),
          ],
        ],
      ),
    );
  }

  Widget _siegeItem(PanierNotifier notifier, SiegeSelectionne s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.event_seat,
              color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Siège ${s.siege.numero} — Rangée ${s.siege.rangee ?? "?"}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text(s.typeBillet.toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 11)),
              ]),
        ),
        Text('${s.prix.toStringAsFixed(2)} MAD',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red, size: 18),
          onPressed: () => notifier.retirerSiege(s.siege.id!),
        ),
      ]),
    );
  }

  Widget _categorieTitle(String cat) {
    final labels = {
      'snack': '🍿 Snacks',
      'drink': '🥤 Boissons',
      'boisson': '🥤 Boissons',
      'combo': '🎁 Combos',
    };
    return Text(
      labels[cat.toLowerCase()] ?? cat.toUpperCase(),
      style: const TextStyle(
          color: AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1),
    );
  }

  Widget _optionRow(PanierNotifier notifier, OptionSupplementaire opt,
      PanierState panier) {
    final existant =
    panier.options.where((o) => o.nom == opt.nom).toList();
    final qte = existant.isNotEmpty ? existant.first.quantite : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: qte > 0
            ? AppColors.accent.withOpacity(0.08)
            : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: qte > 0 ? AppColors.accent : AppColors.divider),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(opt.nom,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              if (opt.description != null &&
                  opt.description!.isNotEmpty)
                Text(opt.description!,
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Text('${opt.prix.toStringAsFixed(0)} MAD',
            style: const TextStyle(
                color: AppColors.textLight, fontSize: 13)),
        const SizedBox(width: 10),
        Row(mainAxisSize: MainAxisSize.min, children: [
          if (qte > 0)
            GestureDetector(
              onTap: () {
                if (qte == 1) {
                  notifier.retirerOption(opt.nom);
                } else {
                  notifier.retirerOption(opt.nom);
                  for (var i = 0; i < qte - 1; i++) {
                    notifier.ajouterOption(
                        OptionPanier(nom: opt.nom, prix: opt.prix));
                  }
                }
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.remove,
                    color: Colors.white, size: 16),
              ),
            ),
          if (qte > 0)
            SizedBox(
              width: 32,
              child: Center(
                child: Text('$qte',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ),
          GestureDetector(
            onTap: () => notifier.ajouterOption(
                OptionPanier(nom: opt.nom, prix: opt.prix)),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.add,
                  color: Colors.white, size: 16),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _recap(PanierState panier, double total) {
    final sous = panier.sousTotalSieges + panier.sousTotalOptions;
    final reduction = sous - total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: [
        _ligne('Sous-total sièges', panier.sousTotalSieges),
        if (panier.sousTotalOptions > 0)
          _ligne('Options', panier.sousTotalOptions),
        if (_promoApplique != null && reduction > 0)
          _ligne('Réduction (${_promoApplique!.code})',
              -reduction,
              color: Colors.green),
        const Divider(color: Colors.white12, height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Text('${total.toStringAsFixed(2)} MAD',
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ]),
      ]),
    );
  }

  Widget _ligne(String label, double montant, {Color? color}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 13)),
              Text('${montant.toStringAsFixed(2)} MAD',
                  style: TextStyle(
                      color: color ?? Colors.white, fontSize: 13)),
            ]),
      );

  Widget _bottomBar(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_promoApplique != null)
                const Text('Promo appliquée ✓',
                    style: TextStyle(
                        color: Colors.green, fontSize: 11)),
              Text('Total : ${total.toStringAsFixed(2)} MAD',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () => context.push('/paiement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('PAYER',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.5));
}
