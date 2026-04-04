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
    return await client.sieges.getSiegesReservesByEvenement(evenementId);
  }

  // ─── RESERVATIONS ─────────────────────────────────────

  // ✅ FIX : retourne Reservation? (nullable) au lieu de throw quand null
  // Cela permet à paiement_page.dart de détecter un siège occupé
  // et d'afficher un message propre au lieu d'un crash 500
  Future<Reservation?> creerReservation({
    int? seanceId,
    int? evenementId,
    required double montantTotal,
    required List<int> siegeIds,
    List<String>? siegeTarifs,
    List<double>? siegePrix,
    List<int>? optionsIds,
    int? codePromoId,
  }) async {
    return await client.reservation.creerReservation(
      seanceId: seanceId,
      evenementId: evenementId,
      montantTotal: montantTotal,
      siegeIds: siegeIds,
      siegeTarifs: siegeTarifs,
      siegePrix: siegePrix,
      optionsIds: optionsIds,
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

  Future<List<Billet>> getBilletsByReservation(int reservationId) async {
    return await client.billet.getBilletsByReservation(reservationId);
  }

  Future<bool> validerBillet(String qrCode) async {
    return await client.billet.validerBillet(qrCode);
  }

  // ─── OPTIONS ──────────────────────────────────────────
  Future<List<OptionSupplementaire>> getOptions() async {
    return await client.options.getOptions();
  }

  Future<List<OptionSupplementaire>> getOptionsByCinema(int cinemaId) async {
    return await client.options.getOptionsByCinema(cinemaId);
  }
}