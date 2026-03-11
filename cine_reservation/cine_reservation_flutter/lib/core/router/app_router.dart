import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

// Core
import '../constants/app_constants.dart';

// Home
import '../../features/home/presentation/pages/main_navigation_page.dart';
import '../../features/home/presentation/pages/search_page.dart';

// Auth
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/verify_code_page.dart';

// Films
import '../../features/programmation/presentation/pages/film_detail_page.dart';
import '../../features/programmation/presentation/pages/films_list_page.dart';

// Evenements
import '../../features/evenements/presentation/pages/evenement_detail_page.dart';
import '../../features/evenements/presentation/pages/evenements_page.dart';

// Support & FAQ
import '../../features/support/presentation/pages/contact_support_page.dart';
import '../../features/faq/presentation/pages/faq_page.dart';

// Admin
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/manage_films_page.dart';
import '../../features/admin/presentation/pages/manage_events_page.dart';
import '../../features/admin/presentation/pages/add_event_form_page.dart';
import '../../features/admin/presentation/pages/manage_options_page.dart';
import '../../features/admin/presentation/pages/manage_seats_page.dart';
import '../../features/admin/presentation/pages/manage_cinemas_page.dart';
import '../../features/admin/presentation/pages/manage_seances_page.dart';
import '../../features/admin/presentation/pages/manage_users_page.dart';
import '../../features/admin/presentation/pages/manage_support_page.dart';
import '../../features/admin/presentation/pages/manage_reservations_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (context, state) => const MainNavigationPage()),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
      GoRoute(path: AppConstants.routeLogin, builder: (context, state) => const LoginPage()),
      GoRoute(path: AppConstants.routeRegister, builder: (context, state) => const RegisterPage()),
      GoRoute(path: AppConstants.routeForgotPassword, builder: (context, state) => const ForgotPasswordPage()),
      GoRoute(path: AppConstants.routeVerifyCode, builder: (context, state) => VerifyCodePage(email: state.extra as String)),
      GoRoute(path: '/film-detail', builder: (context, state) => FilmDetailPage(filmId: state.extra as int)),
      GoRoute(path: '/all-films', builder: (context, state) => const FilmsListPage()),
      GoRoute(path: '/event-detail', builder: (context, state) => EvenementDetailPage(evenementId: state.extra as int)),
      GoRoute(path: '/all-events', builder: (context, state) => const EvenementsPage()),
      GoRoute(path: '/support', builder: (context, state) => const ContactSupportPage()),
      GoRoute(path: '/faq', builder: (context, state) => const FaqPage()),

      // ADMIN ROUTES
      GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardPage()),
      GoRoute(path: '/admin/films', builder: (context, state) => const ManageFilmsPage()),
      GoRoute(path: '/admin/evenements', builder: (context, state) => const ManageEventsPage()),
      GoRoute(path: '/admin/evenements/form', builder: (context, state) => AddEventFormPage(event: state.extra as Evenement?)),
      GoRoute(path: '/admin/options', builder: (context, state) => const ManageOptionsPage()),
      GoRoute(path: '/admin/sieges', builder: (context, state) => const ManageSeatsPage()),
      GoRoute(path: '/admin/cinemas', builder: (context, state) => const ManageCinemasPage()),
      GoRoute(path: '/admin/seances', builder: (context, state) => const ManageSeancesPage()),
      GoRoute(path: '/admin/users', builder: (context, state) => const ManageUsersPage()),
      GoRoute(path: '/admin/support', builder: (context, state) => const ManageSupportPage()),
      GoRoute(path: '/admin/reservations', builder: (context, state) => const ManageReservationsPage()),
    ],
  );
});
