import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

import '../../features/admin_local/presentation/pages/local_dashboard_page.dart';
import '../../features/admin_local/presentation/pages/manage_films_page.dart';
import '../../features/admin_local/presentation/pages/manage_seances_page.dart';
import '../../features/admin_local/presentation/pages/manage_reservations_local_page.dart';
import '../../features/admin_local/presentation/pages/local_revenues_page.dart';
import '../../features/admin_local/presentation/pages/manage_salles_page.dart';

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
import '../../features/profil/presentation/pages/favoris_page.dart';

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

// Admin Événements
import '../../features/admin_events/presentation/pages/events_dashboard_page.dart';
import '../../features/admin_events/presentation/pages/manage_events_events_page.dart';
import '../../features/admin_events/presentation/pages/manage_reservations_events_page.dart';
import '../../features/admin_events/presentation/pages/revenues_events_page.dart';

// Admin Local
import '../../features/admin_local/presentation/pages/manage_options_page.dart' as local_options;
import '../../features/admin/presentation/providers/admin_provider.dart';
import '../../features/admin_local/presentation/pages/stats_likes_page.dart';
import '../../features/admin_local/presentation/pages/avis_clients_page.dart';
import '../../features/admin_local/presentation/pages/statistiques_detaillees_page.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
  // ✅ Rend le router réactif au chargement du profil
  final notifier = ValueNotifier<void>(null);
  ref.listen(adminProfileProvider, (_, __) {
    notifier.value = null;
  });

  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    refreshListenable: notifier, // ✅ Re-évalue le redirect quand profil charge

    redirect: (context, state) {
      final profile = ref.read(adminProfileProvider).valueOrNull;
      final location = state.matchedLocation;

      if (profile == null) return null;

      // ✅ Redirige tout admin_local vers /admin/local
      if (profile.role == 'admin_local') {
        if (location == '/admin' ||
            location == '/admin/tanger' ||
            location == '/admin/casa') {
          return '/admin/local';
        }
      }

      // ✅ Redirection après login
      if (location == AppConstants.routeLogin) {
        if (profile.role == 'super_admin')     return '/admin';
        if (profile.role == 'admin_local')     return '/admin/local';
        if (profile.role == 'resp_evenements') return '/admin/events';
      }

      return null;
    },

    routes: [
      // ─── HOME ─────────────────────────────────────────
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),

      // ─── AUTH ─────────────────────────────────────────
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
        builder: (context, state) => VerifyCodePage(email: state.extra as String),
      ),

      // ─── FILMS ────────────────────────────────────────
      GoRoute(
        path: '/film-detail',
        builder: (context, state) => FilmDetailPage(filmId: state.extra as int),
      ),
      GoRoute(
        path: '/all-films',
        builder: (context, state) => const FilmsListPage(),
      ),

      // ─── ÉVÉNEMENTS ───────────────────────────────────
      GoRoute(
        path: '/event-detail',
        builder: (context, state) => EvenementDetailPage(evenementId: state.extra as int),
      ),
      GoRoute(
        path: '/all-events',
        builder: (context, state) => const EvenementsPage(),
      ),

      // ─── SUPPORT & FAQ ────────────────────────────────
      GoRoute(
        path: '/support',
        builder: (context, state) => const ContactSupportPage(),
      ),
      GoRoute(
        path: '/faq',
        builder: (context, state) => const FaqPage(),
      ),

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
      GoRoute(
        path: '/mes-reservations',
        builder: (context, state) => MesReservationsPage(),
      ),

      // ─── BILLETS ──────────────────────────────────────
      GoRoute(
        path: '/mes-billets',
        builder: (context, state) => const BilletsPage(),
      ),
      GoRoute(
        path: '/billet-detail',
        builder: (context, state) => BilletDetailPage(billet: state.extra as Billet),
      ),
      GoRoute(
        path: '/favoris',
        builder: (context, state) => const FavorisPage(),
      ),

      // ─── ADMIN GLOBAL ─────────────────────────────────
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: '/admin/films',
        builder: (context, state) => const ManageFilmsPage(),
      ),
      GoRoute(
        path: '/admin/evenements',
        builder: (context, state) => const ManageEventsPage(),
      ),
      GoRoute(
        path: '/admin/evenements/form',
        builder: (context, state) => AddEventFormPage(event: state.extra as Evenement?),
      ),
      GoRoute(
        path: '/admin/options',
        builder: (context, state) => const ManageOptionsPage(),
      ),
      GoRoute(
        path: '/admin/sieges',
        builder: (context, state) => const ManageSeatsPage(),
      ),
      GoRoute(
        path: '/admin/cinemas',
        builder: (context, state) => const ManageCinemasPage(),
      ),
      GoRoute(
        path: '/admin/seances',
        builder: (context, state) => const ManageSeancesPage(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const ManageUsersPage(),
      ),
      GoRoute(
        path: '/admin/support',
        builder: (context, state) => const ManageSupportPage(),
      ),
      GoRoute(
        path: '/admin/reservations',
        builder: (context, state) => const ManageReservationsPage(),
      ),
      GoRoute(
        path: '/admin/promos',
        builder: (context, state) => const ManagePromosPage(),
      ),
      GoRoute(
        path: '/admin/faq',
        builder: (context, state) => const ManageFaqPage(),
      ),
      GoRoute(
        path: '/admin/reports',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: '/admin/revenues',
        builder: (context, state) => const GlobalRevenuesPage(),
      ),

      // ─── ADMIN ÉVÉNEMENTS ─────────────────────────────
      GoRoute(
        path: '/admin/events',
        builder: (context, state) => const EventsDashboardPage(),
      ),
      GoRoute(
        path: '/admin/events/manage',
        builder: (context, state) => const ManageEventsEventsPage(),
      ),
      GoRoute(
        path: '/admin/events/add',
        builder: (context, state) => const AddEventFormPage(),
      ),
      GoRoute(
        path: '/admin/events/reservations',
        builder: (context, state) => const ManageReservationsEventsPage(),
      ),
      GoRoute(
        path: '/admin/events/revenus',
        builder: (context, state) => const RevenuesEventsPage(),
      ),
      GoRoute(
        path: '/admin/events/edit',
        builder: (context, state) => AddEventFormPage(event: state.extra as Evenement?),
      ),

      // ─── ADMIN LOCAL ──────────────────────────────────
      GoRoute(
        path: '/admin/local',
        builder: (context, state) => const LocalDashboardPage(),
      ),
      GoRoute(
        path: '/admin/local/films',
        builder: (context, state) => const ManageFilmsLocalPage(),
      ),
      GoRoute(
        path: '/admin/local/seances',
        builder: (context, state) => const ManageSeancesLocalPage(),
      ),
      GoRoute(
        path: '/admin/local/options',
        builder: (context, state) => const local_options.ManageOptionsPage(),
      ),
      GoRoute(
        path: '/admin/local/reservations',
        builder: (context, state) => const ManageReservationsLocalPage(),
      ),
      GoRoute(
        path: '/admin/local/revenus',
        builder: (context, state) => const LocalRevenuesPage(),
      ),
      GoRoute(
        path: '/admin/local/salles',
        builder: (context, state) => const ManageSallesLocalPage(),
      ),
      GoRoute(
        path: '/admin/local/likes',
        builder: (context, state) => const StatsLikesPage(),
      ),
      GoRoute(
        path: '/admin/local/avis',
        builder: (context, state) => const AvisClientsPage(),
      ),
      GoRoute(
        path: '/admin/local/stats',
        builder: (context, state) => const StatistiquesDetailleesPage(),
      ),
    ],
  );
});