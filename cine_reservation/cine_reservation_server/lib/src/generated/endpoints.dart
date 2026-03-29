/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/admin_endpoint.dart' as _i4;
import '../endpoints/avis_endpoint.dart' as _i5;
import '../endpoints/billet_endpoint.dart' as _i6;
import '../endpoints/cinemas_endpoint.dart' as _i7;
import '../endpoints/evenements_endpoint.dart' as _i8;
import '../endpoints/faq_endpoint.dart' as _i9;
import '../endpoints/favori_endpoint.dart' as _i10;
import '../endpoints/films_endpoint.dart' as _i11;
import '../endpoints/options_endpoint.dart' as _i12;
import '../endpoints/paiement_endpoint.dart' as _i13;
import '../endpoints/profil_endpoint.dart' as _i14;
import '../endpoints/reservation_endpoint.dart' as _i15;
import '../endpoints/salles_endpoint.dart' as _i16;
import '../endpoints/seances_endpoint.dart' as _i17;
import '../endpoints/sieges_endpoint.dart' as _i18;
import '../endpoints/support_endpoint.dart' as _i19;
import '../greetings/greeting_endpoint.dart' as _i20;
import 'package:cine_reservation_server/src/generated/cinema.dart' as _i21;
import 'package:cine_reservation_server/src/generated/salle.dart' as _i22;
import 'package:cine_reservation_server/src/generated/seance.dart' as _i23;
import 'package:cine_reservation_server/src/generated/film.dart' as _i24;
import 'package:cine_reservation_server/src/generated/evenement.dart' as _i25;
import 'package:cine_reservation_server/src/generated/faq.dart' as _i26;
import 'package:cine_reservation_server/src/generated/option%20supplementaire.dart'
    as _i27;
import 'package:cine_reservation_server/src/generated/code_promo.dart' as _i28;
import 'package:cine_reservation_server/src/generated/utilisateur.dart' as _i29;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i30;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i31;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'admin': _i4.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'avis': _i5.AvisEndpoint()
        ..initialize(
          server,
          'avis',
          null,
        ),
      'billet': _i6.BilletEndpoint()
        ..initialize(
          server,
          'billet',
          null,
        ),
      'cinemas': _i7.CinemasEndpoint()
        ..initialize(
          server,
          'cinemas',
          null,
        ),
      'evenements': _i8.EvenementsEndpoint()
        ..initialize(
          server,
          'evenements',
          null,
        ),
      'faq': _i9.FaqEndpoint()
        ..initialize(
          server,
          'faq',
          null,
        ),
      'favori': _i10.FavoriEndpoint()
        ..initialize(
          server,
          'favori',
          null,
        ),
      'films': _i11.FilmsEndpoint()
        ..initialize(
          server,
          'films',
          null,
        ),
      'options': _i12.OptionsEndpoint()
        ..initialize(
          server,
          'options',
          null,
        ),
      'paiement': _i13.PaiementEndpoint()
        ..initialize(
          server,
          'paiement',
          null,
        ),
      'profil': _i14.ProfilEndpoint()
        ..initialize(
          server,
          'profil',
          null,
        ),
      'reservation': _i15.ReservationEndpoint()
        ..initialize(
          server,
          'reservation',
          null,
        ),
      'salles': _i16.SallesEndpoint()
        ..initialize(
          server,
          'salles',
          null,
        ),
      'seances': _i17.SeancesEndpoint()
        ..initialize(
          server,
          'seances',
          null,
        ),
      'sieges': _i18.SiegesEndpoint()
        ..initialize(
          server,
          'sieges',
          null,
        ),
      'support': _i19.SupportEndpoint()
        ..initialize(
          server,
          'support',
          null,
        ),
      'greeting': _i20.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'getDashboardTitle': _i1.MethodConnector(
          name: 'getDashboardTitle',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getDashboardTitle(session),
        ),
        'getDashboardData': _i1.MethodConnector(
          name: 'getDashboardData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getDashboardData(session),
        ),
        'getDashboardActions': _i1.MethodConnector(
          name: 'getDashboardActions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getDashboardActions(session),
        ),
        'getAdminStats': _i1.MethodConnector(
          name: 'getAdminStats',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAdminStats(session),
        ),
        'getAllReservations': _i1.MethodConnector(
          name: 'getAllReservations',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllReservations(session),
        ),
        'rembourserReservation': _i1.MethodConnector(
          name: 'rembourserReservation',
          params: {
            'resId': _i1.ParameterDescription(
              name: 'resId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'amt': _i1.ParameterDescription(
              name: 'amt',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'raison': _i1.ParameterDescription(
              name: 'raison',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .rembourserReservation(
                    session,
                    params['resId'],
                    params['amt'],
                    params['raison'],
                  ),
        ),
        'getAllCinemas': _i1.MethodConnector(
          name: 'getAllCinemas',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllCinemas(session),
        ),
        'ajouterCinema': _i1.MethodConnector(
          name: 'ajouterCinema',
          params: {
            'c': _i1.ParameterDescription(
              name: 'c',
              type: _i1.getType<_i21.Cinema>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).ajouterCinema(
                    session,
                    params['c'],
                  ),
        ),
        'modifierCinema': _i1.MethodConnector(
          name: 'modifierCinema',
          params: {
            'c': _i1.ParameterDescription(
              name: 'c',
              type: _i1.getType<_i21.Cinema>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).modifierCinema(
                    session,
                    params['c'],
                  ),
        ),
        'supprimerCinema': _i1.MethodConnector(
          name: 'supprimerCinema',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerCinema(
                    session,
                    params['id'],
                  ),
        ),
        'getAllSalles': _i1.MethodConnector(
          name: 'getAllSalles',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).getAllSalles(
                session,
              ),
        ),
        'getSalles': _i1.MethodConnector(
          name: 'getSalles',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).getSalles(session),
        ),
        'getSallesByCinema': _i1.MethodConnector(
          name: 'getSallesByCinema',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).getSallesByCinema(
                    session,
                    params['cinemaId'],
                  ),
        ),
        'ajouterSalle': _i1.MethodConnector(
          name: 'ajouterSalle',
          params: {
            's': _i1.ParameterDescription(
              name: 's',
              type: _i1.getType<_i22.Salle>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).ajouterSalle(
                session,
                params['s'],
              ),
        ),
        'modifierSalle': _i1.MethodConnector(
          name: 'modifierSalle',
          params: {
            's': _i1.ParameterDescription(
              name: 's',
              type: _i1.getType<_i22.Salle>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).modifierSalle(
                    session,
                    params['s'],
                  ),
        ),
        'supprimerSalle': _i1.MethodConnector(
          name: 'supprimerSalle',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerSalle(
                    session,
                    params['id'],
                  ),
        ),
        'getSiegesBySalle': _i1.MethodConnector(
          name: 'getSiegesBySalle',
          params: {
            'salleId': _i1.ParameterDescription(
              name: 'salleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).getSiegesBySalle(
                    session,
                    params['salleId'],
                  ),
        ),
        'genererSiegesPourSalle': _i1.MethodConnector(
          name: 'genererSiegesPourSalle',
          params: {
            'salleId': _i1.ParameterDescription(
              name: 'salleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'rows': _i1.ParameterDescription(
              name: 'rows',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'cols': _i1.ParameterDescription(
              name: 'cols',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .genererSiegesPourSalle(
                    session,
                    params['salleId'],
                    params['rows'],
                    params['cols'],
                  ),
        ),
        'genererSiegesAutomatique': _i1.MethodConnector(
          name: 'genererSiegesAutomatique',
          params: {
            'salleId': _i1.ParameterDescription(
              name: 'salleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'nbRangees': _i1.ParameterDescription(
              name: 'nbRangees',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'nbColonnes': _i1.ParameterDescription(
              name: 'nbColonnes',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .genererSiegesAutomatique(
                    session,
                    salleId: params['salleId'],
                    nbRangees: params['nbRangees'],
                    nbColonnes: params['nbColonnes'],
                  ),
        ),
        'getAllSeances': _i1.MethodConnector(
          name: 'getAllSeances',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllSeances(session),
        ),
        'ajouterSeance': _i1.MethodConnector(
          name: 'ajouterSeance',
          params: {
            's': _i1.ParameterDescription(
              name: 's',
              type: _i1.getType<_i23.Seance>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).ajouterSeance(
                    session,
                    params['s'],
                  ),
        ),
        'modifierSeance': _i1.MethodConnector(
          name: 'modifierSeance',
          params: {
            's': _i1.ParameterDescription(
              name: 's',
              type: _i1.getType<_i23.Seance>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).modifierSeance(
                    session,
                    params['s'],
                  ),
        ),
        'supprimerSeance': _i1.MethodConnector(
          name: 'supprimerSeance',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerSeance(
                    session,
                    params['id'],
                  ),
        ),
        'getSeancesByFilm': _i1.MethodConnector(
          name: 'getSeancesByFilm',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).getSeancesByFilm(
                    session,
                    params['filmId'],
                  ),
        ),
        'getSeancesByCinema': _i1.MethodConnector(
          name: 'getSeancesByCinema',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).getSeancesByCinema(
                    session,
                    params['id'],
                  ),
        ),
        'getAllFilms': _i1.MethodConnector(
          name: 'getAllFilms',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).getAllFilms(
                session,
              ),
        ),
        'ajouterFilm': _i1.MethodConnector(
          name: 'ajouterFilm',
          params: {
            'f': _i1.ParameterDescription(
              name: 'f',
              type: _i1.getType<_i24.Film>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).ajouterFilm(
                session,
                params['f'],
              ),
        ),
        'modifierFilm': _i1.MethodConnector(
          name: 'modifierFilm',
          params: {
            'f': _i1.ParameterDescription(
              name: 'f',
              type: _i1.getType<_i24.Film>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).modifierFilm(
                session,
                params['f'],
              ),
        ),
        'supprimerFilm': _i1.MethodConnector(
          name: 'supprimerFilm',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerFilm(
                    session,
                    params['id'],
                  ),
        ),
        'getAllEvenements': _i1.MethodConnector(
          name: 'getAllEvenements',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllEvenements(session),
        ),
        'ajouterEvenement': _i1.MethodConnector(
          name: 'ajouterEvenement',
          params: {
            'ev': _i1.ParameterDescription(
              name: 'ev',
              type: _i1.getType<_i25.Evenement>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).ajouterEvenement(
                    session,
                    params['ev'],
                  ),
        ),
        'modifierEvenement': _i1.MethodConnector(
          name: 'modifierEvenement',
          params: {
            'ev': _i1.ParameterDescription(
              name: 'ev',
              type: _i1.getType<_i25.Evenement>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).modifierEvenement(
                    session,
                    params['ev'],
                  ),
        ),
        'supprimerEvenement': _i1.MethodConnector(
          name: 'supprimerEvenement',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerEvenement(
                    session,
                    params['id'],
                  ),
        ),
        'getAllUtilisateurs': _i1.MethodConnector(
          name: 'getAllUtilisateurs',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllUtilisateurs(session),
        ),
        'getManagedUsers': _i1.MethodConnector(
          name: 'getManagedUsers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getManagedUsers(session),
        ),
        'activerUtilisateur': _i1.MethodConnector(
          name: 'activerUtilisateur',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).activerUtilisateur(
                    session,
                    params['id'],
                  ),
        ),
        'suspendreUtilisateur': _i1.MethodConnector(
          name: 'suspendreUtilisateur',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .suspendreUtilisateur(
                    session,
                    params['id'],
                  ),
        ),
        'supprimerUtilisateur': _i1.MethodConnector(
          name: 'supprimerUtilisateur',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .supprimerUtilisateur(
                    session,
                    params['id'],
                  ),
        ),
        'getHistoriqueUtilisateur': _i1.MethodConnector(
          name: 'getHistoriqueUtilisateur',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getHistoriqueUtilisateur(
                    session,
                    params['userId'],
                  ),
        ),
        'modifierUtilisateurRole': _i1.MethodConnector(
          name: 'modifierUtilisateurRole',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newRole': _i1.ParameterDescription(
              name: 'newRole',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .modifierUtilisateurRole(
                    session,
                    params['userId'],
                    params['newRole'],
                  ),
        ),
        'traiterRemboursement': _i1.MethodConnector(
          name: 'traiterRemboursement',
          params: {
            'resId': _i1.ParameterDescription(
              name: 'resId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .traiterRemboursement(
                    session,
                    params['resId'],
                  ),
        ),
        'getSiegesByReservation': _i1.MethodConnector(
          name: 'getSiegesByReservation',
          params: {
            'resId': _i1.ParameterDescription(
              name: 'resId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getSiegesByReservation(
                    session,
                    params['resId'],
                  ),
        ),
        'getTauxRemplissageSeance': _i1.MethodConnector(
          name: 'getTauxRemplissageSeance',
          params: {
            'sId': _i1.ParameterDescription(
              name: 'sId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getTauxRemplissageSeance(
                    session,
                    params['sId'],
                  ),
        ),
        'getAllDemandesSupport': _i1.MethodConnector(
          name: 'getAllDemandesSupport',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllDemandesSupport(session),
        ),
        'repondreDemande': _i1.MethodConnector(
          name: 'repondreDemande',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'resp': _i1.ParameterDescription(
              name: 'resp',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).repondreDemande(
                    session,
                    params['id'],
                    params['resp'],
                  ),
        ),
        'getAdminFaqs': _i1.MethodConnector(
          name: 'getAdminFaqs',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).getAdminFaqs(
                session,
              ),
        ),
        'ajouterFaq': _i1.MethodConnector(
          name: 'ajouterFaq',
          params: {
            'f': _i1.ParameterDescription(
              name: 'f',
              type: _i1.getType<_i26.Faq>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).ajouterFaq(
                session,
                params['f'],
              ),
        ),
        'modifierFaq': _i1.MethodConnector(
          name: 'modifierFaq',
          params: {
            'f': _i1.ParameterDescription(
              name: 'f',
              type: _i1.getType<_i26.Faq>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).modifierFaq(
                session,
                params['f'],
              ),
        ),
        'supprimerFaq': _i1.MethodConnector(
          name: 'supprimerFaq',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).supprimerFaq(
                session,
                params['id'],
              ),
        ),
        'getAllOptions': _i1.MethodConnector(
          name: 'getAllOptions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllOptions(session),
        ),
        'ajouterOption': _i1.MethodConnector(
          name: 'ajouterOption',
          params: {
            'o': _i1.ParameterDescription(
              name: 'o',
              type: _i1.getType<_i27.OptionSupplementaire>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).ajouterOption(
                    session,
                    params['o'],
                  ),
        ),
        'modifierOption': _i1.MethodConnector(
          name: 'modifierOption',
          params: {
            'o': _i1.ParameterDescription(
              name: 'o',
              type: _i1.getType<_i27.OptionSupplementaire>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).modifierOption(
                    session,
                    params['o'],
                  ),
        ),
        'supprimerOption': _i1.MethodConnector(
          name: 'supprimerOption',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerOption(
                    session,
                    params['id'],
                  ),
        ),
        'getAllCodesPromo': _i1.MethodConnector(
          name: 'getAllCodesPromo',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllCodesPromo(session),
        ),
        'ajouterCodePromo': _i1.MethodConnector(
          name: 'ajouterCodePromo',
          params: {
            'c': _i1.ParameterDescription(
              name: 'c',
              type: _i1.getType<_i28.CodePromo>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).ajouterCodePromo(
                    session,
                    params['c'],
                  ),
        ),
        'modifierCodePromo': _i1.MethodConnector(
          name: 'modifierCodePromo',
          params: {
            'c': _i1.ParameterDescription(
              name: 'c',
              type: _i1.getType<_i28.CodePromo>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).modifierCodePromo(
                    session,
                    params['c'],
                  ),
        ),
        'supprimerCodePromo': _i1.MethodConnector(
          name: 'supprimerCodePromo',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerCodePromo(
                    session,
                    params['id'],
                  ),
        ),
        'getCodePromoStats': _i1.MethodConnector(
          name: 'getCodePromoStats',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).getCodePromoStats(
                    session,
                    params['id'],
                  ),
        ),
        'getGlobalPromoSummary': _i1.MethodConnector(
          name: 'getGlobalPromoSummary',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getGlobalPromoSummary(session),
        ),
        'getStaffTanger': _i1.MethodConnector(
          name: 'getStaffTanger',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getStaffTanger(session),
        ),
        'ajouterStaff': _i1.MethodConnector(
          name: 'ajouterStaff',
          params: {
            'nom': _i1.ParameterDescription(
              name: 'nom',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).ajouterStaff(
                session,
                params['nom'],
                params['email'],
              ),
        ),
        'getMonProfil': _i1.MethodConnector(
          name: 'getMonProfil',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).getMonProfil(
                session,
              ),
        ),
        'getReservationsDetailed': _i1.MethodConnector(
          name: 'getReservationsDetailed',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getReservationsDetailed(session),
        ),
        'getAllClients': _i1.MethodConnector(
          name: 'getAllClients',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAllClients(session),
        ),
        'modifierUtilisateur': _i1.MethodConnector(
          name: 'modifierUtilisateur',
          params: {
            'utilisateur': _i1.ParameterDescription(
              name: 'utilisateur',
              type: _i1.getType<_i29.Utilisateur>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).modifierUtilisateur(
                    session,
                    params['utilisateur'],
                  ),
        ),
        'updateSiegesType': _i1.MethodConnector(
          name: 'updateSiegesType',
          params: {
            'siegeIds': _i1.ParameterDescription(
              name: 'siegeIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).updateSiegesType(
                    session,
                    params['siegeIds'],
                    params['type'],
                  ),
        ),
        'uploadOptionImage': _i1.MethodConnector(
          name: 'uploadOptionImage',
          params: {
            'bytes': _i1.ParameterDescription(
              name: 'bytes',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).uploadOptionImage(
                    session,
                    params['bytes'],
                    params['fileName'],
                  ),
        ),
        'getStatsFavoris': _i1.MethodConnector(
          name: 'getStatsFavoris',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getStatsFavoris(session),
        ),
        'getAvisFilmsCinema': _i1.MethodConnector(
          name: 'getAvisFilmsCinema',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getAvisFilmsCinema(session),
        ),
        'getStatistiquesDetaillees': _i1.MethodConnector(
          name: 'getStatistiquesDetaillees',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getStatistiquesDetaillees(session),
        ),
      },
    );
    connectors['avis'] = _i1.EndpointConnector(
      name: 'avis',
      endpoint: endpoints['avis']!,
      methodConnectors: {
        'soumettreAvis': _i1.MethodConnector(
          name: 'soumettreAvis',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['avis'] as _i5.AvisEndpoint).soumettreAvis(
                session,
                params['filmId'],
                params['note'],
              ),
        ),
        'getMonAvis': _i1.MethodConnector(
          name: 'getMonAvis',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['avis'] as _i5.AvisEndpoint).getMonAvis(
                session,
                params['filmId'],
              ),
        ),
        'getStatsFilm': _i1.MethodConnector(
          name: 'getStatsFilm',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['avis'] as _i5.AvisEndpoint).getStatsFilm(
                session,
                params['filmId'],
              ),
        ),
      },
    );
    connectors['billet'] = _i1.EndpointConnector(
      name: 'billet',
      endpoint: endpoints['billet']!,
      methodConnectors: {
        'getMesBillets': _i1.MethodConnector(
          name: 'getMesBillets',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['billet'] as _i6.BilletEndpoint)
                  .getMesBillets(session),
        ),
        'getBilletsByReservation': _i1.MethodConnector(
          name: 'getBilletsByReservation',
          params: {
            'reservationId': _i1.ParameterDescription(
              name: 'reservationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['billet'] as _i6.BilletEndpoint)
                  .getBilletsByReservation(
                    session,
                    params['reservationId'],
                  ),
        ),
        'validerBillet': _i1.MethodConnector(
          name: 'validerBillet',
          params: {
            'qrCode': _i1.ParameterDescription(
              name: 'qrCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['billet'] as _i6.BilletEndpoint).validerBillet(
                    session,
                    params['qrCode'],
                  ),
        ),
      },
    );
    connectors['cinemas'] = _i1.EndpointConnector(
      name: 'cinemas',
      endpoint: endpoints['cinemas']!,
      methodConnectors: {
        'getCinemas': _i1.MethodConnector(
          name: 'getCinemas',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cinemas'] as _i7.CinemasEndpoint)
                  .getCinemas(session),
        ),
        'getCinemaById': _i1.MethodConnector(
          name: 'getCinemaById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cinemas'] as _i7.CinemasEndpoint).getCinemaById(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['evenements'] = _i1.EndpointConnector(
      name: 'evenements',
      endpoint: endpoints['evenements']!,
      methodConnectors: {
        'getEvenements': _i1.MethodConnector(
          name: 'getEvenements',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['evenements'] as _i8.EvenementsEndpoint)
                  .getEvenements(session),
        ),
        'getEvenementById': _i1.MethodConnector(
          name: 'getEvenementById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['evenements'] as _i8.EvenementsEndpoint)
                  .getEvenementById(
                    session,
                    params['id'],
                  ),
        ),
        'searchEvenements': _i1.MethodConnector(
          name: 'searchEvenements',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['evenements'] as _i8.EvenementsEndpoint)
                  .searchEvenements(
                    session,
                    params['query'],
                  ),
        ),
      },
    );
    connectors['faq'] = _i1.EndpointConnector(
      name: 'faq',
      endpoint: endpoints['faq']!,
      methodConnectors: {
        'getAllFaqs': _i1.MethodConnector(
          name: 'getAllFaqs',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['faq'] as _i9.FaqEndpoint).getAllFaqs(session),
        ),
      },
    );
    connectors['favori'] = _i1.EndpointConnector(
      name: 'favori',
      endpoint: endpoints['favori']!,
      methodConnectors: {
        'ajouterFilm': _i1.MethodConnector(
          name: 'ajouterFilm',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['favori'] as _i10.FavoriEndpoint).ajouterFilm(
                    session,
                    params['filmId'],
                  ),
        ),
        'retirerFilm': _i1.MethodConnector(
          name: 'retirerFilm',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['favori'] as _i10.FavoriEndpoint).retirerFilm(
                    session,
                    params['filmId'],
                  ),
        ),
        'ajouterCinema': _i1.MethodConnector(
          name: 'ajouterCinema',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['favori'] as _i10.FavoriEndpoint).ajouterCinema(
                    session,
                    params['cinemaId'],
                  ),
        ),
        'retirerCinema': _i1.MethodConnector(
          name: 'retirerCinema',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['favori'] as _i10.FavoriEndpoint).retirerCinema(
                    session,
                    params['cinemaId'],
                  ),
        ),
        'getMesFilmsFavoris': _i1.MethodConnector(
          name: 'getMesFilmsFavoris',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['favori'] as _i10.FavoriEndpoint)
                  .getMesFilmsFavoris(session),
        ),
        'getMesCinemasFavoris': _i1.MethodConnector(
          name: 'getMesCinemasFavoris',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['favori'] as _i10.FavoriEndpoint)
                  .getMesCinemasFavoris(session),
        ),
        'estFilmFavori': _i1.MethodConnector(
          name: 'estFilmFavori',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['favori'] as _i10.FavoriEndpoint).estFilmFavori(
                    session,
                    params['filmId'],
                  ),
        ),
        'estCinemaFavori': _i1.MethodConnector(
          name: 'estCinemaFavori',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['favori'] as _i10.FavoriEndpoint).estCinemaFavori(
                    session,
                    params['cinemaId'],
                  ),
        ),
      },
    );
    connectors['films'] = _i1.EndpointConnector(
      name: 'films',
      endpoint: endpoints['films']!,
      methodConnectors: {
        'getFilms': _i1.MethodConnector(
          name: 'getFilms',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['films'] as _i11.FilmsEndpoint).getFilms(session),
        ),
        'getFilmById': _i1.MethodConnector(
          name: 'getFilmById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['films'] as _i11.FilmsEndpoint).getFilmById(
                session,
                params['id'],
              ),
        ),
        'searchFilms': _i1.MethodConnector(
          name: 'searchFilms',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['films'] as _i11.FilmsEndpoint).searchFilms(
                session,
                params['query'],
              ),
        ),
        'getFilmsByCinema': _i1.MethodConnector(
          name: 'getFilmsByCinema',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['films'] as _i11.FilmsEndpoint).getFilmsByCinema(
                    session,
                    params['cinemaId'],
                  ),
        ),
      },
    );
    connectors['options'] = _i1.EndpointConnector(
      name: 'options',
      endpoint: endpoints['options']!,
      methodConnectors: {
        'getOptions': _i1.MethodConnector(
          name: 'getOptions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['options'] as _i12.OptionsEndpoint)
                  .getOptions(session),
        ),
      },
    );
    connectors['paiement'] = _i1.EndpointConnector(
      name: 'paiement',
      endpoint: endpoints['paiement']!,
      methodConnectors: {
        'effectuerPaiement': _i1.MethodConnector(
          name: 'effectuerPaiement',
          params: {
            'reservationId': _i1.ParameterDescription(
              name: 'reservationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'montant': _i1.ParameterDescription(
              name: 'montant',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'methode': _i1.ParameterDescription(
              name: 'methode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['paiement'] as _i13.PaiementEndpoint)
                  .effectuerPaiement(
                    session,
                    params['reservationId'],
                    params['montant'],
                    params['methode'],
                  ),
        ),
        'demanderRemboursement': _i1.MethodConnector(
          name: 'demanderRemboursement',
          params: {
            'reservationId': _i1.ParameterDescription(
              name: 'reservationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'raison': _i1.ParameterDescription(
              name: 'raison',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['paiement'] as _i13.PaiementEndpoint)
                  .demanderRemboursement(
                    session,
                    params['reservationId'],
                    params['raison'],
                  ),
        ),
      },
    );
    connectors['profil'] = _i1.EndpointConnector(
      name: 'profil',
      endpoint: endpoints['profil']!,
      methodConnectors: {
        'getProfil': _i1.MethodConnector(
          name: 'getProfil',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i14.ProfilEndpoint).getProfil(
                session,
              ),
        ),
        'updateProfil': _i1.MethodConnector(
          name: 'updateProfil',
          params: {
            'nom': _i1.ParameterDescription(
              name: 'nom',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'telephone': _i1.ParameterDescription(
              name: 'telephone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'dateNaissance': _i1.ParameterDescription(
              name: 'dateNaissance',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profil'] as _i14.ProfilEndpoint).updateProfil(
                    session,
                    params['nom'],
                    params['telephone'],
                    params['dateNaissance'],
                  ),
        ),
        'updatePhotoProfil': _i1.MethodConnector(
          name: 'updatePhotoProfil',
          params: {
            'photoBase64': _i1.ParameterDescription(
              name: 'photoBase64',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i14.ProfilEndpoint)
                  .updatePhotoProfil(
                    session,
                    params['photoBase64'],
                  ),
        ),
        'desactiverCompte': _i1.MethodConnector(
          name: 'desactiverCompte',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i14.ProfilEndpoint)
                  .desactiverCompte(session),
        ),
        'supprimerCompte': _i1.MethodConnector(
          name: 'supprimerCompte',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i14.ProfilEndpoint)
                  .supprimerCompte(session),
        ),
      },
    );
    connectors['reservation'] = _i1.EndpointConnector(
      name: 'reservation',
      endpoint: endpoints['reservation']!,
      methodConnectors: {
        'creerReservation': _i1.MethodConnector(
          name: 'creerReservation',
          params: {
            'seanceId': _i1.ParameterDescription(
              name: 'seanceId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'evenementId': _i1.ParameterDescription(
              name: 'evenementId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'typeReservation': _i1.ParameterDescription(
              name: 'typeReservation',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'montantTotal': _i1.ParameterDescription(
              name: 'montantTotal',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'codePromoId': _i1.ParameterDescription(
              name: 'codePromoId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reservation'] as _i15.ReservationEndpoint)
                  .creerReservation(
                    session,
                    seanceId: params['seanceId'],
                    evenementId: params['evenementId'],
                    typeReservation: params['typeReservation'],
                    montantTotal: params['montantTotal'],
                    codePromoId: params['codePromoId'],
                  ),
        ),
        'getMesReservations': _i1.MethodConnector(
          name: 'getMesReservations',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reservation'] as _i15.ReservationEndpoint)
                  .getMesReservations(session),
        ),
        'annulerReservation': _i1.MethodConnector(
          name: 'annulerReservation',
          params: {
            'reservationId': _i1.ParameterDescription(
              name: 'reservationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reservation'] as _i15.ReservationEndpoint)
                  .annulerReservation(
                    session,
                    params['reservationId'],
                  ),
        ),
        'validerCodePromo': _i1.MethodConnector(
          name: 'validerCodePromo',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reservation'] as _i15.ReservationEndpoint)
                  .validerCodePromo(
                    session,
                    params['code'],
                  ),
        ),
      },
    );
    connectors['salles'] = _i1.EndpointConnector(
      name: 'salles',
      endpoint: endpoints['salles']!,
      methodConnectors: {
        'getSalles': _i1.MethodConnector(
          name: 'getSalles',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['salles'] as _i16.SallesEndpoint).getSalles(
                session,
              ),
        ),
      },
    );
    connectors['seances'] = _i1.EndpointConnector(
      name: 'seances',
      endpoint: endpoints['seances']!,
      methodConnectors: {
        'getSeancesByFilm': _i1.MethodConnector(
          name: 'getSeancesByFilm',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['seances'] as _i17.SeancesEndpoint)
                  .getSeancesByFilm(
                    session,
                    params['filmId'],
                  ),
        ),
        'getSeancesByIds': _i1.MethodConnector(
          name: 'getSeancesByIds',
          params: {
            'ids': _i1.ParameterDescription(
              name: 'ids',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['seances'] as _i17.SeancesEndpoint)
                  .getSeancesByIds(
                    session,
                    params['ids'],
                  ),
        ),
      },
    );
    connectors['sieges'] = _i1.EndpointConnector(
      name: 'sieges',
      endpoint: endpoints['sieges']!,
      methodConnectors: {
        'getSiegesBySalle': _i1.MethodConnector(
          name: 'getSiegesBySalle',
          params: {
            'salleId': _i1.ParameterDescription(
              name: 'salleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sieges'] as _i18.SiegesEndpoint).getSiegesBySalle(
                    session,
                    params['salleId'],
                  ),
        ),
        'getSiegesReservesBySeance': _i1.MethodConnector(
          name: 'getSiegesReservesBySeance',
          params: {
            'seanceId': _i1.ParameterDescription(
              name: 'seanceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sieges'] as _i18.SiegesEndpoint)
                  .getSiegesReservesBySeance(
                    session,
                    params['seanceId'],
                  ),
        ),
        'getSiegesReservesByEvenement': _i1.MethodConnector(
          name: 'getSiegesReservesByEvenement',
          params: {
            'evenementId': _i1.ParameterDescription(
              name: 'evenementId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sieges'] as _i18.SiegesEndpoint)
                  .getSiegesReservesByEvenement(
                    session,
                    params['evenementId'],
                  ),
        ),
      },
    );
    connectors['support'] = _i1.EndpointConnector(
      name: 'support',
      endpoint: endpoints['support']!,
      methodConnectors: {
        'creerDemande': _i1.MethodConnector(
          name: 'creerDemande',
          params: {
            'sujet': _i1.ParameterDescription(
              name: 'sujet',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'utilisateurId': _i1.ParameterDescription(
              name: 'utilisateurId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['support'] as _i19.SupportEndpoint).creerDemande(
                    session,
                    params['sujet'],
                    params['message'],
                    params['utilisateurId'],
                    params['cinemaId'],
                  ),
        ),
        'getDemandes': _i1.MethodConnector(
          name: 'getDemandes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['support'] as _i19.SupportEndpoint)
                  .getDemandes(session),
        ),
        'getDemandesByCinema': _i1.MethodConnector(
          name: 'getDemandesByCinema',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['support'] as _i19.SupportEndpoint)
                  .getDemandesByCinema(
                    session,
                    params['cinemaId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i20.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i30.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i31.Endpoints()
      ..initializeEndpoints(server);
  }
}
