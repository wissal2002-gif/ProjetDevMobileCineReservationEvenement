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
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:cine_reservation_client/src/protocol/billet.dart' as _i5;
import 'package:cine_reservation_client/src/protocol/cinema.dart' as _i6;
import 'package:cine_reservation_client/src/protocol/evenement.dart' as _i7;
import 'package:cine_reservation_client/src/protocol/film.dart' as _i8;
import 'package:cine_reservation_client/src/protocol/option%20supplementaire.dart'
    as _i9;
import 'package:cine_reservation_client/src/protocol/paiement.dart' as _i10;
import 'package:cine_reservation_client/src/protocol/utilisateur.dart' as _i11;
import 'package:cine_reservation_client/src/protocol/reservation.dart' as _i12;
import 'package:cine_reservation_client/src/protocol/code_promo.dart' as _i13;
import 'package:cine_reservation_client/src/protocol/salle.dart' as _i14;
import 'package:cine_reservation_client/src/protocol/seance.dart' as _i15;
import 'package:cine_reservation_client/src/protocol/siege.dart' as _i16;
import 'package:cine_reservation_client/src/protocol/demande_support.dart'
    as _i17;
import 'package:cine_reservation_client/src/protocol/greetings/greeting.dart'
    as _i18;
import 'protocol.dart' as _i19;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointAvis extends _i2.EndpointRef {
  EndpointAvis(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'avis';
}

/// {@category Endpoint}
class EndpointBillet extends _i2.EndpointRef {
  EndpointBillet(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'billet';

  _i3.Future<List<_i5.Billet>> getMesBillets() =>
      caller.callServerEndpoint<List<_i5.Billet>>(
        'billet',
        'getMesBillets',
        {},
      );

  _i3.Future<List<_i5.Billet>> getBilletsByReservation(int reservationId) =>
      caller.callServerEndpoint<List<_i5.Billet>>(
        'billet',
        'getBilletsByReservation',
        {'reservationId': reservationId},
      );

  _i3.Future<bool> validerBillet(String qrCode) =>
      caller.callServerEndpoint<bool>(
        'billet',
        'validerBillet',
        {'qrCode': qrCode},
      );
}

/// {@category Endpoint}
class EndpointCinemas extends _i2.EndpointRef {
  EndpointCinemas(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cinemas';

  _i3.Future<List<_i6.Cinema>> getCinemas() =>
      caller.callServerEndpoint<List<_i6.Cinema>>(
        'cinemas',
        'getCinemas',
        {},
      );

  _i3.Future<_i6.Cinema?> getCinemaById(int id) =>
      caller.callServerEndpoint<_i6.Cinema?>(
        'cinemas',
        'getCinemaById',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointEvenements extends _i2.EndpointRef {
  EndpointEvenements(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'evenements';

  _i3.Future<List<_i7.Evenement>> getEvenements() =>
      caller.callServerEndpoint<List<_i7.Evenement>>(
        'evenements',
        'getEvenements',
        {},
      );

  _i3.Future<_i7.Evenement?> getEvenementById(int id) =>
      caller.callServerEndpoint<_i7.Evenement?>(
        'evenements',
        'getEvenementById',
        {'id': id},
      );

  _i3.Future<List<_i7.Evenement>> searchEvenements(String query) =>
      caller.callServerEndpoint<List<_i7.Evenement>>(
        'evenements',
        'searchEvenements',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointFilms extends _i2.EndpointRef {
  EndpointFilms(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'films';

  _i3.Future<List<_i8.Film>> getFilms() =>
      caller.callServerEndpoint<List<_i8.Film>>(
        'films',
        'getFilms',
        {},
      );

  _i3.Future<_i8.Film?> getFilmById(int id) =>
      caller.callServerEndpoint<_i8.Film?>(
        'films',
        'getFilmById',
        {'id': id},
      );

  _i3.Future<List<_i8.Film>> searchFilms(String query) =>
      caller.callServerEndpoint<List<_i8.Film>>(
        'films',
        'searchFilms',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointOptions extends _i2.EndpointRef {
  EndpointOptions(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'options';

  _i3.Future<List<_i9.OptionSupplementaire>> getOptions() =>
      caller.callServerEndpoint<List<_i9.OptionSupplementaire>>(
        'options',
        'getOptions',
        {},
      );
}

/// {@category Endpoint}
class EndpointPaiement extends _i2.EndpointRef {
  EndpointPaiement(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'paiement';

  _i3.Future<_i10.Paiement?> effectuerPaiement(
    int reservationId,
    double montant,
    String methode,
  ) => caller.callServerEndpoint<_i10.Paiement?>(
    'paiement',
    'effectuerPaiement',
    {
      'reservationId': reservationId,
      'montant': montant,
      'methode': methode,
    },
  );

  _i3.Future<bool> demanderRemboursement(
    int reservationId,
    String raison,
  ) => caller.callServerEndpoint<bool>(
    'paiement',
    'demanderRemboursement',
    {
      'reservationId': reservationId,
      'raison': raison,
    },
  );
}

/// {@category Endpoint}
class EndpointProfil extends _i2.EndpointRef {
  EndpointProfil(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profil';

  _i3.Future<_i11.Utilisateur?> getProfil() =>
      caller.callServerEndpoint<_i11.Utilisateur?>(
        'profil',
        'getProfil',
        {},
      );

  _i3.Future<_i11.Utilisateur?> updateProfil(
    String nom,
    String? telephone,
    DateTime? dateNaissance,
  ) => caller.callServerEndpoint<_i11.Utilisateur?>(
    'profil',
    'updateProfil',
    {
      'nom': nom,
      'telephone': telephone,
      'dateNaissance': dateNaissance,
    },
  );

  _i3.Future<_i11.Utilisateur?> updatePhotoProfil(String photoBase64) =>
      caller.callServerEndpoint<_i11.Utilisateur?>(
        'profil',
        'updatePhotoProfil',
        {'photoBase64': photoBase64},
      );

  _i3.Future<bool> desactiverCompte() => caller.callServerEndpoint<bool>(
    'profil',
    'desactiverCompte',
    {},
  );

  _i3.Future<bool> supprimerCompte() => caller.callServerEndpoint<bool>(
    'profil',
    'supprimerCompte',
    {},
  );
}

/// {@category Endpoint}
class EndpointReservation extends _i2.EndpointRef {
  EndpointReservation(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reservation';

  _i3.Future<_i12.Reservation?> creerReservation({
    int? seanceId,
    int? evenementId,
    String? typeReservation,
    required double montantTotal,
    int? codePromoId,
  }) => caller.callServerEndpoint<_i12.Reservation?>(
    'reservation',
    'creerReservation',
    {
      'seanceId': seanceId,
      'evenementId': evenementId,
      'typeReservation': typeReservation,
      'montantTotal': montantTotal,
      'codePromoId': codePromoId,
    },
  );

  _i3.Future<List<_i12.Reservation>> getMesReservations() =>
      caller.callServerEndpoint<List<_i12.Reservation>>(
        'reservation',
        'getMesReservations',
        {},
      );

  _i3.Future<bool> annulerReservation(int reservationId) =>
      caller.callServerEndpoint<bool>(
        'reservation',
        'annulerReservation',
        {'reservationId': reservationId},
      );

  _i3.Future<_i13.CodePromo?> validerCodePromo(String code) =>
      caller.callServerEndpoint<_i13.CodePromo?>(
        'reservation',
        'validerCodePromo',
        {'code': code},
      );
}

/// {@category Endpoint}
class EndpointSalles extends _i2.EndpointRef {
  EndpointSalles(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'salles';

  _i3.Future<List<_i14.Salle>> getSalles() =>
      caller.callServerEndpoint<List<_i14.Salle>>(
        'salles',
        'getSalles',
        {},
      );
}

/// {@category Endpoint}
class EndpointSeances extends _i2.EndpointRef {
  EndpointSeances(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'seances';

  _i3.Future<List<_i15.Seance>> getSeancesByFilm(int filmId) =>
      caller.callServerEndpoint<List<_i15.Seance>>(
        'seances',
        'getSeancesByFilm',
        {'filmId': filmId},
      );
}

/// {@category Endpoint}
class EndpointSieges extends _i2.EndpointRef {
  EndpointSieges(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sieges';

  _i3.Future<List<_i16.Siege>> getSiegesBySalle(int salleId) =>
      caller.callServerEndpoint<List<_i16.Siege>>(
        'sieges',
        'getSiegesBySalle',
        {'salleId': salleId},
      );

  _i3.Future<List<int>> getSiegesReservesBySeance(int seanceId) =>
      caller.callServerEndpoint<List<int>>(
        'sieges',
        'getSiegesReservesBySeance',
        {'seanceId': seanceId},
      );

  _i3.Future<List<int>> getSiegesReservesByEvenement(int evenementId) =>
      caller.callServerEndpoint<List<int>>(
        'sieges',
        'getSiegesReservesByEvenement',
        {'evenementId': evenementId},
      );
}

/// {@category Endpoint}
class EndpointSupport extends _i2.EndpointRef {
  EndpointSupport(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'support';

  _i3.Future<bool> creerDemande(
    String sujet,
    String message,
  ) => caller.callServerEndpoint<bool>(
    'support',
    'creerDemande',
    {
      'sujet': sujet,
      'message': message,
    },
  );

  _i3.Future<List<_i17.DemandeSupport>> getDemandes() =>
      caller.callServerEndpoint<List<_i17.DemandeSupport>>(
        'support',
        'getDemandes',
        {},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i18.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i18.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i19.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    avis = EndpointAvis(this);
    billet = EndpointBillet(this);
    cinemas = EndpointCinemas(this);
    evenements = EndpointEvenements(this);
    films = EndpointFilms(this);
    options = EndpointOptions(this);
    paiement = EndpointPaiement(this);
    profil = EndpointProfil(this);
    reservation = EndpointReservation(this);
    salles = EndpointSalles(this);
    seances = EndpointSeances(this);
    sieges = EndpointSieges(this);
    support = EndpointSupport(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAvis avis;

  late final EndpointBillet billet;

  late final EndpointCinemas cinemas;

  late final EndpointEvenements evenements;

  late final EndpointFilms films;

  late final EndpointOptions options;

  late final EndpointPaiement paiement;

  late final EndpointProfil profil;

  late final EndpointReservation reservation;

  late final EndpointSalles salles;

  late final EndpointSeances seances;

  late final EndpointSieges sieges;

  late final EndpointSupport support;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'avis': avis,
    'billet': billet,
    'cinemas': cinemas,
    'evenements': evenements,
    'films': films,
    'options': options,
    'paiement': paiement,
    'profil': profil,
    'reservation': reservation,
    'salles': salles,
    'seances': seances,
    'sieges': sieges,
    'support': support,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
