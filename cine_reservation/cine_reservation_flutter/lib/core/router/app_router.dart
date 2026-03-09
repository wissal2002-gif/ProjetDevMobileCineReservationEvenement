import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/verify_code_page.dart';
import '../../features/home/presentation/pages/main_navigation_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/programmation/presentation/pages/film_detail_page.dart';
import '../../features/programmation/presentation/pages/films_list_page.dart';
import '../../features/evenements/presentation/pages/evenement_detail_page.dart';
import '../../features/evenements/presentation/pages/evenements_page.dart';
import '../constants/app_constants.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home', // ← on commence par home
    routes: [
      // ─── HOME ───
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),

      // ─── AUTH ───
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppConstants.routeForgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppConstants.routeVerifyCode,
        builder: (context, state) => VerifyCodePage(
          email: state.extra as String,
        ),
      ),

      // ─── FILMS ───
      GoRoute(
        path: '/film-detail',
        builder: (context, state) {
          final filmId = state.extra as int;
          return FilmDetailPage(filmId: filmId);
        },
      ),
      GoRoute(
        path: '/all-films',
        builder: (context, state) => const FilmsListPage(),
      ),

      // ─── ÉVÉNEMENTS ───
      GoRoute(
        path: '/event-detail',
        builder: (context, state) {
          final eventId = state.extra as int;
          return EvenementDetailPage(evenementId: eventId);
        },
      ),
      GoRoute(
        path: '/all-events',
        builder: (context, state) => const EvenementsPage(),
      ),
    ],
  );
});