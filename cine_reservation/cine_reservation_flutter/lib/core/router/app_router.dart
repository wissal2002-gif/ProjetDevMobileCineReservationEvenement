import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

// Core
import '../constants/app_constants.dart';
import 'navigation_state_provider.dart';

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

// Réservation
import '../../features/reservation/presentation/pages/seat_selection_page.dart';
import '../../features/reservation/presentation/pages/panier_page.dart';
import '../../features/reservation/presentation/pages/paiement_page.dart';
import '../../features/reservation/presentation/pages/confirmation_page.dart';
import '../../features/reservation/presentation/pages/mes_reservations_page.dart';

// Billets
import '../../features/billets/presentation/pages/billets_page.dart';
import '../../features/billets/presentation/pages/billet_detail_page.dart';

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

// Admin Tanger
import '../../features/admin_tanger/presentation/pages/manage_films_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_options_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_reservations_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_seances_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_staff_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_seats_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/tanger_dashboard_page.dart';
import '../../features/admin_tanger/presentation/pages/manage_promos_tanger_page.dart';
import '../../features/admin_tanger/presentation/pages/revenues_tanger_page.dart';

// Admin Événements
import '../../features/admin_events/presentation/pages/events_dashboard_page.dart';
import '../../features/admin_events/presentation/pages/manage_events_events_page.dart';
import '../../features/admin_events/presentation/pages/manage_reservations_events_page.dart';
import '../../features/admin_events/presentation/pages/revenues_events_page.dart';
import '../../features/profil/presentation/pages/favoris_page.dart';
// ...
// Admin Casablanca
import '../../features/admin_casa/presentation/pages/casa_dashboard_page.dart';
import '../../features/admin_casa/presentation/pages/manage_films_casa_page.dart';
import '../../features/admin_casa/presentation/pages/manage_seances_casa_page.dart';
import '../../features/admin_casa/presentation/pages/manage_reservations_casa_page.dart';
import '../../features/admin_casa/presentation/pages/revenues_casa_page.dart';
import '../../features/admin_casa/presentation/pages/manage_seats_casa_page.dart';
import '../../features/admin_casa/presentation/pages/manage_options_casa_page.dart';
import '../../features/admin_casa/presentation/pages/manage_promos_casa_page.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      // ─── HOME ─────────────────────────────────────────
      GoRoute(path: '/home', builder: (context, state) => const MainNavigationPage()),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),

      // ─── AUTH ─────────────────────────────────────────
      GoRoute(path: AppConstants.routeLogin, builder: (context, state) => const LoginPage()),
      GoRoute(path: AppConstants.routeRegister, builder: (context, state) => const RegisterPage()),
      GoRoute(path: AppConstants.routeForgotPassword, builder: (context, state) => const ForgotPasswordPage()),
      GoRoute(
        path: AppConstants.routeVerifyCode,
        builder: (context, state) => VerifyCodePage(email: state.extra as String),
      ),

      // ─── FILMS ────────────────────────────────────────
      GoRoute(
        path: '/film-detail',
        builder: (context, state) => FilmDetailPage(filmId: state.extra as int),
      ),
      GoRoute(path: '/all-films', builder: (context, state) => const FilmsListPage()),

      // ─── ÉVÉNEMENTS ───────────────────────────────────
      GoRoute(
        path: '/event-detail',
        builder: (context, state) => EvenementDetailPage(evenementId: state.extra as int),
      ),
      GoRoute(path: '/all-events', builder: (context, state) => const EvenementsPage()),

      // ─── SUPPORT & FAQ ────────────────────────────────
      GoRoute(path: '/support', builder: (context, state) => const ContactSupportPage()),
      GoRoute(path: '/faq', builder: (context, state) => const FaqPage()),

      // ─── RÉSERVATION ──────────────────────────────────
      GoRoute(
        path: '/seat-selection',
        builder: (context, state) {
          final nav = ref.read(navigationProvider);
          return SeatSelectionPage(
            seance: nav.seance,
            evenement: nav.evenement,
            salleId: nav.salleId,
            filmTitre: nav.filmTitre,
          );
        },
      ),
      GoRoute(
        path: '/panier',
        builder: (context, state) {
          final nav = ref.read(navigationProvider);
          return PanierPage(
            seance: nav.seance,
            evenement: nav.evenement,
            filmTitre: nav.filmTitre,
          );
        },
      ),
      GoRoute(
        path: '/paiement',
        builder: (context, state) {
          final nav = ref.read(navigationProvider);
          return PaiementPage(
            seance: nav.seance,
            evenement: nav.evenement,
            filmTitre: nav.filmTitre,
          );
        },
      ),
      GoRoute(
        path: '/confirmation',
        builder: (context, state) {
          final nav = ref.read(navigationProvider);
          final extra = state.extra as Map<String, dynamic>;
          return ConfirmationPage(
            reservation: extra['reservation'] as Reservation,
            paiement: extra['paiement'] as Paiement,
            billets: (extra['billets'] as List).cast<Billet>(),
            filmTitre: nav.filmTitre,
            seance: nav.seance,
            evenement: nav.evenement,
          );
        },
      ),
      GoRoute(path: '/mes-reservations', builder: (context, state) => MesReservationsPage()),

      // ─── BILLETS ──────────────────────────────────────
      GoRoute(path: '/mes-billets', builder: (context, state) => const BilletsPage()),
      GoRoute(
        path: '/billet-detail',
        builder: (context, state) => BilletDetailPage(billet: state.extra as Billet),
      ),
      GoRoute(path: '/favoris', builder: (context, state) => const FavorisPage()),

      // ─── ADMIN GLOBAL ─────────────────────────────────
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
      GoRoute(path: '/admin/promos', builder: (context, state) => const ManagePromosPage()),
      GoRoute(path: '/admin/faq', builder: (context, state) => const ManageFaqPage()),
      GoRoute(path: '/admin/reports', builder: (context, state) => const ReportsPage()),
      GoRoute(path: '/admin/revenues', builder: (context, state) => const GlobalRevenuesPage()),

      // ─── ADMIN TANGER ─────────────────────────────────
      GoRoute(path: '/admin/tanger', builder: (context, state) => const TangerDashboardPage()),
      GoRoute(path: '/admin/tanger/films', builder: (context, state) => const ManageFilmsTangerPage()),
      GoRoute(path: '/admin/tanger/seances', builder: (context, state) => const ManageSeancesTangerPage()),
      GoRoute(path: '/admin/tanger/promos', builder: (context, state) => const ManagePromosTangerPage()),
      GoRoute(path: '/admin/tanger/reservations', builder: (context, state) => const ManageReservationsTangerPage()),
      GoRoute(path: '/admin/tanger/staff', builder: (context, state) => const ManageStaffTangerPage()),
      GoRoute(path: '/admin/tanger/salles', builder: (context, state) => const ManageCinemasPage(cinemaId: 9)),
      GoRoute(path: '/admin/tanger/sieges', builder: (context, state) => const ManageSeatsTangerPage()),
      GoRoute(path: '/admin/tanger/revenus', builder: (_, __) => const RevenuesTangerPage()),


      // ─── ADMIN CASABLANCA ─────────────────────────────
      GoRoute(path: '/admin/casa', builder: (context, state) => const CasaDashboardPage()),
      GoRoute(path: '/admin/casa/films', builder: (context, state) => const ManageFilmsCasaPage()),
      GoRoute(path: '/admin/casa/seances', builder: (context, state) => const ManageSeancesCasaPage()),
      GoRoute(path: '/admin/casa/reservations', builder: (context, state) => const ManageReservationsCasaPage()),
      GoRoute(path: '/admin/casa/revenus', builder: (context, state) => const RevenuesCasaPage()),
      GoRoute(path: '/admin/casa/salles', builder: (context, state) => const ManageCinemasPage(cinemaId: 2)),
      GoRoute(path: '/admin/casa/sieges', builder: (context, state) => const ManageSeatsCasaPage()),
      GoRoute(path: '/admin/casa/options', builder: (context, state) => const ManageOptionsCasaPage()),
      GoRoute(path: '/admin/casa/promos', builder: (context, state) => const ManagePromosCasaPage()),

      // ─── ADMIN ÉVÉNEMENTS ─────────────────────────────
      GoRoute(path: '/admin/events', builder: (context, state) => const EventsDashboardPage()),
      GoRoute(path: '/admin/events/manage', builder: (context, state) => const ManageEventsEventsPage()),
      GoRoute(path: '/admin/events/add', builder: (context, state) => const AddEventFormPage()),
      GoRoute(path: '/admin/events/reservations', builder: (context, state) => const ManageReservationsEventsPage()),
      GoRoute(path: '/admin/events/revenus', builder: (context, state) => const RevenuesEventsPage()),
      GoRoute(path: '/admin/events/edit', builder: (context, state) => AddEventFormPage(event: state.extra as Evenement?)),
    ],
  );
});
