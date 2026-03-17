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

// Admin Global
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
import '../../features/admin/presentation/pages/manage_promos_page.dart';
import '../../features/admin/presentation/pages/manage_faq_page.dart';
import '../../features/admin/presentation/pages/reports_page.dart';
import '../../features/admin/presentation/pages/global_revenues_page.dart';

// ✅ PAGES SPÉCIFIQUES POUR TANGER
import '../../features/admin_tanger/presentation/pages/manage_films_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_options_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_reservations_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_seances_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_staff_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_seats_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/tanger_dashboard_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_promos_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/revenues_tanger_page.dart';

// ✅ PAGES SPÉCIFIQUES POUR RESP. ÉVÉNEMENTS
import '../../features/admin_events/presentation/pages/events_dashboard_page.dart';
import '../../features/admin_events/presentation/pages/manage_events_events_page.dart';
import '../../features/admin_events/presentation/pages/manage_reservations_events_page.dart';
import '../../features/admin_events/presentation/pages/revenues_events_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
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

      // ─── ADMIN GLOBAL ───
      GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardPage()),

      // ─── ADMIN TANGER (ID 9) ───
      GoRoute(path: '/admin/tanger', builder: (context, state) => const TangerDashboardPage()),
      GoRoute(path: '/admin/tanger/films', builder: (context, state) => const ManageFilmsTangerPage()),
      GoRoute(path: '/admin/tanger/seances', builder: (context, state) => const ManageSeancesTangerPage()),
      GoRoute(path: '/admin/tanger/promos', builder: (context, state) => const ManagePromosTangerPage()),
      GoRoute(path: '/admin/tanger/reservations', builder: (context, state) => const ManageReservationsTangerPage()),
      GoRoute(path: '/admin/tanger/staff', builder: (context, state) => const ManageStaffTangerPage()),
      GoRoute(path: '/admin/tanger/salles', builder: (context, state) => const ManageCinemasPage(cinemaId: 9)),
      GoRoute(path: '/admin/tanger/sieges', builder: (context, state) => const ManageSeatsTangerPage()),
      GoRoute(path: '/admin/tanger/revenus', builder: (_, __) => const RevenuesTangerPage()),

      // ─── ADMIN ÉVÉNEMENTS ───
      GoRoute(path: '/admin/events', builder: (context, state) => const EventsDashboardPage()),
      GoRoute(path: '/admin/events/manage', builder: (context, state) => const ManageEventsEventsPage()),
      GoRoute(path: '/admin/events/add', builder: (context, state) => const AddEventFormPage()),
      GoRoute(path: '/admin/events/reservations', builder: (context, state) => const ManageReservationsEventsPage()),
      GoRoute(path: '/admin/events/revenus', builder: (context, state) => const RevenuesEventsPage()),
      GoRoute(path: '/admin/events/edit', builder: (context, state) => AddEventFormPage(event: state.extra as Evenement?)),

      // ─── ROUTES ADMIN STANDARDS (SUPER ADMIN) ───
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
      GoRoute(path: '/admin/promos', builder: (context, state) => const ManagePromosPage()),
      GoRoute(path: '/admin/faq', builder: (context, state) => const ManageFaqPage()),
      GoRoute(path: '/admin/reports', builder: (context, state) => const ReportsPage()),
      GoRoute(path: '/admin/revenues', builder: (context, state) => const GlobalRevenuesPage()),
    ],
  );
});
