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
import 'package:cine_reservation_client/src/protocol/film.dart' as _i5;
import 'package:cine_reservation_client/src/protocol/cinema.dart' as _i6;
import 'package:cine_reservation_client/src/protocol/salle.dart' as _i7;
import 'package:cine_reservation_client/src/protocol/siege.dart' as _i8;
import 'package:cine_reservation_client/src/protocol/seance.dart' as _i9;
import 'package:cine_reservation_client/src/protocol/utilisateur.dart' as _i10;
import 'package:cine_reservation_client/src/protocol/reservation.dart' as _i11;
import 'package:cine_reservation_client/src/protocol/evenement.dart' as _i12;
import 'package:cine_reservation_client/src/protocol/demande_support.dart'
    as _i13;
import 'package:cine_reservation_client/src/protocol/option%20supplementaire.dart'
    as _i14;
import 'package:cine_reservation_client/src/protocol/faq.dart' as _i15;
import 'package:cine_reservation_client/src/protocol/greetings/greeting.dart'
    as _i16;
import 'protocol.dart' as _i17;

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
class EndpointAdmin extends _i2.EndpointRef {
  EndpointAdmin(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i3.Future<_i5.Film> ajouterFilm(_i5.Film film) =>
      caller.callServerEndpoint<_i5.Film>(
        'admin',
        'ajouterFilm',
        {'film': film},
      );

  _i3.Future<_i5.Film> modifierFilm(_i5.Film film) =>
      caller.callServerEndpoint<_i5.Film>(
        'admin',
        'modifierFilm',
        {'film': film},
      );

  _i3.Future<void> supprimerFilm(int id) => caller.callServerEndpoint<void>(
    'admin',
    'supprimerFilm',
    {'id': id},
  );

  _i3.Future<List<_i5.Film>> getAllFilms() =>
      caller.callServerEndpoint<List<_i5.Film>>(
        'admin',
        'getAllFilms',
        {},
      );

  _i3.Future<_i6.Cinema> ajouterCinema(_i6.Cinema cinema) =>
      caller.callServerEndpoint<_i6.Cinema>(
        'admin',
        'ajouterCinema',
        {'cinema': cinema},
      );

  _i3.Future<_i6.Cinema> modifierCinema(_i6.Cinema cinema) =>
      caller.callServerEndpoint<_i6.Cinema>(
        'admin',
        'modifierCinema',
        {'cinema': cinema},
      );

  _i3.Future<void> supprimerCinema(int id) => caller.callServerEndpoint<void>(
    'admin',
    'supprimerCinema',
    {'id': id},
  );

  _i3.Future<List<_i6.Cinema>> getAllCinemas() =>
      caller.callServerEndpoint<List<_i6.Cinema>>(
        'admin',
        'getAllCinemas',
        {},
      );

  _i3.Future<_i7.Salle> ajouterSalle(_i7.Salle salle) =>
      caller.callServerEndpoint<_i7.Salle>(
        'admin',
        'ajouterSalle',
        {'salle': salle},
      );

  _i3.Future<_i7.Salle> modifierSalle(_i7.Salle salle) =>
      caller.callServerEndpoint<_i7.Salle>(
        'admin',
        'modifierSalle',
        {'salle': salle},
      );

  _i3.Future<void> supprimerSalle(int id) => caller.callServerEndpoint<void>(
    'admin',
    'supprimerSalle',
    {'id': id},
  );

  _i3.Future<List<_i7.Salle>> getSallesByCinema(int cinemaId) =>
      caller.callServerEndpoint<List<_i7.Salle>>(
        'admin',
        'getSallesByCinema',
        {'cinemaId': cinemaId},
      );

  _i3.Future<List<_i7.Salle>> getAllSalles() =>
      caller.callServerEndpoint<List<_i7.Salle>>(
        'admin',
        'getAllSalles',
        {},
      );

  _i3.Future<List<_i8.Siege>> getSiegesBySalle(int salleId) =>
      caller.callServerEndpoint<List<_i8.Siege>>(
        'admin',
        'getSiegesBySalle',
        {'salleId': salleId},
      );

  _i3.Future<_i8.Siege> ajouterSiege(_i8.Siege siege) =>
      caller.callServerEndpoint<_i8.Siege>(
        'admin',
        'ajouterSiege',
        {'siege': siege},
      );

  _i3.Future<void> supprimerSiege(int id) => caller.callServerEndpoint<void>(
    'admin',
    'supprimerSiege',
    {'id': id},
  );

  _i3.Future<void> genererSiegesPourSalle(
    int salleId,
    int nbRangees,
    int siegesParRangee,
  ) => caller.callServerEndpoint<void>(
    'admin',
    'genererSiegesPourSalle',
    {
      'salleId': salleId,
      'nbRangees': nbRangees,
      'siegesParRangee': siegesParRangee,
    },
  );

  _i3.Future<_i9.Seance> ajouterSeance(_i9.Seance seance) =>
      caller.callServerEndpoint<_i9.Seance>(
        'admin',
        'ajouterSeance',
        {'seance': seance},
      );

  _i3.Future<_i9.Seance> modifierSeance(_i9.Seance seance) =>
      caller.callServerEndpoint<_i9.Seance>(
        'admin',
        'modifierSeance',
        {'seance': seance},
      );

  _i3.Future<void> supprimerSeance(int id) => caller.callServerEndpoint<void>(
    'admin',
    'supprimerSeance',
    {'id': id},
  );

  _i3.Future<List<_i9.Seance>> getAllSeances() =>
      caller.callServerEndpoint<List<_i9.Seance>>(
        'admin',
        'getAllSeances',
        {},
      );

  _i3.Future<List<_i9.Seance>> getSeancesByFilm(int filmId) =>
      caller.callServerEndpoint<List<_i9.Seance>>(
        'admin',
        'getSeancesByFilm',
        {'filmId': filmId},
      );

  _i3.Future<List<_i9.Seance>> getSeancesByCinema(int cinemaId) =>
      caller.callServerEndpoint<List<_i9.Seance>>(
        'admin',
        'getSeancesByCinema',
        {'cinemaId': cinemaId},
      );

  _i3.Future<List<_i10.Utilisateur>> getAllUtilisateurs() =>
      caller.callServerEndpoint<List<_i10.Utilisateur>>(
        'admin',
        'getAllUtilisateurs',
        {},
      );

  _i3.Future<_i10.Utilisateur> suspendreUtilisateur(int id) =>
      caller.callServerEndpoint<_i10.Utilisateur>(
        'admin',
        'suspendreUtilisateur',
        {'id': id},
      );

  _i3.Future<_i10.Utilisateur> activerUtilisateur(int id) =>
      caller.callServerEndpoint<_i10.Utilisateur>(
        'admin',
        'activerUtilisateur',
        {'id': id},
      );

  _i3.Future<void> supprimerUtilisateur(int id) =>
      caller.callServerEndpoint<void>(
        'admin',
        'supprimerUtilisateur',
        {'id': id},
      );

  _i3.Future<List<_i11.Reservation>> getHistoriqueUtilisateur(
    int utilisateurId,
  ) => caller.callServerEndpoint<List<_i11.Reservation>>(
    'admin',
    'getHistoriqueUtilisateur',
    {'utilisateurId': utilisateurId},
  );

  _i3.Future<_i10.Utilisateur?> getMonProfil() =>
      caller.callServerEndpoint<_i10.Utilisateur?>(
        'admin',
        'getMonProfil',
        {},
      );

  _i3.Future<List<_i11.Reservation>> getAllReservations() =>
      caller.callServerEndpoint<List<_i11.Reservation>>(
        'admin',
        'getAllReservations',
        {},
      );

  _i3.Future<void> rembourserReservation(
    int reservationId,
    double montant,
  ) => caller.callServerEndpoint<void>(
    'admin',
    'rembourserReservation',
    {
      'reservationId': reservationId,
      'montant': montant,
    },
  );

  _i3.Future<double> getTauxRemplissageSeance(int seanceId) =>
      caller.callServerEndpoint<double>(
        'admin',
        'getTauxRemplissageSeance',
        {'seanceId': seanceId},
      );

  _i3.Future<List<_i8.Siege>> getSiegesByReservation(int reservationId) =>
      caller.callServerEndpoint<List<_i8.Siege>>(
        'admin',
        'getSiegesByReservation',
        {'reservationId': reservationId},
      );

  _i3.Future<List<_i12.Evenement>> getAllEvenements() =>
      caller.callServerEndpoint<List<_i12.Evenement>>(
        'admin',
        'getAllEvenements',
        {},
      );

  _i3.Future<_i12.Evenement> ajouterEvenement(_i12.Evenement evenement) =>
      caller.callServerEndpoint<_i12.Evenement>(
        'admin',
        'ajouterEvenement',
        {'evenement': evenement},
      );

  _i3.Future<_i12.Evenement> modifierEvenement(_i12.Evenement evenement) =>
      caller.callServerEndpoint<_i12.Evenement>(
        'admin',
        'modifierEvenement',
        {'evenement': evenement},
      );

  _i3.Future<void> supprimerEvenement(int id) =>
      caller.callServerEndpoint<void>(
        'admin',
        'supprimerEvenement',
        {'id': id},
      );

  _i3.Future<List<_i13.DemandeSupport>> getAllDemandesSupport() =>
      caller.callServerEndpoint<List<_i13.DemandeSupport>>(
        'admin',
        'getAllDemandesSupport',
        {},
      );

  _i3.Future<void> repondreDemande(
    int id,
    String reponse,
  ) => caller.callServerEndpoint<void>(
    'admin',
    'repondreDemande',
    {
      'id': id,
      'reponse': reponse,
    },
  );

  _i3.Future<List<_i14.OptionSupplementaire>> getAllOptions() =>
      caller.callServerEndpoint<List<_i14.OptionSupplementaire>>(
        'admin',
        'getAllOptions',
        {},
      );

  _i3.Future<_i14.OptionSupplementaire> ajouterOption(
    _i14.OptionSupplementaire option,
  ) => caller.callServerEndpoint<_i14.OptionSupplementaire>(
    'admin',
    'ajouterOption',
    {'option': option},
  );

  _i3.Future<_i14.OptionSupplementaire> modifierOption(
    _i14.OptionSupplementaire option,
  ) => caller.callServerEndpoint<_i14.OptionSupplementaire>(
    'admin',
    'modifierOption',
    {'option': option},
  );

  _i3.Future<void> supprimerOption(int id) => caller.callServerEndpoint<void>(
    'admin',
    'supprimerOption',
    {'id': id},
  );

  _i3.Future<Map<String, int>> getAdminStats() =>
      caller.callServerEndpoint<Map<String, int>>(
        'admin',
        'getAdminStats',
        {},
      );
}

/// {@category Endpoint}
class EndpointAvis extends _i2.EndpointRef {
  EndpointAvis(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'avis';
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

  _i3.Future<List<_i12.Evenement>> getEvenements() =>
      caller.callServerEndpoint<List<_i12.Evenement>>(
        'evenements',
        'getEvenements',
        {},
      );

  _i3.Future<_i12.Evenement?> getEvenementById(int id) =>
      caller.callServerEndpoint<_i12.Evenement?>(
        'evenements',
        'getEvenementById',
        {'id': id},
      );

  _i3.Future<List<_i12.Evenement>> searchEvenements(String query) =>
      caller.callServerEndpoint<List<_i12.Evenement>>(
        'evenements',
        'searchEvenements',
        {'query': query},
      );
}

/// {@category Endpoint}
class EndpointFaq extends _i2.EndpointRef {
  EndpointFaq(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'faq';

  _i3.Future<List<_i15.Faq>> getAllFaqs() =>
      caller.callServerEndpoint<List<_i15.Faq>>(
        'faq',
        'getAllFaqs',
        {},
      );
}

/// {@category Endpoint}
class EndpointFilms extends _i2.EndpointRef {
  EndpointFilms(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'films';

  _i3.Future<List<_i5.Film>> getFilms() =>
      caller.callServerEndpoint<List<_i5.Film>>(
        'films',
        'getFilms',
        {},
      );

  _i3.Future<_i5.Film?> getFilmById(int id) =>
      caller.callServerEndpoint<_i5.Film?>(
        'films',
        'getFilmById',
        {'id': id},
      );

  _i3.Future<List<_i5.Film>> searchFilms(String query) =>
      caller.callServerEndpoint<List<_i5.Film>>(
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

  _i3.Future<List<_i14.OptionSupplementaire>> getOptions() =>
      caller.callServerEndpoint<List<_i14.OptionSupplementaire>>(
        'options',
        'getOptions',
        {},
      );
}

/// {@category Endpoint}
class EndpointProfil extends _i2.EndpointRef {
  EndpointProfil(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profil';

  _i3.Future<_i10.Utilisateur?> getProfil() =>
      caller.callServerEndpoint<_i10.Utilisateur?>(
        'profil',
        'getProfil',
        {},
      );

  _i3.Future<_i10.Utilisateur?> updateProfil(
    String nom,
    String? telephone,
    DateTime? dateNaissance,
  ) => caller.callServerEndpoint<_i10.Utilisateur?>(
    'profil',
    'updateProfil',
    {
      'nom': nom,
      'telephone': telephone,
      'dateNaissance': dateNaissance,
    },
  );
}

/// {@category Endpoint}
class EndpointSalles extends _i2.EndpointRef {
  EndpointSalles(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'salles';

  _i3.Future<List<_i7.Salle>> getSalles() =>
      caller.callServerEndpoint<List<_i7.Salle>>(
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

  _i3.Future<List<_i9.Seance>> getSeancesByFilm(int filmId) =>
      caller.callServerEndpoint<List<_i9.Seance>>(
        'seances',
        'getSeancesByFilm',
        {'filmId': filmId},
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

  _i3.Future<List<_i13.DemandeSupport>> getDemandes() =>
      caller.callServerEndpoint<List<_i13.DemandeSupport>>(
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
  _i3.Future<_i16.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i16.Greeting>(
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
         _i17.Protocol(),
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
    admin = EndpointAdmin(this);
    avis = EndpointAvis(this);
    cinemas = EndpointCinemas(this);
    evenements = EndpointEvenements(this);
    faq = EndpointFaq(this);
    films = EndpointFilms(this);
    options = EndpointOptions(this);
    profil = EndpointProfil(this);
    salles = EndpointSalles(this);
    seances = EndpointSeances(this);
    support = EndpointSupport(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdmin admin;

  late final EndpointAvis avis;

  late final EndpointCinemas cinemas;

  late final EndpointEvenements evenements;

  late final EndpointFaq faq;

  late final EndpointFilms films;

  late final EndpointOptions options;

  late final EndpointProfil profil;

  late final EndpointSalles salles;

  late final EndpointSeances seances;

  late final EndpointSupport support;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'admin': admin,
    'avis': avis,
    'cinemas': cinemas,
    'evenements': evenements,
    'faq': faq,
    'films': films,
    'options': options,
    'profil': profil,
    'salles': salles,
    'seances': seances,
    'support': support,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
