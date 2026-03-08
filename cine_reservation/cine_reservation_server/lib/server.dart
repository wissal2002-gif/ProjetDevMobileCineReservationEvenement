import 'dart:io';
import 'src/services/email_service.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';

void run(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
        onAfterAccountCreated: _onAfterAccountCreated,
      ),
    ],
  );

  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    pod.webServer.addRoute(
      FlutterRoute(Directory(Uri(path: 'web/app').toFilePath())),
      '/app',
    );
  } else {
    pod.webServer.addRoute(
      StaticRoute.file(
        File(Uri(path: 'web/pages/build_flutter_app.html').toFilePath()),
      ),
      '/app/**',
    );
  }

  await pod.start();
}

void _sendRegistrationCode(
    Session session, {
      required String email,
      required UuidValue accountRequestId,
      required String verificationCode,
      required Transaction? transaction,
    }) {
  session.log('[EmailIdp] Envoi code inscription à $email');
  EmailService.sendRegistrationCode(
    toEmail: email,
    verificationCode: verificationCode,
  );
}

void _sendPasswordResetCode(
    Session session, {
      required String email,
      required UuidValue passwordResetRequestId,
      required String verificationCode,
      required Transaction? transaction,
    }) {
  session.log('[EmailIdp] Envoi code reset MDP à $email');
  EmailService.sendPasswordResetCode(
    toEmail: email,
    verificationCode: verificationCode,
  );
}

Future<void> _onAfterAccountCreated(
    Session session, {
      required String email,
      required UuidValue authUserId,
      required UuidValue emailAccountId,
      required Transaction? transaction,
    }) async {
  session.log('[CineReservation] Création utilisateur: $email');
  try {
    final utilisateur = Utilisateur(
      authUserId: authUserId.toString(),
      nom: email.split('@')[0],
      email: email,
      statut: 'actif',
      role: 'client',
      pointsFidelite: 0,
    );
    await Utilisateur.db.insertRow(session, utilisateur);
    session.log('[CineReservation] Utilisateur créé en BD: $email');
  } catch (e) {
    session.log('[CineReservation] Erreur création utilisateur: $e');
  }
}