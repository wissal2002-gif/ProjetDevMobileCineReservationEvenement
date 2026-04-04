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

  // Récupérer les sièges occupés pour une séance
  Future<List<int>> getSiegesReservesBySeance(
      Session session, int seanceId) async {
    // 1. Récupérer toutes les réservations non annulées pour cette séance
    final reservations = await Reservation.db.find(
      session,
      where: (r) =>
      r.seanceId.equals(seanceId) &
      r.statut.notEquals('annule') &
      r.statut.notEquals('rembourse'),
    );

    if (reservations.isEmpty) return [];

    // 2. ✅ FIX : filtrer les "en_attente" expirées (+15 min)
    // Les "confirmee" passent toujours → siège bien rouge
    final now = DateTime.now().toUtc();
    final reservationsValides = reservations.where((r) {
      if (r.statut == 'en_attente') {
        final diff = now.difference(r.dateReservation);
        return diff.inMinutes < 15; // garder seulement les récentes
      }
      return true; // confirmee, remboursement_demande → toujours occupé
    }).toList();

    if (reservationsValides.isEmpty) return [];

    final reservationIds =
    reservationsValides.map((r) => r.id!).toSet();

    // 3. Récupérer les sièges liés à ces réservations
    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (rs) => rs.reservationId.inSet(reservationIds),
    );

    return siegeRelations.map((rs) => rs.siegeId).toList();
  }

  // Récupérer les sièges occupés pour un événement
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

    final reservationIds = reservations.map((r) => r.id!).toSet();

    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (rs) => rs.reservationId.inSet(reservationIds),
    );

    return siegeRelations.map((rs) => rs.siegeId).toList();
  }
}