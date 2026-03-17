import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profil_provider.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _dateNaissance;
  bool _editing = false;
  bool _telephoneChanged = false;
  bool _dateChanged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profilProvider.notifier).loadProfil();
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════
  // HELPERS FIDÉLITÉ
  // ═══════════════════════════════════════════════════════

  String _getNiveau(int points) {
    if (points >= 500) return 'or';
    if (points >= 200) return 'argent';
    return 'bronze';
  }

  Color _getNiveauColor(String niveau) {
    switch (niveau) {
      case 'or':     return const Color(0xFFFFD700);
      case 'argent': return const Color(0xFFC0C0C0);
      default:       return const Color(0xFFCD7F32);
    }
  }

  IconData _getNiveauIcon(String niveau) {
    switch (niveau) {
      case 'or':     return Icons.emoji_events;
      case 'argent': return Icons.military_tech;
      default:       return Icons.workspace_premium;
    }
  }

  int _getPointsNiveauActuel(int points) {
    if (points >= 500) return 500;
    if (points >= 200) return 200;
    return 0;
  }

  int _getPointsProchainNiveau(int points) {
    if (points >= 500) return 500;
    if (points >= 200) return 500;
    return 200;
  }

  String _getProchainNiveauLabel(int points) {
    if (points >= 500) return 'or';
    if (points >= 200) return 'or';
    return 'argent';
  }

  List<String> _getAvantages(String niveau) {
    switch (niveau) {
      case 'or':
        return [
          'Accès prioritaire aux avant-premières',
          'Code promo exclusif mensuel (-15%)',
          'Places VIP à tarif réduit',
          'Invitations événements spéciaux',
          'Support prioritaire 24/7',
        ];
      case 'argent':
        return [
          'Code promo trimestriel (-10%)',
          'Réduction sur les séances VIP',
          'Accès anticipé aux ventes',
          'Support prioritaire',
        ];
      default:
        return [
          '1 point par 10 MAD dépensés',
          'Offres exclusives membres',
          'Historique de réservations',
        ];
    }
  }

  // ═══════════════════════════════════════════════════════
  // ACTIONS — inchangées
  // ═══════════════════════════════════════════════════════

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.first.bytes != null) {
      await ref.read(profilProvider.notifier).updatePhoto(result.files.first.bytes!);
    }
  }

  void _startEditing(ProfilState profilState) {
    _nomController.text = profilState.utilisateur?.nom ?? '';
    _telephoneController.text = profilState.utilisateur?.telephone ?? '';
    _dateNaissance = profilState.utilisateur?.dateNaissance;
    _telephoneChanged = false;
    _dateChanged = false;
    setState(() => _editing = true);
  }

  void _showChangerMotDePasse() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Changer le mot de passe',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Un email de reinitialisation vous sera envoye.\n\nVous devrez confirmer via le code recu par email.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout().then((_) {
                context.go('/forgot-password');
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }

  void _showDesactiverCompte() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Desactiver le compte',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Votre compte sera temporairement desactive. Vous pourrez le reactivier en contactant le support.\n\nEtes-vous sur ?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await ref.read(profilProvider.notifier).desactiverCompte();
              if (ok && mounted) {
                await ref.read(authProvider.notifier).logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Compte desactive. Contactez le support pour le reactivier.'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Desactiver'),
          ),
        ],
      ),
    );
  }

  void _showSupprimerCompte() {
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Supprimer le compte',
            style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cette action est irreversible. Toutes vos donnees seront supprimees definitivemet.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const Text('Tapez SUPPRIMER pour confirmer :',
                style: TextStyle(color: Colors.white60, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(
              controller: confirmController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'SUPPRIMER',
                hintStyle: TextStyle(color: Colors.white24),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (confirmController.text.trim() != 'SUPPRIMER') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Tapez exactement SUPPRIMER'),
                      backgroundColor: Colors.red),
                );
                return;
              }
              Navigator.pop(ctx);
              final ok = await ref.read(profilProvider.notifier).supprimerCompte();
              if (ok && mounted) {
                await ref.read(authProvider.notifier).logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Compte supprime definitivement.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer definitivement'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final profilState = ref.watch(profilProvider);

    ref.listen(profilProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppColors.error),
        );
      }
      if (next.saveSuccess && previous?.saveSuccess != true) {
        setState(() {
          _editing = false;
          _telephoneChanged = false;
          _dateChanged = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Profil mis a jour avec succes !'),
            ]),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    if (profilState.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.accent));
    }

    final user = profilState.utilisateur;
    final photoBytes = profilState.photoBytes;

    // données fidélité calculées ici pour réutilisation
    final points = user?.pointsFidelite ?? 0;
    final niveau = _getNiveau(points);
    final niveauColor = _getNiveauColor(niveau);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // ─── Avatar ─────────────────────────────────────
          Center(
            child: Stack(
              children: [
                profilState.isSaving
                    ? const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.secondary,
                  child: CircularProgressIndicator(
                      color: AppColors.accent, strokeWidth: 2),
                )
                    : GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.secondary,
                    backgroundImage: photoBytes != null
                        ? MemoryImage(photoBytes)
                        : null,
                    child: photoBytes == null
                        ? Text(
                      user?.nom.isNotEmpty == true
                          ? user!.nom[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          fontSize: 36,
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold),
                    )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: Text(user?.nom ?? '',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white)),
          ),
          Center(
            child: Text(user?.email ?? '',
                style: const TextStyle(
                    color: AppColors.textLight, fontSize: 14)),
          ),
          const SizedBox(height: 8),

          // ─── Badge fidélité cliquable ────────────────────
          Center(
            child: GestureDetector(
              onTap: () =>
                  _showFideliteInfo(context, points, niveau, niveauColor),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: niveauColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: niveauColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getNiveauIcon(niveau),
                        color: niveauColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '$points pts • ${niveau.toUpperCase()}',
                      style: TextStyle(
                          color: niveauColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.info_outline,
                        color: niveauColor.withOpacity(0.7), size: 14),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ─── Carte fidélité ──────────────────────────────
          _buildFideliteCard(points, niveau, niveauColor),

          const SizedBox(height: 24),

          // ─── Infos / Formulaire ──────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: _editing
                ? _buildEditForm(profilState)
                : _buildInfos(user, profilState),
          ),

          const SizedBox(height: 24),

          // ─── Actions compte ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Securite et compte',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 12),
                const Divider(color: Colors.white10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.lock_outline,
                      color: AppColors.accent),
                  title: const Text('Changer le mot de passe',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text(
                      'Modifier via email de reinitialisation',
                      style: TextStyle(
                          color: Colors.white38, fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white24, size: 14),
                  onTap: _showChangerMotDePasse,
                ),
                const Divider(color: Colors.white10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.pause_circle_outline,
                      color: Colors.orange),
                  title: const Text('Desactiver le compte',
                      style: TextStyle(color: Colors.orange)),
                  subtitle: const Text('Suspension temporaire du compte',
                      style: TextStyle(
                          color: Colors.white38, fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white24, size: 14),
                  onTap: _showDesactiverCompte,
                ),
                const Divider(color: Colors.white10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_forever_outlined,
                      color: Colors.red),
                  title: const Text('Supprimer le compte',
                      style: TextStyle(color: Colors.red)),
                  subtitle: const Text(
                      'Suppression definitive et irreversible',
                      style: TextStyle(
                          color: Colors.white38, fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white24, size: 14),
                  onTap: _showSupprimerCompte,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── Déconnexion ─────────────────────────────────
          OutlinedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text('Se deconnecter',
                style: TextStyle(color: Colors.redAccent)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // WIDGETS FIDÉLITÉ
  // ═══════════════════════════════════════════════════════

  Widget _buildFideliteCard(int points, String niveau, Color niveauColor) {
    final pointsNiveauActuel = _getPointsNiveauActuel(points);
    final pointsProchainNiveau = _getPointsProchainNiveau(points);
    final isMax = niveau == 'or';
    final progress = isMax
        ? 1.0
        : (points - pointsNiveauActuel) /
        (pointsProchainNiveau - pointsNiveauActuel).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [niveauColor.withOpacity(0.2), AppColors.cardBg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: niveauColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // en-tête
          Row(
            children: [
              Icon(_getNiveauIcon(niveau), color: niveauColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Niveau ${niveau.toUpperCase()}',
                        style: TextStyle(
                            color: niveauColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    const Text('Programme de fidélité CinéEvent',
                        style: TextStyle(
                            color: AppColors.textLight, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: niveauColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('$points pts',
                    style: TextStyle(
                        color: niveauColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // barre de progression ou message max
          if (!isMax) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${points - pointsNiveauActuel} / ${pointsProchainNiveau - pointsNiveauActuel} pts',
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 11)),
                Text(
                    'Vers ${_getProchainNiveauLabel(points).toUpperCase()}',
                    style: TextStyle(
                        color: _getNiveauColor(
                            _getProchainNiveauLabel(points)),
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(niveauColor),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
                'Encore ${pointsProchainNiveau - points} pts pour atteindre ${_getProchainNiveauLabel(points).toUpperCase()}',
                style: const TextStyle(
                    color: AppColors.textLight, fontSize: 11)),
          ] else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: niveauColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: niveauColor, size: 16),
                  const SizedBox(width: 8),
                  Text('Niveau maximum atteint ! Félicitations !',
                      style: TextStyle(
                          color: niveauColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // avantages
          const Text('VOS AVANTAGES',
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 10,
                  letterSpacing: 1.5)),
          const SizedBox(height: 8),
          ..._getAvantages(niveau).map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle,
                    color: niveauColor, size: 14),
                const SizedBox(width: 8),
                Text(a,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12)),
              ],
            ),
          )),

          const SizedBox(height: 16),

          // badges niveaux
          Row(
            children: [
              _niveauBadge('Bronze', const Color(0xFFCD7F32), points >= 0),
              const SizedBox(width: 8),
              _niveauBadge(
                  'Argent', const Color(0xFFC0C0C0), points >= 200),
              const SizedBox(width: 8),
              _niveauBadge('Or', const Color(0xFFFFD700), points >= 500),
            ],
          ),
        ],
      ),
    );
  }

  Widget _niveauBadge(String label, Color color, bool atteint) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: atteint ? color.withOpacity(0.2) : AppColors.divider,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: atteint ? color : Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(atteint ? Icons.lock_open : Icons.lock,
                color: atteint ? color : Colors.white24, size: 16),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: atteint ? color : Colors.white24,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
            Text(
                label == 'Bronze'
                    ? '0 pts'
                    : label == 'Argent'
                    ? '200 pts'
                    : '500 pts',
                style: TextStyle(
                    color: atteint
                        ? color.withOpacity(0.7)
                        : Colors.white24,
                    fontSize: 9)),
          ],
        ),
      ),
    );
  }

  void _showFideliteInfo(BuildContext context, int points, String niveau,
      Color niveauColor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(_getNiveauIcon(niveau), color: niveauColor),
            const SizedBox(width: 8),
            Text('Programme Fidélité',
                style: TextStyle(
                    color: niveauColor, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Comment gagner des points :',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(height: 8),
            _regleItem('1 point par 10 MAD dépensés'),
            _regleItem('Points automatiques après chaque paiement'),
            const SizedBox(height: 16),
            const Text('Niveaux :',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(height: 8),
            _regleItem('Bronze : 0 - 199 points'),
            _regleItem('Argent : 200 - 499 points'),
            _regleItem('Or : 500+ points'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  Widget _regleItem(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        const Icon(Icons.arrow_right,
            color: AppColors.accent, size: 16),
        const SizedBox(width: 4),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: AppColors.textLight, fontSize: 12))),
      ],
    ),
  );

  // ═══════════════════════════════════════════════════════
  // WIDGETS INFOS / FORMULAIRE — inchangés
  // ═══════════════════════════════════════════════════════

  Widget _buildInfos(user, ProfilState profilState) {
    final dateStr = user?.dateNaissance != null
        ? '${user!.dateNaissance!.day.toString().padLeft(2, '0')}/'
        '${user.dateNaissance!.month.toString().padLeft(2, '0')}/'
        '${user.dateNaissance!.year}'
        : 'Non renseignee';
    final telStr =
    (user?.telephone != null && user!.telephone!.isNotEmpty)
        ? user.telephone!
        : 'Non renseigne';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mes informations',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.accent),
              onPressed: () => _startEditing(profilState),
            ),
          ],
        ),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        _infoRow(Icons.person_outline, 'Nom', user?.nom ?? '-'),
        _infoRow(Icons.email_outlined, 'Email', user?.email ?? '-'),
        _infoRow(Icons.phone_outlined, 'Telephone', telStr),
        _infoRow(Icons.cake_outlined, 'Date de naissance', dateStr),
        _infoRow(Icons.shield_outlined, 'Statut', user?.statut ?? '-'),
        _infoRow(Icons.badge_outlined, 'Role', user?.role ?? '-'),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 12)),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(ProfilState profilState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Modifier le profil',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textLight),
                onPressed: () => setState(() => _editing = false),
              ),
            ],
          ),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nomController,
            style: const TextStyle(color: AppColors.white),
            decoration: const InputDecoration(
              labelText: 'Nom complet',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) =>
            v == null || v.isEmpty ? 'Nom requis' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _telephoneController,
            style: const TextStyle(color: AppColors.white),
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() => _telephoneChanged = true),
            decoration: InputDecoration(
              labelText: 'Telephone',
              prefixIcon: const Icon(Icons.phone_outlined),
              suffixIcon: _telephoneChanged
                  ? const Icon(Icons.edit_note,
                  color: AppColors.accent, size: 20)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _dateNaissance ?? DateTime(2000),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.accent,
                      surface: AppColors.cardBg,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (date != null) {
                setState(() {
                  _dateNaissance = date;
                  _dateChanged = true;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _dateChanged
                      ? AppColors.accent
                      : AppColors.divider,
                  width: _dateChanged ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.cake_outlined,
                      color: _dateChanged
                          ? AppColors.accent
                          : AppColors.textLight),
                  const SizedBox(width: 12),
                  Text(
                    _dateNaissance != null
                        ? '${_dateNaissance!.day.toString().padLeft(2, '0')}/'
                        '${_dateNaissance!.month.toString().padLeft(2, '0')}/'
                        '${_dateNaissance!.year}'
                        : 'Date de naissance',
                    style: TextStyle(
                      color: _dateNaissance != null
                          ? AppColors.white
                          : AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: profilState.isSaving
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  ref.read(profilProvider.notifier).updateProfil(
                    nom: _nomController.text.trim(),
                    telephone: _telephoneController.text
                        .trim()
                        .isEmpty
                        ? null
                        : _telephoneController.text.trim(),
                    dateNaissance: _dateNaissance,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: profilState.isSaving
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: AppColors.white, strokeWidth: 2),
              )
                  : const Text('Sauvegarder',
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}