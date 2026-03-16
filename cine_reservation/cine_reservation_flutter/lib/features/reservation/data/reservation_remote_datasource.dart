import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

class ReservationRemoteDatasource {
  // ─── SIEGES ───
  Future<List<Siege>> getSiegesBySalle(int salleId) async {
    return await client.sieges.getSiegesBySalle(salleId);
  }

  Future<List<int>> getSiegesReservesBySeance(int seanceId) async {
    return await client.sieges.getSiegesReservesBySeance(seanceId);
  }

  Future<List<int>> getSiegesReservesByEvenement(int evenementId) async {
    return await client.sieges.getSiegesReservesByEvenement(evenementId);
  }

  // ─── RESERVATIONS ───
  Future<Reservation?> creerReservation({
    int? seanceId,
    int? evenementId,
    String? typeReservation,
    double montantTotal = 0.0,
    int? codePromoId,
  }) async {
    return await client.reservation.creerReservation(
      seanceId: seanceId,
      evenementId: evenementId,
      typeReservation: typeReservation,
      montantTotal: montantTotal,
      codePromoId: codePromoId,
    );
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

  // ─── PAIEMENTS ───
  Future<Paiement?> effectuerPaiement(
      int reservationId, double montant, String methode) async {
    return await client.paiement.effectuerPaiement(reservationId, montant, methode);
  }

  // ─── BILLETS ───
  Future<List<Billet>> getMesBillets() async {
    return await client.billet.getMesBillets();
  }

  Future<List<Billet>> getBilletsByReservation(int reservationId) async {
    return await client.billet.getBilletsByReservation(reservationId);
  }

  Future<bool> validerBillet(String qrCode) async {
    return await client.billet.validerBillet(qrCode);
  }
  // OPTIONS
  Future<List<OptionSupplementaire>> getOptions() async {
    return await client.options.getOptions();
  }
}
