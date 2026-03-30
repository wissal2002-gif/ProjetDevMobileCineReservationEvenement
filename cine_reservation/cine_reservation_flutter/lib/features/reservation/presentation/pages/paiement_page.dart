import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/reservation_provider.dart';
import '../../data/reservation_remote_datasource.dart';
import '../../../../core/router/navigation_state_provider.dart';

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    final digits = newVal.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return newVal.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    var digits = newVal.text.replaceAll('/', '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return newVal.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class PaiementPage extends ConsumerStatefulWidget {
  final Seance? seance;
  final Evenement? evenement;
  final String filmTitre;

  const PaiementPage({
    super.key,
    this.seance,
    this.evenement,
    required this.filmTitre,
  });

  @override
  ConsumerState<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends ConsumerState<PaiementPage> {
  String _methodePaiement = 'carte';
  bool _chargement = false;

  final _carteCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _carteCtrl.dispose();
    _nomCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _methodes = [
    {'id': 'carte', 'label': 'Carte Bancaire', 'icon': Icons.credit_card},
    {'id': 'paypal', 'label': 'PayPal', 'icon': Icons.account_balance_wallet},
    {'id': 'especes', 'label': 'Espèces (en caisse)', 'icon': Icons.money},
  ];

  @override
  Widget build(BuildContext context) {
    final panier = ref.watch(panierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.filmTitre,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const Text('Paiement',
              style: TextStyle(color: AppColors.accent, fontSize: 11)),
        ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecap(panier),
                const SizedBox(height: 28),
                const Text('MÉTHODE DE PAIEMENT',
                    style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.5)),
                const SizedBox(height: 14),
                ..._methodes.map((m) => _methodeItem(m)),
                const SizedBox(height: 24),
                if (_methodePaiement == 'carte') _buildFormulaireCarte(),
                if (_methodePaiement == 'paypal') _buildFormulairePaypal(),
                if (_methodePaiement == 'especes') _buildInfoEspeces(),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _chargement
                        ? null
                        : () => _payer(context, ref, panier),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _chargement
                        ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                        : Text(
                        'PAYER ${panier.total.toStringAsFixed(2)} MAD',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.lock, color: Colors.white38, size: 14),
                    SizedBox(width: 4),
                    Text('Paiement sécurisé SSL',
                        style:
                        TextStyle(color: Colors.white38, fontSize: 12)),
                  ]),
                ),
                const SizedBox(height: 20),
              ]),
        ),
      ),
    );
  }

  Widget _buildRecap(PanierState panier) {
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
            const Text('RÉCAPITULATIF',
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.5)),
            const SizedBox(height: 12),
            Text(widget.filmTitre,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 8),
            Text('${panier.nombreSieges} siège(s)',
                style: const TextStyle(color: Colors.white70)),
            // ✅ Afficher les options sélectionnées dans le récap
            if (panier.options.isNotEmpty) ...[
              const SizedBox(height: 4),
              ...panier.options.map((o) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${o.nom} x${o.quantite}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    Text(
                        '${(o.prix * o.quantite).toStringAsFixed(0)} MAD',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              )),
              const SizedBox(height: 4),
              Text(
                  'Sous-total options : ${panier.sousTotalOptions.toStringAsFixed(2)} MAD',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13)),
            ],
            if (panier.codePromo != null &&
                panier.codePromo!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Code promo : ${panier.codePromo}',
                  style:
                  const TextStyle(color: Colors.green, fontSize: 12)),
            ],
            const Divider(color: Colors.white12, height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('${panier.total.toStringAsFixed(2)} MAD',
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ]),
          ]),
    );
  }

  Widget _methodeItem(Map<String, dynamic> m) {
    final sel = _methodePaiement == m['id'];
    return GestureDetector(
      onTap: () => setState(() => _methodePaiement = m['id'] as String),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
          sel ? AppColors.accent.withOpacity(0.15) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: sel ? AppColors.accent : AppColors.divider,
              width: sel ? 2 : 1),
        ),
        child: Row(children: [
          Icon(m['icon'] as IconData,
              color: sel ? AppColors.accent : Colors.white54, size: 24),
          const SizedBox(width: 14),
          Text(m['label'] as String,
              style: TextStyle(
                  color: sel ? Colors.white : Colors.white70,
                  fontWeight:
                  sel ? FontWeight.bold : FontWeight.normal)),
          const Spacer(),
          if (sel)
            const Icon(Icons.check_circle,
                color: AppColors.accent, size: 20),
        ]),
      ),
    );
  }

  Widget _buildFormulaireCarte() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
      ),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.credit_card,
              color: AppColors.accent, size: 20),
          const SizedBox(width: 8),
          const Text('Informations de carte',
              style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const Spacer(),
          Row(children: [
            _cardLogo('VISA'),
            const SizedBox(width: 6),
            _cardLogo('MC'),
          ]),
        ]),
        const SizedBox(height: 20),
        _buildField(
          controller: _carteCtrl,
          label: 'Numéro de carte',
          hint: '0000 0000 0000 0000',
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          maxLength: 19,
          validator: (v) {
            if (v == null || v.replaceAll(' ', '').length < 16)
              return 'Numéro de carte invalide';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildField(
          controller: _nomCtrl,
          label: 'Nom sur la carte',
          hint: 'PRÉNOM NOM',
          icon: Icons.person_outline,
          textCapitalization: TextCapitalization.characters,
          validator: (v) {
            if (v == null || v.trim().length < 3) return 'Nom requis';
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: _buildField(
              controller: _expiryCtrl,
              label: 'Date d\'expiration',
              hint: 'MM/AA',
              icon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ExpiryFormatter(),
              ],
              maxLength: 5,
              validator: (v) {
                if (v == null || v.length < 5) return 'Date invalide';
                return null;
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildField(
              controller: _cvvCtrl,
              label: 'CVV',
              hint: '•••',
              icon: Icons.lock_outline,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              maxLength: 3,
              obscureText: true,
              validator: (v) {
                if (v == null || v.length < 3) return 'CVV invalide';
                return null;
              },
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _buildFormulairePaypal() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF0070BA).withOpacity(0.5)),
      ),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0070BA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('PayPal',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          const SizedBox(width: 12),
          const Text('Connexion à votre compte',
              style:
              TextStyle(color: AppColors.textLight, fontSize: 13)),
        ]),
        const SizedBox(height: 20),
        _buildField(
          controller: _emailCtrl,
          label: 'Email PayPal',
          hint: 'exemple@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || !v.contains('@'))
              return 'Email invalide';
            return null;
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0070BA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(children: [
            Icon(Icons.info_outline,
                color: Color(0xFF0070BA), size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Vous serez redirigé vers PayPal pour confirmer le paiement.',
                style:
                TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildInfoEspeces() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.withOpacity(0.4)),
      ),
      child: Column(children: [
        const Icon(Icons.store, color: Colors.green, size: 40),
        const SizedBox(height: 12),
        const Text('Paiement en caisse',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 8),
        const Text(
          'Votre réservation sera confirmée. Présentez-vous à la caisse 30 minutes avant la séance pour régler.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textLight, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 12),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border:
            Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: const Text(
              'Réservation gratuite — paiement sur place',
              style: TextStyle(color: Colors.green, fontSize: 12)),
        ),
      ]),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
        counterText: '',
        filled: true,
        fillColor: AppColors.inputBg,
        labelStyle: const TextStyle(color: AppColors.textLight),
        hintStyle: const TextStyle(color: Colors.white24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }

  Widget _cardLogo(String label) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white24),
    ),
    child: Text(label,
        style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold)),
  );

  Future<void> _payer(
      BuildContext context, WidgetRef ref, PanierState panier) async {
    if (_methodePaiement == 'carte' || _methodePaiement == 'paypal') {
      if (!(_formKey.currentState?.validate() ?? false)) return;
    }

    setState(() => _chargement = true);
    final ds = ReservationRemoteDatasource();

    try {
      final nav = ref.read(navigationProvider);
      final isEvenement = nav.evenement != null;

      // ✅ FIX 1 : Lire options depuis panierProvider
      // Répéter chaque id selon sa quantité
      final optionsIds = panier.options
          .expand((o) => List.filled(o.quantite, o.id))
          .toList();

      print('💰 Sièges: ${panier.sieges.map((s) => s.siege.id).toList()}');
      print('💰 Options IDs: $optionsIds');
      print('💰 CodePromo ID: ${panier.codePromoId}');
      print('💰 Total: ${panier.total}');

      final reservation = await ds.creerReservation(
        seanceId: isEvenement ? null : nav.seance?.id,
        evenementId: isEvenement ? nav.evenement!.id : null,
        montantTotal: panier.total,
        siegeIds: panier.sieges.map((s) => s.siege.id!).toList(),
        optionsIds: optionsIds.isEmpty ? null : optionsIds, // ✅ FIX 1
        codePromoId: panier.codePromoId, // ✅ FIX 3
      );

      if (reservation == null) {
        throw Exception('Erreur lors de la création de la réservation');
      }

      await Future.delayed(const Duration(milliseconds: 800));

      final paiement = await ds.effectuerPaiement(
        reservationId: reservation.id!,
        montant: panier.total,
        methode: _methodePaiement,
      );

      if (paiement == null) {
        throw Exception('Erreur lors du paiement');
      }

      final billets =
      await ds.getBilletsByReservation(reservation.id!);
      ref.read(panierProvider.notifier).vider();

      if (mounted) {
        context.pushReplacement('/confirmation', extra: {
          'reservation': reservation,
          'paiement': paiement,
          'billets': billets,
          'filmTitre': widget.filmTitre,
          'seance': widget.seance,
          'evenement': widget.evenement,
          'sieges': panier.sieges,
        });
      }
    } catch (e) {
      print('❌ Erreur paiement: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red));
      }
      setState(() => _chargement = false);
    }
  }
}