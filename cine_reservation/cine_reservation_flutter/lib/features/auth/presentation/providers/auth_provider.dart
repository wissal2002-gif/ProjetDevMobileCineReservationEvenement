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

  // ─── Écoute les changements du controller ───
  void _onControllerChanged() {
    print('=== controller changed: screen=${_controller.currentScreen}, state=${_controller.state}');
    // Erreur
    if (_controller.state == EmailAuthState.error) {
      state = state.copyWith(
        isLoading: false,
        error: _controller.errorMessage ?? 'Une erreur est survenue',
      );
      return;
    }

    // Chargement
    if (_controller.state == EmailAuthState.loading) {
      state = state.copyWith(isLoading: true, error: null);
      return;
    }

    // Authentifié
    if (_controller.state == EmailAuthState.authenticated) {
      state = state.copyWith(isLoading: false, isAuthenticated: true);
      return;
    }

    // Changement d'écran
    switch (_controller.currentScreen) {
      case EmailFlowScreen.verifyRegistration:
        state = state.copyWith(
          isLoading: false,
          needsVerification: true,
          error: null,
        );
        break;
      case EmailFlowScreen.completeRegistration:
        print('=== completeRegistration screen detected!');
        state = state.copyWith(
          isLoading: false,
          needsVerification: false,
          needsPassword: true,
          error: null,
        );
        break;
        break;
      case EmailFlowScreen.verifyPasswordReset:
        state = state.copyWith(
          isLoading: false,
          resetNeedsVerification: true,
          error: null,
        );
        break;
      case EmailFlowScreen.completePasswordReset:
        state = state.copyWith(
          isLoading: false,
          resetNeedsVerification: false,
          resetNeedsPassword: true,
          error: null,
        );
        break;
      default:
        break;
    }
  }

  // ─── Connexion ───
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _controller.emailController.text = email;
    _controller.passwordController.text = password;
    await _controller.login();
  }

  // ─── Inscription étape 1 : envoyer email ───
  Future<void> register({
    required String nom,
    required String email,
    required String telephone,
    required String password,
  }) async {
    _controller.emailController.text = email;
    await _controller.startRegistration();
  }

  // ─── Inscription étape 2 : vérifier code ───
  Future<void> verifyCode({required String code}) async {
    print('=== verifyCode appelé avec code: $code');
    print('=== controller screen: ${_controller.currentScreen}');
    _controller.verificationCodeController.text = code;
    await _controller.verifyRegistrationCode();
  }

  // ─── Inscription étape 3 : définir mot de passe ───
  Future<void> finishRegistration({required String password}) async {
    _controller.passwordController.text = password;
    await _controller.finishRegistration();
  }

  // ─── Reset MDP étape 1 : envoyer email ───
  Future<void> forgotPassword({required String email}) async {
    _controller.emailController.text = email;
    await _controller.startPasswordReset();
  }

  // ─── Reset MDP étape 2 : vérifier code ───
  Future<void> verifyResetCode({required String code}) async {
    _controller.verificationCodeController.text = code;
    await _controller.verifyPasswordResetCode();
  }

  // ─── Reset MDP étape 3 : nouveau mot de passe ───
  Future<void> finishPasswordReset({required String newPassword}) async {
    _controller.passwordController.text = newPassword;
    await _controller.finishPasswordReset();
  }

  // ─── Renvoyer code ───
  Future<void> resendCode() async {
    await _controller.resendVerificationCode();
  }

  // ─── Déconnexion ───
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

// ─── Provider ───
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final notifier = AuthNotifier();
  ref.keepAlive();
  return notifier;
});