import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
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
import '../../features/support/presentation/pages/contact_support_page.dart';
import '../../features/reservation/presentation/pages/seat_selection_page.dart';
import '../../features/reservation/presentation/pages/panier_page.dart';
import '../../features/reservation/presentation/pages/paiement_page.dart';
import '../../features/reservation/presentation/pages/confirmation_page.dart';
import '../../features/reservation/presentation/pages/mes_reservations_page.dart';
import '../../features/billets/presentation/pages/billets_page.dart';
import '../../features/billets/presentation/pages/billet_detail_page.dart';
import '../constants/app_constants.dart';
import 'navigation_state_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // ─── HOME ───
      GoRoute(path: '/home', builder: (context, state) => const MainNavigationPage()),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),

      // ─── AUTH ───
      GoRoute(path: AppConstants.routeLogin, builder: (context, state) => const LoginPage()),
      GoRoute(path: AppConstants.routeRegister, builder: (context, state) => const RegisterPage()),
      GoRoute(path: AppConstants.routeForgotPassword, builder: (context, state) => const ForgotPasswordPage()),
      GoRoute(
        path: AppConstants.routeVerifyCode,
        builder: (context, state) => VerifyCodePage(email: state.extra as String),
      ),

      // ─── FILMS ───
      GoRoute(
        path: '/film-detail',
        builder: (context, state) => FilmDetailPage(filmId: state.extra as int),
      ),
      GoRoute(path: '/all-films', builder: (context, state) => const FilmsListPage()),

      // ─── EVENEMENTS ───
      GoRoute(
        path: '/event-detail',
        builder: (context, state) => EvenementDetailPage(evenementId: state.extra as int),
      ),
      GoRoute(path: '/all-events', builder: (context, state) => const EvenementsPage()),

      // ─── SUPPORT ───
      GoRoute(path: '/support', builder: (context, state) => const ContactSupportPage()),

      // ─── RESERVATION ───
      // On lit depuis navigationProvider car GoRouter sérialise extra en JSON sur Web
      // ce qui détruit les instances Dart.
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

      // ─── BILLETS ───
      GoRoute(path: '/mes-billets', builder: (context, state) => const BilletsPage()),
      GoRoute(
        path: '/billet-detail',
        builder: (context, state) => BilletDetailPage(billet: state.extra as Billet),
      ),
    ],
  );
});
