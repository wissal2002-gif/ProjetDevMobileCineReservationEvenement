import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SiegesEndpoint extends Endpoint {
  Future<List<Siege>> getSiegesBySalle(
      Session session, int salleId) async {
    return await Siege.db.find(
      session,
      where: (t) => t.salleId.equals(salleId),
      orderBy: (t) => t.numero,
    );
  }

  // Sièges occupés pour une séance
  Future<List<int>> getSiegesReservesBySeance(
      Session session, int seanceId) async {
    final reservations = await Reservation.db.find(
      session,
      where: (r) =>
      r.seanceId.equals(seanceId) &
      r.statut.notEquals('annule') &
      r.statut.notEquals('rembourse'),
    );

    if (reservations.isEmpty) return [];

    // Filtrer les "en_attente" expirées (+15 min)
    final now = DateTime.now().toUtc();
    final reservationsValides = reservations.where((r) {
      if (r.statut == 'en_attente') {
        final diff = now.difference(r.dateReservation);
        return diff.inMinutes < 15;
      }
      return true;
    }).toList();

    if (reservationsValides.isEmpty) return [];

    final reservationIds =
    reservationsValides.map((r) => r.id!).toSet();

    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (rs) => rs.reservationId.inSet(reservationIds),
    );

    return siegeRelations.map((rs) => rs.siegeId).toList();
  }

  // Sièges occupés pour un événement
  // — filtre les en_attente expirées comme pour les séances
  Future<List<int>> getSiegesReservesByEvenement(
      Session session, int evenementId) async {
    final reservations = await Reservation.db.find(
      session,
      where: (r) =>
      r.evenementId.equals(evenementId) &
      r.statut.notEquals('annule') &
      r.statut.notEquals('rembourse'),
    );

    if (reservations.isEmpty) return [];

    // Filtrer les "en_attente" expirées (+15 min)
    final now = DateTime.now().toUtc();
    final reservationsValides = reservations.where((r) {
      if (r.statut == 'en_attente') {
        final diff = now.difference(r.dateReservation);
        return diff.inMinutes < 15;
      }
      return true; // confirmee → toujours occupé
    }).toList();

    if (reservationsValides.isEmpty) return [];

    final reservationIds =
    reservationsValides.map((r) => r.id!).toSet();

    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (rs) => rs.reservationId.inSet(reservationIds),
    );

    return siegeRelations.map((rs) => rs.siegeId).toList();
  }
}