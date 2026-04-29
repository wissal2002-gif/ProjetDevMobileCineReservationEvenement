import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static const String _gmailUser = 'Votre-email';
'  static const String _gmailPassword = ';
  static const String _appName = 'CineReservation';

  static SmtpServer get _smtpServer => gmail(_gmailUser, _gmailPassword.replaceAll(' ', ''));

  // ─── Envoi email vérification inscription ───
  static Future<void> sendRegistrationCode({
    required String toEmail,
    required String verificationCode,
  }) async {
    final message = Message()
      ..from = Address(_gmailUser, _appName)
      ..recipients.add(toEmail)
      ..subject = '🎬 $_appName — Code de vérification'
      ..html = '''
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #0D0A08; color: #ffffff; padding: 40px; border-radius: 12px;">
          <h1 style="color: #8B7355; text-align: center;">🎬 $_appName</h1>
          <h2 style="text-align: center;">Vérification de votre compte</h2>
          <p style="color: #9E9E8E;">Bienvenue ! Pour finaliser votre inscription, utilisez le code suivant :</p>
          <div style="background-color: #2C1810; padding: 20px; border-radius: 8px; text-align: center; margin: 30px 0;">
            <span style="font-size: 36px; font-weight: bold; color: #8B7355; letter-spacing: 8px;">$verificationCode</span>
          </div>
          <p style="color: #9E9E8E; font-size: 14px;">Ce code expire dans 24 heures.</p>
          <p style="color: #9E9E8E; font-size: 12px; text-align: center; margin-top: 40px;">Si vous n'avez pas créé de compte, ignorez cet email.</p>
        </div>
      ''';

    try {
      await send(message, _smtpServer);
    } catch (e) {
      print('Erreur envoi email inscription: $e');
    }
  }

  // ─── Envoi email réinitialisation mot de passe ───
  static Future<void> sendPasswordResetCode({
    required String toEmail,
    required String verificationCode,
  }) async {
    final message = Message()
      ..from = Address(_gmailUser, _appName)
      ..recipients.add(toEmail)
      ..subject = '🔐 $_appName — Réinitialisation de mot de passe'
      ..html = '''
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #0D0A08; color: #ffffff; padding: 40px; border-radius: 12px;">
          <h1 style="color: #8B7355; text-align: center;">🎬 $_appName</h1>
          <h2 style="text-align: center;">Réinitialisation de mot de passe</h2>
          <p style="color: #9E9E8E;">Vous avez demandé à réinitialiser votre mot de passe. Utilisez ce code :</p>
          <div style="background-color: #2C1810; padding: 20px; border-radius: 8px; text-align: center; margin: 30px 0;">
            <span style="font-size: 36px; font-weight: bold; color: #8B7355; letter-spacing: 8px;">$verificationCode</span>
          </div>
          <p style="color: #9E9E8E; font-size: 14px;">Ce code expire dans 1 heure.</p>
          <p style="color: #9E9E8E; font-size: 12px; text-align: center; margin-top: 40px;">Si vous n'avez pas demandé cette réinitialisation, ignorez cet email.</p>
        </div>
      ''';

    try {
      await send(message, _smtpServer);
    } catch (e) {
      print('Erreur envoi email reset: $e');
    }
  }

  // ─── Envoi email confirmation réservation ───
  static Future<void> sendReservationConfirmation({
    required String toEmail,
    required String nomUtilisateur,
    required String titreFilm,
    required String dateSeance,
    required String cinema,
    required double montant,
    required String qrCode,
    required String referenceReservation,
    required String methodePaiement,
  }) async {
    final message = Message()
      ..from = Address(_gmailUser, _appName)
      ..recipients.add(toEmail)
      ..subject = '✅ $_appName — Réservation confirmée'
      ..html = '''
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #0D0A08; color: #ffffff; padding: 40px; border-radius: 12px;">
          <h1 style="color: #8B7355; text-align: center;">🎬 $_appName</h1>
          <h2 style="color: #ffffff; text-align: center;">Réservation confirmée ✅</h2>
          <p style="color: #9E9E8E;">Bonjour $nomUtilisateur,</p>
          <p style="color: #9E9E8E;">Votre réservation a été confirmée avec succès !</p>
          <div style="background-color: #2C1810; padding: 20px; border-radius: 8px; margin: 30px 0;">
            <p style="color: #8B7355; font-weight: bold; font-size: 18px;">🎥 $titreFilm</p>
            <p style="color: #9E9E8E;">📅 $dateSeance</p>
            <p style="color: #9E9E8E;">🏛️ $cinema</p>
            <p style="color: #8B7355; font-weight: bold;">💰 ${montant.toStringAsFixed(2)} MAD</p>
            <p style="color: #9E9E8E; font-size: 12px; margin-top: 10px;">Référence : $referenceReservation</p>
            <p style="color: #9E9E8E; font-size: 12px;">Paiement : ${methodePaiement.toUpperCase()}</p>
          </div>
          <div style="text-align: center; margin-top: 20px;">
             <p style="color: #ffffff; font-size: 14px;">Scannez ce QR Code à l'entrée :</p>
             <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$qrCode" alt="QR Code" style="border: 5px solid #fff; border-radius: 8px;"/>
          </div>
          <p style="color: #9E9E8E; font-size: 12px; text-align: center; margin-top: 40px;">Merci de votre confiance !</p>
        </div>
      ''';

    try {
      await send(message, _smtpServer);
    } catch (e) {
      print('Erreur envoi email confirmation: $e');
    }
  }

  // ─── Envoi email remboursement réservation ───
  static Future<void> sendRefundNotification({
    required String toEmail,
    required String nomUtilisateur,
    required String titre,
    required double montantRembourse,
    String? raison,
  }) async {
    final message = Message()
      ..from = Address(_gmailUser, _appName)
      ..recipients.add(toEmail)
      ..subject = '💰 $_appName — Remboursement effectué'
      ..html = '''
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #0D0A08; color: #ffffff; padding: 40px; border-radius: 12px;">
          <h1 style="color: #8B7355; text-align: center;">🎬 $_appName</h1>
          <h2 style="color: #ffffff; text-align: center;">Remboursement effectué 💰</h2>
          <p style="color: #9E9E8E;">Bonjour $nomUtilisateur,</p>
          <p style="color: #9E9E8E;">Nous vous informons qu'un remboursement a été traité pour votre réservation concernant :</p>
          <div style="background-color: #2C1810; padding: 20px; border-radius: 8px; margin: 30px 0;">
            <p style="color: #8B7355; font-weight: bold; font-size: 18px;">🎫 $titre</p>
            <p style="color: #ffffff; font-size: 24px; font-weight: bold; margin: 15px 0;">Montant remboursé : ${montantRembourse.toStringAsFixed(2)} MAD</p>
            ${raison != null ? '<p style="color: #9E9E8E; font-style: italic;">Raison : $raison</p>' : ''}
          </div>
          <p style="color: #9E9E8E;">Le montant devrait apparaître sur votre compte dans les prochains jours selon les délais de votre banque.</p>
          <p style="color: #9E9E8E; font-size: 12px; text-align: center; margin-top: 40px;">L'équipe $_appName reste à votre disposition.</p>
        </div>
      ''';

    try {
      await send(message, _smtpServer);
    } catch (e) {
      print('Erreur envoi email remboursement: $e');
    }
  }
}
