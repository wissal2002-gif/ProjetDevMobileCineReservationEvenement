import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

// ─── State ───
class ProfilState {
  final bool isLoading;
  final bool isSaving;
  final Utilisateur? utilisateur;
  final String? error;
  final bool saveSuccess;

  const ProfilState({
    this.isLoading = false,
    this.isSaving = false,
    this.utilisateur,
    this.error,
    this.saveSuccess = false,
  });

  ProfilState copyWith({
    bool? isLoading,
    bool? isSaving,
    Utilisateur? utilisateur,
    String? error,
    bool? saveSuccess,
  }) {
    return ProfilState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      utilisateur: utilisateur ?? this.utilisateur,
      error: error,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }

  // Décoder la photo base64 stockée en BD
  Uint8List? get photoBytes {
    final photo = utilisateur?.photoProfil;
    if (photo == null || photo.isEmpty) return null;
    try {
      return base64Decode(photo);
    } catch (_) {
      return null;
    }
  }
}

// ─── Notifier ───
class ProfilNotifier extends StateNotifier<ProfilState> {
  ProfilNotifier() : super(const ProfilState());

  Future<void> loadProfil() async {
    state = state.copyWith(isLoading: true);
    try {
      final utilisateur = await client.profil.getProfil();
      state = state.copyWith(isLoading: false, utilisateur: utilisateur);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement du profil.',
      );
    }
  }

  Future<void> updateProfil({
    required String nom,
    String? telephone,
    DateTime? dateNaissance,
  }) async {
    state = state.copyWith(isSaving: true, saveSuccess: false);
    try {
      final updated = await client.profil.updateProfil(
        nom,
        telephone,
        dateNaissance,
      );
      state = state.copyWith(
        isSaving: false,
        utilisateur: updated,
        saveSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Erreur lors de la mise a jour.',
      );
    }
  }

  // ─── Sauvegarder photo en base64 en BD ───
  Future<void> updatePhoto(Uint8List imageBytes) async {
    state = state.copyWith(isSaving: true);
    try {
      final base64Image = base64Encode(imageBytes);
      final updated = await client.profil.updatePhotoProfil(base64Image);
      state = state.copyWith(
        isSaving: false,
        utilisateur: updated,
        saveSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Erreur lors de la sauvegarde de la photo.',
      );
    }
  }

  // ─── Désactiver le compte ───
  Future<bool> desactiverCompte() async {
    try {
      return await client.profil.desactiverCompte();
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de la desactivation.');
      return false;
    }
  }

  // ─── Supprimer le compte ───
  Future<bool> supprimerCompte() async {
    try {
      return await client.profil.supprimerCompte();
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de la suppression.');
      return false;
    }
  }
}

// ─── Provider ───
final profilProvider = StateNotifierProvider<ProfilNotifier, ProfilState>((ref) {
  return ProfilNotifier();
});