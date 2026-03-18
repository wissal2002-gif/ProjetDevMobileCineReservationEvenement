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
        error: 'Erreur lors de la mise à jour.',
      );
    }
  }
}

// ─── Provider ───
final profilProvider = StateNotifierProvider<ProfilNotifier, ProfilState>((ref) {
  return ProfilNotifier();
});