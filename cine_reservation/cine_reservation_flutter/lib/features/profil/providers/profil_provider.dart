import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../auth_provider.dart';

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
}

class ProfilNotifier extends StateNotifier<ProfilState> {
  ProfilNotifier() : super(const ProfilState());

  Future<void> loadProfil() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    try {
      final utilisateur = await client.profil.getProfil();
      state = state.copyWith(
        isLoading: false,
        utilisateur: utilisateur,
        error: null,
      );
    } catch (e) {
      // Pas d'erreur affichée, juste utilisateur null
      state = state.copyWith(
        isLoading: false,
        utilisateur: null,
        error: null,
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
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Erreur lors de la mise à jour.',
      );
    }
  }
}

final profilProvider = StateNotifierProvider<ProfilNotifier, ProfilState>((ref) {
  return ProfilNotifier();
});