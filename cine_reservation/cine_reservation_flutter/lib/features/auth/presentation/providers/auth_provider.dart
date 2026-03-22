import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../../main.dart';

// ─── State ───
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool needsVerification;
  final bool needsPassword;
  final bool resetNeedsVerification;
  final bool resetNeedsPassword;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.needsVerification = false,
    this.needsPassword = false,
    this.resetNeedsVerification = false,
    this.resetNeedsPassword = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? needsVerification,
    bool? needsPassword,
    bool? resetNeedsVerification,
    bool? resetNeedsPassword,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      needsVerification: needsVerification ?? this.needsVerification,
      needsPassword: needsPassword ?? this.needsPassword,
      resetNeedsVerification: resetNeedsVerification ?? this.resetNeedsVerification,
      resetNeedsPassword: resetNeedsPassword ?? this.resetNeedsPassword,
      error: error,
    );
  }
}

// ─── Notifier ───
class AuthNotifier extends StateNotifier<AuthState> {
  final EmailAuthController _controller;

  AuthNotifier()
      : _controller = EmailAuthController(client: client),
        super(const AuthState()) {
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (_controller.state == EmailAuthState.error) {
      state = state.copyWith(
        isLoading: false,
        error: _controller.errorMessage ?? 'Une erreur est survenue',
      );
      return;
    }

    if (_controller.state == EmailAuthState.loading) {
      state = state.copyWith(isLoading: true, error: null);
      return;
    }

    if (_controller.state == EmailAuthState.authenticated) {
      state = state.copyWith(isLoading: false, isAuthenticated: true);
      return;
    }

    switch (_controller.currentScreen) {
      case EmailFlowScreen.verifyRegistration:
        state = state.copyWith(isLoading: false, needsVerification: true, error: null);
        break;
      case EmailFlowScreen.completeRegistration:
        state = state.copyWith(isLoading: false, needsVerification: false, needsPassword: true, error: null);
        break;
      case EmailFlowScreen.verifyPasswordReset:
        state = state.copyWith(isLoading: false, resetNeedsVerification: true, error: null);
        break;
      case EmailFlowScreen.completePasswordReset:
        state = state.copyWith(isLoading: false, resetNeedsVerification: false, resetNeedsPassword: true, error: null);
        break;
      default:
        break;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      _controller.emailController.text = email;
      _controller.passwordController.text = password;
      await _controller.login();

      // --- VÉRIFICATION DE SUSPENSION ---
      if (_controller.state == EmailAuthState.authenticated) {
        try {
          final user = await client.profil.getProfil();
          if (user?.statut == 'suspendu') {
            await logout(); // Déconnexion immédiate
            state = state.copyWith(
              error: "Votre compte a été suspendu par un administrateur.",
              isAuthenticated: false,
            );
          }
        } catch (e) {
          // Si le serveur a lancé l'exception 'ACCOUNT_SUSPENDED' configurée dans profil_endpoint
          if (e.toString().contains('ACCOUNT_SUSPENDED')) {
            await logout();
            state = state.copyWith(
              error: "Accès refusé : votre compte est suspendu.",
              isAuthenticated: false,
            );
          }
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    _controller.emailController.text = email;
    await _controller.startRegistration();
  }

  Future<void> verifyCode({required String code}) async {
    _controller.verificationCodeController.text = code;
    await _controller.verifyRegistrationCode();
  }

  Future<void> finishRegistration({required String password}) async {
    _controller.passwordController.text = password;
    await _controller.finishRegistration();
  }

  Future<void> forgotPassword({required String email}) async {
    _controller.emailController.text = email;
    await _controller.startPasswordReset();
  }

  Future<void> verifyResetCode({required String code}) async {
    _controller.verificationCodeController.text = code;
    await _controller.verifyPasswordResetCode();
  }

  Future<void> finishPasswordReset({required String newPassword}) async {
    _controller.passwordController.text = newPassword;
    await _controller.finishPasswordReset();
  }

  Future<void> resendCode() async {
    await _controller.resendVerificationCode();
  }

  Future<void> logout() async {
    try {
      await client.auth.signOutDevice();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de la déconnexion.');
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
