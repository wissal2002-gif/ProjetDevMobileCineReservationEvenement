import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../main.dart';

class ReservationRemoteDatasource {
  // ─── SIEGES ───────────────────────────────────────────
  Future<List<Siege>> getSiegesBySalle(int salleId) async {
    return await client.sieges.getSiegesBySalle(salleId);
  }

  Future<List<int>> getSiegesReservesBySeance(int seanceId) async {
    return await client.sieges.getSiegesReservesBySeance(seanceId);
  }

  Future<List<int>> getSiegesReservesByEvenement(int evenementId) async {
    return await client.sieges
        .getSiegesReservesByEvenement(evenementId);
  }

  // ─── RESERVATIONS ─────────────────────────────────────
  Future<Reservation> creerReservation({
    int? seanceId,
    int? evenementId,
    required double montantTotal,
    required List<int> siegeIds,
    List<int>? optionsIds,
    int? codePromoId,
  }) async {
    final result = await client.reservation.creerReservation(
      seanceId: seanceId,
      evenementId: evenementId,
      montantTotal: montantTotal,
      siegeIds: siegeIds,
      optionsIds: optionsIds,     // ✅ FIX 1
      codePromoId: codePromoId,   // ✅ FIX 3
    );
    if (result == null) {
      throw Exception('Erreur lors de la création de la réservation');
    }
    return result;
  }

  Future<List<Reservation>> getMesReservations() async {
    return await client.reservation.getMesReservations();
  }

  Future<bool> annulerReservation(int reservationId) async {
    return await client.reservation.annulerReservation(reservationId);
  }

  Future<CodePromo?> validerCodePromo(String code) async {
    return await client.reservation.validerCodePromo(code);
  }

  // ─── PAIEMENTS ────────────────────────────────────────
  Future<Paiement?> effectuerPaiement({
    required int reservationId,
    required double montant,
    required String methode,
  }) async {
    return await client.paiement.effectuerPaiement(
      reservationId,
      montant,
      methode,
    );
  }

  // ─── BILLETS ──────────────────────────────────────────
  Future<List<Billet>> getMesBillets() async {
    return await client.billet.getMesBillets();
  }

  Future<List<Billet>> getBilletsByReservation(
      int reservationId) async {
    return await client.billet
        .getBilletsByReservation(reservationId);
  }

  Future<bool> validerBillet(String qrCode) async {
    return await client.billet.validerBillet(qrCode);
  }

  // ─── OPTIONS ──────────────────────────────────────────
  Future<List<OptionSupplementaire>> getOptions() async {
    return await client.options.getOptions();
  }
}