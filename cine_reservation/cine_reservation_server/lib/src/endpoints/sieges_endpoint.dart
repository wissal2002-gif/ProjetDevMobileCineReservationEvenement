import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SiegesEndpoint extends Endpoint {
  Future<List<Siege>> getSiegesBySalle(Session session, int salleId) async {
    return await Siege.db.find(
      session,
      where: (t) => t.salleId.equals(salleId),
      orderBy: (t) => t.numero,
    );
  }

  Future<List<int>> getSiegesReservesBySeance(Session session, int seanceId) async {
    final reservations = await Reservation.db.find(
      session,
      where: (r) => r.seanceId.equals(seanceId) & r.statut.notEquals('annule'),
    );
    if (reservations.isEmpty) return [];
    final ids = reservations.map((r) => r.id!).toSet();
    final billets = await Billet.db.find(
      session,
      where: (b) => b.reservationId.inSet(ids),
    );
    return billets.where((b) => b.siegeId != null).map((b) => b.siegeId!).toList();
  }

  Future<List<int>> getSiegesReservesByEvenement(Session session, int evenementId) async {
    final reservations = await Reservation.db.find(
      session,
      where: (r) => r.evenementId.equals(evenementId) & r.statut.notEquals('annule'),
    );
    if (reservations.isEmpty) return [];
    final ids = reservations.map((r) => r.id!).toSet();
    final billets = await Billet.db.find(
      session,
      where: (b) => b.reservationId.inSet(ids),
    );
    return billets.where((b) => b.siegeId != null).map((b) => b.siegeId!).toList();
  }
}
