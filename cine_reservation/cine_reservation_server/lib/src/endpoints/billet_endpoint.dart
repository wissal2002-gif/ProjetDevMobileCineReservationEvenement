import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class BilletEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Billet>> getMesBillets(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
    final utilisateurId = int.tryParse(authInfo.userIdentifier) ?? 0;
    final reservations = await Reservation.db.find(
      session,
      where: (r) => r.utilisateurId.equals(utilisateurId),
    );
    if (reservations.isEmpty) return [];
    final ids = reservations.map((r) => r.id!).toSet();
    return await Billet.db.find(
      session,
      where: (b) => b.reservationId.inSet(ids),
      orderBy: (b) => b.dateEmission,
      orderDescending: true,
    );
  }

  Future<List<Billet>> getBilletsByReservation(Session session, int reservationId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
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
