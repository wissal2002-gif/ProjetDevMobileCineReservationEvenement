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
import '../endpoints/cinemas_endpoint.dart' as _i6;
import '../endpoints/evenements_endpoint.dart' as _i7;
import '../endpoints/faq_endpoint.dart' as _i8;
import '../endpoints/films_endpoint.dart' as _i9;
import '../endpoints/options_endpoint.dart' as _i10;
import '../endpoints/salles_endpoint.dart' as _i11;
import '../endpoints/seances_endpoint.dart' as _i12;
import '../endpoints/support_endpoint.dart' as _i13;
import '../greetings/greeting_endpoint.dart' as _i14;
import 'package:cine_reservation_server/src/generated/film.dart' as _i15;
import 'package:cine_reservation_server/src/generated/cinema.dart' as _i16;
import 'package:cine_reservation_server/src/generated/salle.dart' as _i17;
import 'package:cine_reservation_server/src/generated/siege.dart' as _i18;
import 'package:cine_reservation_server/src/generated/seance.dart' as _i19;
import 'package:cine_reservation_server/src/generated/evenement.dart' as _i20;
import 'package:cine_reservation_server/src/generated/option%20supplementaire.dart'
    as _i21;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i22;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i23;

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
      'cinemas': _i6.CinemasEndpoint()
        ..initialize(
          server,
          'cinemas',
          null,
        ),
      'evenements': _i7.EvenementsEndpoint()
        ..initialize(
          server,
          'evenements',
          null,
        ),
      'faq': _i8.FaqEndpoint()
        ..initialize(
          server,
          'faq',
          null,
        ),
      'films': _i9.FilmsEndpoint()
        ..initialize(
          server,
          'films',
          null,
        ),
      'options': _i10.OptionsEndpoint()
        ..initialize(
          server,
          'options',
          null,
        ),
      'salles': _i11.SallesEndpoint()
        ..initialize(
          server,
          'salles',
          null,
        ),
      'seances': _i12.SeancesEndpoint()
        ..initialize(
          server,
          'seances',
          null,
        ),
      'support': _i13.SupportEndpoint()
        ..initialize(
          server,
          'support',
          null,
        ),
      'greeting': _i14.GreetingEndpoint()
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
        'ajouterFilm': _i1.MethodConnector(
          name: 'ajouterFilm',
          params: {
            'film': _i1.ParameterDescription(
              name: 'film',
              type: _i1.getType<_i15.Film>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).ajouterFilm(
                session,
                params['film'],
              ),
        ),
        'modifierFilm': _i1.MethodConnector(
          name: 'modifierFilm',
          params: {
            'film': _i1.ParameterDescription(
              name: 'film',
              type: _i1.getType<_i15.Film>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).modifierFilm(
                session,
                params['film'],
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
        'ajouterCinema': _i1.MethodConnector(
          name: 'ajouterCinema',
          params: {
            'cinema': _i1.ParameterDescription(
              name: 'cinema',
              type: _i1.getType<_i16.Cinema>(),
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
                    params['cinema'],
                  ),
        ),
        'modifierCinema': _i1.MethodConnector(
          name: 'modifierCinema',
          params: {
            'cinema': _i1.ParameterDescription(
              name: 'cinema',
              type: _i1.getType<_i16.Cinema>(),
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
                    params['cinema'],
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
        'ajouterSalle': _i1.MethodConnector(
          name: 'ajouterSalle',
          params: {
            'salle': _i1.ParameterDescription(
              name: 'salle',
              type: _i1.getType<_i17.Salle>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).ajouterSalle(
                session,
                params['salle'],
              ),
        ),
        'modifierSalle': _i1.MethodConnector(
          name: 'modifierSalle',
          params: {
            'salle': _i1.ParameterDescription(
              name: 'salle',
              type: _i1.getType<_i17.Salle>(),
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
                    params['salle'],
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
        'ajouterSiege': _i1.MethodConnector(
          name: 'ajouterSiege',
          params: {
            'siege': _i1.ParameterDescription(
              name: 'siege',
              type: _i1.getType<_i18.Siege>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint).ajouterSiege(
                session,
                params['siege'],
              ),
        ),
        'supprimerSiege': _i1.MethodConnector(
          name: 'supprimerSiege',
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
                  (endpoints['admin'] as _i4.AdminEndpoint).supprimerSiege(
                    session,
                    params['id'],
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
            'nbRangees': _i1.ParameterDescription(
              name: 'nbRangees',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'siegesParRangee': _i1.ParameterDescription(
              name: 'siegesParRangee',
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
                    params['nbRangees'],
                    params['siegesParRangee'],
                  ),
        ),
        'ajouterSeance': _i1.MethodConnector(
          name: 'ajouterSeance',
          params: {
            'seance': _i1.ParameterDescription(
              name: 'seance',
              type: _i1.getType<_i19.Seance>(),
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
                    params['seance'],
                  ),
        ),
        'modifierSeance': _i1.MethodConnector(
          name: 'modifierSeance',
          params: {
            'seance': _i1.ParameterDescription(
              name: 'seance',
              type: _i1.getType<_i19.Seance>(),
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
                    params['seance'],
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
                  (endpoints['admin'] as _i4.AdminEndpoint).getSeancesByCinema(
                    session,
                    params['cinemaId'],
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
            'utilisateurId': _i1.ParameterDescription(
              name: 'utilisateurId',
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
                    params['utilisateurId'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .rembourserReservation(
                    session,
                    params['reservationId'],
                    params['montant'],
                  ),
        ),
        'getTauxRemplissageSeance': _i1.MethodConnector(
          name: 'getTauxRemplissageSeance',
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
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getTauxRemplissageSeance(
                    session,
                    params['seanceId'],
                  ),
        ),
        'getSiegesByReservation': _i1.MethodConnector(
          name: 'getSiegesByReservation',
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
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getSiegesByReservation(
                    session,
                    params['reservationId'],
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
            'evenement': _i1.ParameterDescription(
              name: 'evenement',
              type: _i1.getType<_i20.Evenement>(),
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
                    params['evenement'],
                  ),
        ),
        'modifierEvenement': _i1.MethodConnector(
          name: 'modifierEvenement',
          params: {
            'evenement': _i1.ParameterDescription(
              name: 'evenement',
              type: _i1.getType<_i20.Evenement>(),
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
                    params['evenement'],
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
            'reponse': _i1.ParameterDescription(
              name: 'reponse',
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
                    params['reponse'],
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
            'option': _i1.ParameterDescription(
              name: 'option',
              type: _i1.getType<_i21.OptionSupplementaire>(),
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
                    params['option'],
                  ),
        ),
        'modifierOption': _i1.MethodConnector(
          name: 'modifierOption',
          params: {
            'option': _i1.ParameterDescription(
              name: 'option',
              type: _i1.getType<_i21.OptionSupplementaire>(),
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
                    params['option'],
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
      },
    );
    connectors['avis'] = _i1.EndpointConnector(
      name: 'avis',
      endpoint: endpoints['avis']!,
      methodConnectors: {},
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
              ) async => (endpoints['cinemas'] as _i6.CinemasEndpoint)
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
                  (endpoints['cinemas'] as _i6.CinemasEndpoint).getCinemaById(
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
              ) async => (endpoints['evenements'] as _i7.EvenementsEndpoint)
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
              ) async => (endpoints['evenements'] as _i7.EvenementsEndpoint)
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
              ) async => (endpoints['evenements'] as _i7.EvenementsEndpoint)
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
                  (endpoints['faq'] as _i8.FaqEndpoint).getAllFaqs(session),
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
                  (endpoints['films'] as _i9.FilmsEndpoint).getFilms(session),
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
              ) async => (endpoints['films'] as _i9.FilmsEndpoint).getFilmById(
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
              ) async => (endpoints['films'] as _i9.FilmsEndpoint).searchFilms(
                session,
                params['query'],
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
              ) async => (endpoints['options'] as _i10.OptionsEndpoint)
                  .getOptions(session),
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
              ) async => (endpoints['salles'] as _i11.SallesEndpoint).getSalles(
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
              ) async => (endpoints['seances'] as _i12.SeancesEndpoint)
                  .getSeancesByFilm(
                    session,
                    params['filmId'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['support'] as _i13.SupportEndpoint).creerDemande(
                    session,
                    params['sujet'],
                    params['message'],
                  ),
        ),
        'getDemandes': _i1.MethodConnector(
          name: 'getDemandes',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['support'] as _i13.SupportEndpoint)
                  .getDemandes(session),
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
              ) async => (endpoints['greeting'] as _i14.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i22.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i23.Endpoints()
      ..initializeEndpoints(server);
  }
}
