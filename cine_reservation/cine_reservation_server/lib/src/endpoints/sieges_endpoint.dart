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

  // Récupérer les sièges occupés pour une séance (inclut les réservations en attente)
  Future<List<int>> getSiegesReservesBySeance(Session session, int seanceId) async {
    // 1. Récupérer les réservations pour cette séance (non annulées)
    final reservations = await Reservation.db.find(
      session,
      where: (r) =>
      r.seanceId.equals(seanceId) &
      r.statut.notEquals('annule') &
      r.statut.notEquals('rembourse'),
    );

    if (reservations.isEmpty) return [];

    final reservationIds = reservations.map((r) => r.id!).toSet();

    // 2. Récupérer les sièges directement depuis reservation_sieges
    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (rs) => rs.reservationId.inSet(reservationIds),
    );

    return siegeRelations.map((rs) => rs.siegeId).toList();
  }

  // Récupérer les sièges occupés pour un événement
  Future<List<int>> getSiegesReservesByEvenement(Session session, int evenementId) async {
    final reservations = await Reservation.db.find(
      session,
      where: (r) =>
      r.evenementId.equals(evenementId) &
      r.statut.notEquals('annule') &
      r.statut.notEquals('rembourse'),
    );

    if (reservations.isEmpty) return [];

    final reservationIds = reservations.map((r) => r.id!).toSet();

    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (rs) => rs.reservationId.inSet(reservationIds),
    );

    return siegeRelations.map((rs) => rs.siegeId).toList();
  }
}