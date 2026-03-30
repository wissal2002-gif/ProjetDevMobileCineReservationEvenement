import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class BilletEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Utilisateur?> _getUser(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;
    return await Utilisateur.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.userIdentifier),
    );
  }

  Future<List<Billet>> getMesBillets(Session session) async {
    final user = await _getUser(session);
    if (user == null || user.id == null) return [];

    final reservations = await Reservation.db.find(
      session,
      where: (r) => r.utilisateurId.equals(user.id!),
    );
    if (reservations.isEmpty) return [];

    final reservationIds = reservations.map((r) => r.id!).toSet();
    return await Billet.db.find(
      session,
      where: (b) => b.reservationId.inSet(reservationIds),
      orderBy: (b) => b.dateEmission,
      orderDescending: true,
    );
  }

  Future<List<Billet>> getBilletsByReservation(Session session, int reservationId) async {
    final user = await _getUser(session);
    if (user == null) return [];

    final reservation = await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != user.id) return [];

    return await Billet.db.find(
      session,
      where: (b) => b.reservationId.equals(reservationId),
    );
  }

  Future<bool> validerBillet(Session session, String qrCode) async {
    final billets = await Billet.db.find(
      session,
      where: (b) => b.qrCode.equals(qrCode),
    );
    if (billets.isEmpty) return false;
    final billet = billets.first;
    if (billet.estValide != true) return false;
    billet.estValide = false;
    billet.dateValidation = DateTime.now().toUtc();
    await Billet.db.updateRow(session, billet);
    return true;
  }
}