import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Uint8List? _imageBytes;

  // Suivi des champs modifiés
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

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.first.bytes != null) {
      setState(() => _imageBytes = result.files.first.bytes);
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

  @override
  Widget build(BuildContext context) {
    final profilState = ref.watch(profilProvider);

    ref.listen(profilProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
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
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Profil mis à jour avec succès !'),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    if (profilState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    final user = profilState.utilisateur;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Avatar
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.secondary,
                    backgroundImage: _imageBytes != null
                        ? MemoryImage(_imageBytes!)
                        : null,
                    child: _imageBytes == null
                        ? Text(
                      user?.nom.isNotEmpty == true
                          ? user!.nom[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 36,
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
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
            child: Text(
              user?.nom ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Center(
            child: Text(
              user?.email ?? '',
              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
          ),

          const SizedBox(height: 8),

          // Badge fidélité
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: AppColors.accent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${user?.pointsFidelite ?? 0} points fidélité',
                    style: const TextStyle(color: AppColors.accent, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Infos / Formulaire
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
            label: const Text('Se déconnecter',
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

  Widget _buildInfos(user, ProfilState profilState) {
    final dateStr = user?.dateNaissance != null
        ? '${user!.dateNaissance!.day.toString().padLeft(2, '0')}/'
        '${user.dateNaissance!.month.toString().padLeft(2, '0')}/'
        '${user.dateNaissance!.year}'
        : 'Non renseignée';

    final telStr = (user?.telephone != null && user!.telephone!.isNotEmpty)
        ? user.telephone!
        : 'Non renseigné';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mes informations',
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
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
        _infoRow(Icons.phone_outlined, 'Téléphone', telStr),
        _infoRow(Icons.cake_outlined, 'Date de naissance', dateStr),
        _infoRow(Icons.shield_outlined, 'Statut', user?.statut ?? '-'),
        _infoRow(Icons.badge_outlined, 'Rôle', user?.role ?? '-'),
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
                    style: const TextStyle(color: AppColors.white, fontSize: 14)),
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
              const Text(
                'Modifier le profil',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textLight),
                onPressed: () => setState(() => _editing = false),
              ),
            ],
          ),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),

          // Nom
          TextFormField(
            controller: _nomController,
            style: const TextStyle(color: AppColors.white),
            decoration: const InputDecoration(
              labelText: 'Nom complet',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Nom requis' : null,
          ),

          const SizedBox(height: 16),

          // Téléphone avec indicateur de modification
          TextFormField(
            controller: _telephoneController,
            style: const TextStyle(color: AppColors.white),
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() => _telephoneChanged = true),
            decoration: InputDecoration(
              labelText: 'Téléphone',
              prefixIcon: const Icon(Icons.phone_outlined),
              suffixIcon: _telephoneChanged
                  ? const Icon(Icons.edit_note, color: AppColors.accent, size: 20)
                  : null,
              helperText: _telephoneChanged
                  ? 'Modifié — pensez à sauvegarder'
                  : null,
              helperStyle:
              const TextStyle(color: AppColors.accent, fontSize: 11),
            ),
          ),

          const SizedBox(height: 16),

          // Date de naissance avec indicateur
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
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _dateChanged ? AppColors.accent : AppColors.divider,
                  width: _dateChanged ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cake_outlined,
                          color: _dateChanged
                              ? AppColors.accent
                              : AppColors.textLight),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
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
                      ),
                      if (_dateChanged)
                        const Icon(Icons.edit_note,
                            color: AppColors.accent, size: 20),
                    ],
                  ),
                  if (_dateChanged)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 32),
                      child: Text(
                        'Modifiée — pensez à sauvegarder',
                        style: TextStyle(
                          color: AppColors.accent.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bouton Sauvegarder
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: profilState.isSaving
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  ref.read(profilProvider.notifier).updateProfil(
                    nom: _nomController.text.trim(),
                    telephone:
                    _telephoneController.text.trim().isEmpty
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
                  : const Text('Sauvegarder', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}