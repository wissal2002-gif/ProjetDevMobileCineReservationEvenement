import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../auth/presentation/providers/auth_provider.dart';
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
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    // Charger le profil au démarrage
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

  void _startEditing(ProfilState profilState) {
    _nomController.text = profilState.utilisateur?.nom ?? '';
    _telephoneController.text = profilState.utilisateur?.telephone ?? '';
    setState(() => _editing = true);
  }

  @override
  Widget build(BuildContext context) {
    final profilState = ref.watch(profilProvider);

    if (profilState.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    final user = profilState.utilisateur;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Avatar simple (Sans file_picker)
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondary,
              child: Text(
                user?.nom.isNotEmpty == true ? user!.nom[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 36, color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: Text(
              user?.nom ?? 'Utilisateur',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white),
            ),
          ),
          Center(
            child: Text(
              user?.email ?? '',
              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
          ),

          const SizedBox(height: 32),

          // Informations / Formulaire
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

          // Déconnexion
          OutlinedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text('Se déconnecter', style: TextStyle(color: Colors.redAccent)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfos(user, ProfilState profilState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mes informations', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.accent),
              onPressed: () => _startEditing(profilState),
            ),
          ],
        ),
        const Divider(color: AppColors.divider),
        _infoRow(Icons.person_outline, 'Nom', user?.nom ?? '-'),
        _infoRow(Icons.email_outlined, 'Email', user?.email ?? '-'),
        _infoRow(Icons.phone_outlined, 'Téléphone', user?.telephone ?? 'Non renseigné'),
        _infoRow(Icons.star, 'Points Fidélité', "${user?.pointsFidelite ?? 0} pts"),
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
                Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                Text(value, style: const TextStyle(color: AppColors.white, fontSize: 14)),
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
        children: [
          TextFormField(
            controller: _nomController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Nom complet'),
            validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _telephoneController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Téléphone'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.read(profilProvider.notifier).updateProfil(
                  nom: _nomController.text.trim(),
                  telephone: _telephoneController.text.trim(),
                );
                setState(() => _editing = false);
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }
}
