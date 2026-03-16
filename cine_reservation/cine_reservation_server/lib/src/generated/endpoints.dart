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
import '../endpoints/avis_endpoint.dart' as _i4;
import '../endpoints/billet_endpoint.dart' as _i5;
import '../endpoints/cinemas_endpoint.dart' as _i6;
import '../endpoints/evenements_endpoint.dart' as _i7;
import '../endpoints/films_endpoint.dart' as _i8;
import '../endpoints/options_endpoint.dart' as _i9;
import '../endpoints/paiement_endpoint.dart' as _i10;
import '../endpoints/profil_endpoint.dart' as _i11;
import '../endpoints/reservation_endpoint.dart' as _i12;
import '../endpoints/salles_endpoint.dart' as _i13;
import '../endpoints/seances_endpoint.dart' as _i14;
import '../endpoints/sieges_endpoint.dart' as _i15;
import '../endpoints/support_endpoint.dart' as _i16;
import '../greetings/greeting_endpoint.dart' as _i17;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i18;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i19;

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
      'avis': _i4.AvisEndpoint()
        ..initialize(
          server,
          'avis',
          null,
        ),
      'billet': _i5.BilletEndpoint()
        ..initialize(
          server,
          'billet',
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
      'films': _i8.FilmsEndpoint()
        ..initialize(
          server,
          'films',
          null,
        ),
      'options': _i9.OptionsEndpoint()
        ..initialize(
          server,
          'options',
          null,
        ),
      'paiement': _i10.PaiementEndpoint()
        ..initialize(
          server,
          'paiement',
          null,
        ),
      'profil': _i11.ProfilEndpoint()
        ..initialize(
          server,
          'profil',
          null,
        ),
      'reservation': _i12.ReservationEndpoint()
        ..initialize(
          server,
          'reservation',
          null,
        ),
      'salles': _i13.SallesEndpoint()
        ..initialize(
          server,
          'salles',
          null,
        ),
      'seances': _i14.SeancesEndpoint()
        ..initialize(
          server,
          'seances',
          null,
        ),
      'sieges': _i15.SiegesEndpoint()
        ..initialize(
          server,
          'sieges',
          null,
        ),
      'support': _i16.SupportEndpoint()
        ..initialize(
          server,
          'support',
          null,
        ),
      'greeting': _i17.GreetingEndpoint()
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
    connectors['avis'] = _i1.EndpointConnector(
      name: 'avis',
      endpoint: endpoints['avis']!,
      methodConnectors: {},
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
              ) async => (endpoints['billet'] as _i5.BilletEndpoint)
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
              ) async => (endpoints['billet'] as _i5.BilletEndpoint)
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
                  (endpoints['billet'] as _i5.BilletEndpoint).validerBillet(
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
                  (endpoints['films'] as _i8.FilmsEndpoint).getFilms(session),
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
              ) async => (endpoints['films'] as _i8.FilmsEndpoint).getFilmById(
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
              ) async => (endpoints['films'] as _i8.FilmsEndpoint).searchFilms(
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
              ) async => (endpoints['options'] as _i9.OptionsEndpoint)
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
              ) async => (endpoints['paiement'] as _i10.PaiementEndpoint)
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
              ) async => (endpoints['paiement'] as _i10.PaiementEndpoint)
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
              ) async => (endpoints['profil'] as _i11.ProfilEndpoint).getProfil(
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
                  (endpoints['profil'] as _i11.ProfilEndpoint).updateProfil(
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
              ) async => (endpoints['profil'] as _i11.ProfilEndpoint)
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
              ) async => (endpoints['profil'] as _i11.ProfilEndpoint)
                  .desactiverCompte(session),
        ),
        'supprimerCompte': _i1.MethodConnector(
          name: 'supprimerCompte',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i11.ProfilEndpoint)
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
              ) async => (endpoints['reservation'] as _i12.ReservationEndpoint)
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
              ) async => (endpoints['reservation'] as _i12.ReservationEndpoint)
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
              ) async => (endpoints['reservation'] as _i12.ReservationEndpoint)
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
              ) async => (endpoints['reservation'] as _i12.ReservationEndpoint)
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
              ) async => (endpoints['salles'] as _i13.SallesEndpoint).getSalles(
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
              ) async => (endpoints['seances'] as _i14.SeancesEndpoint)
                  .getSeancesByFilm(
                    session,
                    params['filmId'],
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
                  (endpoints['sieges'] as _i15.SiegesEndpoint).getSiegesBySalle(
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
              ) async => (endpoints['sieges'] as _i15.SiegesEndpoint)
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
              ) async => (endpoints['sieges'] as _i15.SiegesEndpoint)
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['support'] as _i16.SupportEndpoint).creerDemande(
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
              ) async => (endpoints['support'] as _i16.SupportEndpoint)
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
              ) async => (endpoints['greeting'] as _i17.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i18.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i19.Endpoints()
      ..initializeEndpoints(server);
  }
}
