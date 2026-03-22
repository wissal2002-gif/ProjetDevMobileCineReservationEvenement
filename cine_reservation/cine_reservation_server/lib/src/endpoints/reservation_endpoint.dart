import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ReservationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Reservation?> creerReservation(
      Session session, {
        int? seanceId,
        int? evenementId,
        String? typeReservation,
        double montantTotal = 0.0,
        int? codePromoId,
      }) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;
    final reservation = Reservation(
      utilisateurId: utilisateurId,
      seanceId: seanceId,
      evenementId: evenementId,
      typeReservation: typeReservation ?? 'seance',
      dateReservation: DateTime.now().toUtc(),
      montantTotal: montantTotal,
      montantApresReduction: montantTotal,
      statut: 'en_attente',
      codePromoId: codePromoId,
    );
    return await Reservation.db.insertRow(session, reservation);
  }

  Future<List<Reservation>> getMesReservations(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;
    return await Reservation.db.find(
      session,
      where: (r) => r.utilisateurId.equals(utilisateurId),
      orderBy: (r) => r.dateReservation,
      orderDescending: true,
    );
  }

  Future<bool> annulerReservation(Session session, int reservationId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;
    final reservation = await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != utilisateurId) return false;
    reservation.statut = 'annule';
    await Reservation.db.updateRow(session, reservation);
    return true;
  }

  Future<CodePromo?> validerCodePromo(Session session, String code) async {
    final promos = await CodePromo.db.find(
      session,
      where: (c) => c.code.equals(code),
    );
    if (promos.isEmpty) return null;
    final promo = promos.first;
    if (promo.dateExpiration != null &&
        promo.dateExpiration!.isBefore(DateTime.now().toUtc())) {
      return null;
    }
    return promo;
  }
}
