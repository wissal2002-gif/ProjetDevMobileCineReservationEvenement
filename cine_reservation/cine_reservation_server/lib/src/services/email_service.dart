import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static const String _gmailUser = 'khalid.wissal@etu.uae.ac.ma';
  static const String _gmailPassword = 'xxct wqbk xzwi scbs';
  static const String _appName = 'CinéEvent';

  static SmtpServer get _smtpServer =>
      gmail(_gmailUser, _gmailPassword.replaceAll(' ', ''));

  // ─── Email vérification inscription ─────────────────────────────────────
  static Future<void> sendRegistrationCode({
    required String toEmail,
    required String verificationCode,
  }) async {
    final message = Message()
      ..from = Address(_gmailUser, _appName)
      ..recipients.add(toEmail)
      ..subject = '🎬 $_appName — Code de vérification'
      ..html = '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;background:#0D0A08;color:#fff;padding:40px;border-radius:12px;">
          <h1 style="color:#8B7355;text-align:center;">🎬 $_appName</h1>
          <h2 style="text-align:center;">Vérification de votre compte</h2>
          <p style="color:#9E9E8E;">Bienvenue ! Pour finaliser votre inscription :</p>
          <div style="background:#2C1810;padding:20px;border-radius:8px;text-align:center;margin:30px 0;">
            <span style="font-size:36px;font-weight:bold;color:#8B7355;letter-spacing:8px;">$verificationCode</span>
          </div>
          <p style="color:#9E9E8E;font-size:14px;">Ce code expire dans 24 heures.</p>
        </div>
      ''';
    try {
      await send(message, _smtpServer);
    } catch (e) {
      print('Erreur email inscription: $e');
    }
  }

  // ─── Email réinitialisation mot de passe ─────────────────────────────────
  static Future<void> sendPasswordResetCode({
    required String toEmail,
    required String verificationCode,
  }) async {
    final message = Message()
      ..from = Address(_gmailUser, _appName)
      ..recipients.add(toEmail)
      ..subject = '🔑 $_appName — Réinitialisation de mot de passe'
      ..html = '''
        <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;background:#0D0A08;color:#fff;padding:40px;border-radius:12px;">
          <h1 style="color:#8B7355;text-align:center;">🎬 $_appName</h1>
          <h2 style="text-align:center;">Réinitialisation de mot de passe</h2>
          <p style="color:#9E9E8E;">Utilisez ce code pour réinitialiser votre mot de passe :</p>
          <div style="background:#2C1810;padding:20px;border-radius:8px;text-align:center;margin:30px 0;">
            <span style="font-size:36px;font-weight:bold;color:#8B7355;letter-spacing:8px;">$verificationCode</span>
          </div>
          <p style="color:#9E9E8E;font-size:14px;">Ce code expire dans 1 heure.</p>
        </div>
      ''';
    try {
      await send(message, _smtpServer);
    } catch (e) {
      print('Erreur email reset: $e');
    }
  }

  // ─── Email confirmation réservation + billet ──────────────────────────────
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
      ..subject = '✅ $_appName — Réservation confirmée — $titreFilm'
      ..html = '''
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"></head>
<body style="margin:0;padding:0;background:#f4f4f4;font-family:Arial,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f4f4;padding:30px 0;">
  <tr>
    <td align="center">
      <table width="600" cellpadding="0" cellspacing="0" style="background:#0D0A08;border-radius:16px;overflow:hidden;">

        <!-- Header -->
        <tr>
          <td style="background:linear-gradient(135deg,#2C1810,#1A1410);padding:30px;text-align:center;">
            <h1 style="color:#8B7355;margin:0;font-size:28px;letter-spacing:2px;">🎬 CinéEvent</h1>
            <p style="color:#9E9E8E;margin:8px 0 0;font-size:13px;">Votre billet numérique</p>
          </td>
        </tr>

        <!-- Succès -->
        <tr>
          <td style="padding:30px;text-align:center;">
            <div style="width:70px;height:70px;background:rgba(76,175,80,0.15);border-radius:50%;margin:0 auto 16px;display:flex;align-items:center;justify-content:center;">
              <span style="font-size:40px;">✅</span>
            </div>
            <h2 style="color:#ffffff;margin:0 0 8px;font-size:22px;">Réservation Confirmée !</h2>
            <p style="color:#9E9E8E;margin:0;">Bonjour <strong style="color:#8B7355;">$nomUtilisateur</strong>, votre paiement a été accepté.</p>
          </td>
        </tr>

        <!-- Billet -->
        <tr>
          <td style="padding:0 24px 24px;">
            <table width="100%" cellpadding="0" cellspacing="0"
              style="border:2px solid #8B7355;border-radius:12px;overflow:hidden;">
              <tr>
                <!-- Info film -->
                <td style="background:#1A1410;padding:24px;width:65%;">
                  <p style="color:#8B7355;font-size:10px;letter-spacing:2px;margin:0 0 4px;">FILM / ÉVÉNEMENT</p>
                  <h3 style="color:#ffffff;margin:0 0 16px;font-size:20px;">$titreFilm</h3>

                  <table cellpadding="0" cellspacing="0">
                    <tr>
                      <td style="padding-right:24px;">
                        <p style="color:#8B7355;font-size:9px;letter-spacing:1px;margin:0;">📅 DATE & HEURE</p>
                        <p style="color:#ffffff;font-weight:bold;margin:4px 0 0;font-size:13px;">$dateSeance</p>
                      </td>
                      <td>
                        <p style="color:#8B7355;font-size:9px;letter-spacing:1px;margin:0;">🏛️ LIEU</p>
                        <p style="color:#ffffff;font-weight:bold;margin:4px 0 0;font-size:13px;">$cinema</p>
                      </td>
                    </tr>
                  </table>

                  <hr style="border:none;border-top:1px solid #2C2420;margin:16px 0;">

                  <table cellpadding="0" cellspacing="0">
                    <tr>
                      <td style="padding-right:24px;">
                        <p style="color:#8B7355;font-size:9px;letter-spacing:1px;margin:0;">💰 MONTANT</p>
                        <p style="color:#ffffff;font-weight:bold;margin:4px 0 0;font-size:15px;">${montant.toStringAsFixed(2)} MAD</p>
                      </td>
                      <td style="padding-right:24px;">
                        <p style="color:#8B7355;font-size:9px;letter-spacing:1px;margin:0;">💳 PAIEMENT</p>
                        <p style="color:#ffffff;font-weight:bold;margin:4px 0 0;font-size:13px;">${methodePaiement.toUpperCase()}</p>
                      </td>
                      <td>
                        <p style="color:#8B7355;font-size:9px;letter-spacing:1px;margin:0;">🔖 RÉFÉRENCE</p>
                        <p style="color:#8B7355;font-weight:bold;margin:4px 0 0;font-size:13px;">$referenceReservation</p>
                      </td>
                    </tr>
                  </table>
                </td>

                <!-- QR Code côté droit -->
                <td style="background:#F5E6C8;padding:20px;text-align:center;vertical-align:middle;">
                  <p style="color:#4A3728;font-size:9px;font-weight:bold;letter-spacing:1px;margin:0 0 10px;">SCAN QR</p>
                  <div style="background:#fff;padding:8px;border-radius:6px;display:inline-block;">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=90x90&data=${Uri.encodeComponent(qrCode)}&color=1A1410&bgcolor=FFFFFF"
                         width="90" height="90" alt="QR Code" style="display:block;">
                  </div>
                  <p style="color:#4A3728;font-size:8px;font-weight:bold;margin:10px 0 0;word-break:break-all;">
                    ${qrCode.length > 20 ? qrCode.substring(0, 20) : qrCode}
                  </p>
                  <p style="color:#4A3728;font-size:11px;font-weight:bold;letter-spacing:2px;margin:10px 0 0;">ADMIT ONE</p>
                </td>
              </tr>
            </table>
          </td>
        </tr>

        <!-- Instructions -->
        <tr>
          <td style="padding:0 24px 24px;">
            <table width="100%" cellpadding="12" style="background:#1A1410;border-radius:10px;border:1px solid #2C2420;">
              <tr>
                <td>
                  <p style="color:#8B7355;font-size:11px;font-weight:bold;letter-spacing:1px;margin:0 0 8px;">📋 INSTRUCTIONS</p>
                  <ul style="color:#9E9E8E;font-size:12px;margin:0;padding-left:20px;line-height:1.8;">
                    <li>Présentez ce billet (QR code) à l'entrée</li>
                    <li>Arrivez 15 minutes avant la séance</li>
                    <li>Ce billet est personnel et non transférable</li>
                    <li>Retrouvez vos billets dans l'app CinéEvent</li>
                  </ul>
                </td>
              </tr>
            </table>
          </td>
        </tr>

        <!-- Footer -->
        <tr>
          <td style="background:#1A1410;padding:20px;text-align:center;border-top:1px solid #2C2420;">
            <p style="color:#9E9E8E;font-size:11px;margin:0;">© 2026 CinéEvent — ENSA Tétouan</p>
            <p style="color:#9E9E8E;font-size:11px;margin:6px 0 0;">Merci de votre confiance ! 🎬</p>
          </td>
        </tr>

      </table>
    </td>
  </tr>
</table>
</body>
</html>
      ''';

    try {
      await send(message, _smtpServer);
      print('Email confirmation envoyé à $toEmail');
    } catch (e) {
      print('Erreur envoi email confirmation: $e');
    }
  }
}