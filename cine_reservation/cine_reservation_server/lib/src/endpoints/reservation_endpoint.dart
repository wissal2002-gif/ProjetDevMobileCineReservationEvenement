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
        required List<int> siegeIds,
        List<int>? optionsIds,
      }) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final user = await Utilisateur.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.userIdentifier),
    );
    if (user == null || user.id == null) return null;

    final isEvenement = evenementId != null && seanceId == null;
    final validSiegeIds = siegeIds.where((id) => id > 0).toList();

    // ✅ FIX 4 : Gestion intelligente des sièges bloqués
    if (!isEvenement && validSiegeIds.isNotEmpty) {
      final siegeIdsSet = validSiegeIds.toSet();

      final reservationsExistantes = await ReservationSiege.db.find(
        session,
        where: (t) => t.siegeId.inSet(siegeIdsSet),
      );

      for (var rs in reservationsExistantes) {
        final reservationExistante = await Reservation.db.findById(
          session,
          rs.reservationId,
        );
        if (reservationExistante == null) continue;

        // Réservation "en_attente" du MÊME utilisateur → annuler
        if (reservationExistante.statut == 'en_attente' &&
            reservationExistante.utilisateurId == user.id) {
          reservationExistante.statut = 'annule';
          await Reservation.db.updateRow(session, reservationExistante);
          continue;
        }

        // Réservation "en_attente" expirée (+15 min) → annuler
        if (reservationExistante.statut == 'en_attente') {
          final diff = DateTime.now()
              .toUtc()
              .difference(reservationExistante.dateReservation);
          if (diff.inMinutes >= 15) {
            reservationExistante.statut = 'annule';
            await Reservation.db.updateRow(session, reservationExistante);
            continue;
          }
        }

        // Réservation confirmée d'un autre utilisateur → erreur
        if (reservationExistante.statut != 'annule' &&
            reservationExistante.statut != 'rembourse' &&
            reservationExistante.statut != 'en_attente') {
          throw Exception('Le siège ${rs.siegeId} est déjà réservé');
        }
      }
    }

    // Récupérer le cinemaId si c'est une séance
    int? cinemaId;
    if (seanceId != null) {
      final seance = await Seance.db.findById(session, seanceId);
      if (seance != null) {
        final salle = await Salle.db.findById(session, seance.salleId);
        cinemaId = salle?.cinemaId;
      }
    }

    // ✅ FIX 3 : Valider le code promo et calculer réduction
    double montantApresReduction = montantTotal;
    if (codePromoId != null) {
      final promo = await CodePromo.db.findById(session, codePromoId);
      if (promo != null && promo.actif == true) {
        if (promo.typeReduction == 'pourcentage') {
          montantApresReduction =
              montantTotal * (1 - promo.reduction / 100);
        } else {
          montantApresReduction =
              (montantTotal - promo.reduction).clamp(0, double.infinity);
        }
      }
    }

    // Créer la réservation
    final reservation = Reservation(
      utilisateurId: user.id!,
      seanceId: seanceId,
      evenementId: evenementId,
      cinemaId: cinemaId,
      typeReservation: typeReservation ??
          (seanceId != null ? 'cinema' : 'evenement'),
      dateReservation: DateTime.now().toUtc(),
      montantTotal: montantTotal,
      montantApresReduction: montantApresReduction,
      statut: 'en_attente',
      codePromoId: codePromoId,
    );

    final newReservation =
    await Reservation.db.insertRow(session, reservation);

    // Ajouter les sièges
    if (!isEvenement && validSiegeIds.isNotEmpty) {
      for (var siegeId in validSiegeIds) {
        final reservationSiege = ReservationSiege(
          reservationId: newReservation.id!,
          siegeId: siegeId,
        );
        await ReservationSiege.db.insertRow(session, reservationSiege);
      }
    }

    // ✅ FIX 1 : Enregistrer les options avec prix unitaire
    if (optionsIds != null && optionsIds.isNotEmpty) {
      // Grouper les optionsIds par id pour calculer les quantités
      final Map<int, int> quantites = {};
      for (var optionId in optionsIds) {
        quantites[optionId] = (quantites[optionId] ?? 0) + 1;
      }

      for (var entry in quantites.entries) {
        final option =
        await OptionSupplementaire.db.findById(session, entry.key);
        if (option == null) continue;
        final reservationOption = ReservationOption(
          reservationId: newReservation.id!,
          optionId: entry.key,
          quantite: entry.value,
          prixUnitaire: option.prix,
        );
        await ReservationOption.db.insertRow(session, reservationOption);
      }
    }

    // ✅ FIX 3 : Incrémenter utilisationsActuelles du code promo
    if (codePromoId != null) {
      final promo = await CodePromo.db.findById(session, codePromoId);
      if (promo != null) {
        promo.utilisationsActuelles =
            (promo.utilisationsActuelles ?? 0) + 1;
        await CodePromo.db.updateRow(session, promo);
      }
    }

    return newReservation;
  }

  // Récupérer les sièges occupés pour une séance
  Future<List<int>> getSiegesReservesBySeance(
      Session session, int seanceId) async {
    final reservations = await Reservation.db.find(
      session,
      where: (t) =>
      t.seanceId.equals(seanceId) &
      t.statut.notEquals('annule') &
      t.statut.notEquals('rembourse'),
    );

    if (reservations.isEmpty) return [];

    // Exclure les "en_attente" expirées (+15 min)
    final now = DateTime.now().toUtc();
    final reservationsFiltrees = reservations.where((r) {
      if (r.statut == 'en_attente') {
        final diff = now.difference(r.dateReservation);
        return diff.inMinutes < 15;
      }
      return true;
    }).toList();

    if (reservationsFiltrees.isEmpty) return [];

    final reservationIdsFiltreesSet =
    reservationsFiltrees.map((r) => r.id!).toSet();

    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (t) => t.reservationId.inSet(reservationIdsFiltreesSet),
    );

    return siegeRelations.map((r) => r.siegeId).toList();
  }

  // Récupérer les sièges occupés pour un événement
  Future<List<int>> getSiegesReservesByEvenement(
      Session session, int evenementId) async {
    final reservations = await Reservation.db.find(
      session,
      where: (t) =>
      t.evenementId.equals(evenementId) &
      t.statut.notEquals('annule') &
      t.statut.notEquals('rembourse'),
    );

    if (reservations.isEmpty) return [];

    final reservationIdsSet = reservations.map((r) => r.id!).toSet();

    final siegeRelations = await ReservationSiege.db.find(
      session,
      where: (t) => t.reservationId.inSet(reservationIdsSet),
    );

    return siegeRelations.map((r) => r.siegeId).toList();
  }

  // Récupérer mes réservations
  Future<List<Reservation>> getMesReservations(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];

    final user = await Utilisateur.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.userIdentifier),
    );
    if (user == null) return [];

    return await Reservation.db.find(
      session,
      where: (r) => r.utilisateurId.equals(user.id!),
      orderBy: (r) => r.dateReservation,
      orderDescending: true,
    );
  }

  // Annuler une réservation
  Future<bool> annulerReservation(
      Session session, int reservationId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;

    final user = await Utilisateur.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authInfo.userIdentifier),
    );
    if (user == null) return false;

    final reservation =
    await Reservation.db.findById(session, reservationId);
    if (reservation == null || reservation.utilisateurId != user.id)
      return false;

    reservation.statut = 'annule';
    await Reservation.db.updateRow(session, reservation);
    return true;
  }

  // Valider un code promo
  Future<CodePromo?> validerCodePromo(
      Session session, String code) async {
    final promos = await CodePromo.db.find(
      session,
      where: (c) => c.code.equals(code),
    );
    if (promos.isEmpty) return null;
    final promo = promos.first;

    // Vérifier expiration
    if (promo.dateExpiration != null &&
        promo.dateExpiration!.isBefore(DateTime.now().toUtc())) {
      return null;
    }

    // ✅ Vérifier si le nombre max d'utilisations est atteint
    if (promo.utilisationsMax != null &&
        (promo.utilisationsActuelles ?? 0) >= promo.utilisationsMax!) {
      return null;
    }

    // ✅ Vérifier si le promo est actif
    if (promo.actif != true) return null;

    return promo;
  }
}