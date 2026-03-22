class AppConstants {
  // API
  static const String serverUrl = 'http://localhost:8080';

  // App
  static const String appName = 'CineReservation';
  static const String appVersion = '1.0.0';

  // Routes
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeVerifyCode = '/verify-code';
  static const String routeHome = '/home';
  static const String routeProfil = '/profil';
  static const String routeEditProfil = '/edit-profil';
  static const String routeHistorique = '/historique';
  static const String routeFavoris = '/favoris';
  static const String routeFilms = '/films';
  static const String routeFilmDetail = '/film/:id';
  static const String routeEvenements = '/evenements';
  static const String routeReservation = '/reservation';
  static const String routePaiement = '/paiement';
  static const String routeBillets = '/billets';

  // Storage keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
}