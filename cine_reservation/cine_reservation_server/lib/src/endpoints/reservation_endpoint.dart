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
        List<String>? siegeTarifs,
        List<double>? siegePrix,
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

    // ✅ FIX 1 : vérification conflits pour SÉANCES ET ÉVÉNEMENTS
    if (validSiegeIds.isNotEmpty) {
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

        // Filtrer : vérifier que la réservation existante concerne
        // le MÊME événement ou la MÊME séance
        final memeContexte = isEvenement
            ? reservationExistante.evenementId == evenementId
            : reservationExistante.seanceId == seanceId;
        if (!memeContexte) continue;

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

        // ✅ Siège déjà confirmé → retourner null proprement
        if (reservationExistante.statut != 'annule' &&
            reservationExistante.statut != 'rembourse' &&
            reservationExistante.statut != 'en_attente') {
          return null;
        }
      }
    }

    // ✅ FIX 2 : récupérer le cinemaId pour séance ET événement
    int? cinemaId;
    if (seanceId != null) {
      final seance = await Seance.db.findById(session, seanceId);
      if (seance != null) {
        final salle = await Salle.db.findById(session, seance.salleId);
        cinemaId = salle?.cinemaId;
      }
    } else if (evenementId != null) {
      final evenement = await Evenement.db.findById(session, evenementId);
      cinemaId = evenement?.cinemaId;
    }

    // Valider le code promo et calculer réduction
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

    // ✅ FIX 3 : insérer les sièges pour SÉANCES ET ÉVÉNEMENTS
    // (suppression de !isEvenement qui bloquait les événements)
    if (validSiegeIds.isNotEmpty) {
      for (int i = 0; i < validSiegeIds.length; i++) {
        final siegeId = validSiegeIds[i];

        final typeTarif = (siegeTarifs != null && i < siegeTarifs.length)
            ? siegeTarifs[i]
            : 'normal';

        double? prix;
        if (siegePrix != null && i < siegePrix.length) {
          // Prix fourni directement par le client (cas normal)
          prix = siegePrix[i];
        } else if (seanceId != null) {
          // Fallback : calculer depuis la séance
          final seance = await Seance.db.findById(session, seanceId);
          if (seance != null) {
            switch (typeTarif) {
              case 'reduit':
                prix = seance.prixReduit ?? seance.prixNormal;
                break;
              case 'enfant':
                prix = seance.prixEnfant ?? seance.prixNormal;
                break;
              case 'senior':
                prix = seance.prixSenior ?? seance.prixNormal;
                break;
              case 'vip':
                prix = seance.prixVip ?? seance.prixNormal;
                break;
              default:
                prix = seance.prixNormal;
            }
          }
        } else if (evenementId != null) {
          // ✅ FIX 4 : fallback prix depuis l'événement si non fourni
          final evenement = await Evenement.db.findById(session, evenementId);
          if (evenement != null) {
            switch (typeTarif) {
              case 'vip':
                prix = evenement.prixVip ?? evenement.prix;
                break;
              case 'reduit':
                prix = evenement.prixReduit ?? evenement.prix;
                break;
              case 'senior':
                prix = evenement.prixSenior ?? evenement.prix;
                break;
              case 'enfant':
                prix = evenement.prixEnfant ?? evenement.prix;
                break;
              default:
                prix = evenement.prix;
            }
          }
        }

        final reservationSiege = ReservationSiege(
          reservationId: newReservation.id!,
          siegeId: siegeId,
          typeTarif: typeTarif,
          prix: prix,
        );
        await ReservationSiege.db.insertRow(session, reservationSiege);
      }
    }

    // Enregistrer les options avec prix unitaire
    if (optionsIds != null && optionsIds.isNotEmpty) {
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

    // Incrémenter utilisationsActuelles du code promo
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

    // ✅ Filtrer les "en_attente" expirées (+15 min)
    final now = DateTime.now().toUtc();
    final reservationsValides = reservations.where((r) {
      if (r.statut == 'en_attente') {
        final diff = now.difference(r.dateReservation);
        return diff.inMinutes < 15;
      }
      return true;
    }).toList();

    if (reservationsValides.isEmpty) return [];

    final reservationIdsSet =
    reservationsValides.map((r) => r.id!).toSet();

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
    if (reservation == null || reservation.utilisateurId != user.id) {
      return false;
    }

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

    if (promo.dateExpiration != null &&
        promo.dateExpiration!.isBefore(DateTime.now().toUtc())) {
      return null;
    }

    if (promo.utilisationsMax != null &&
        (promo.utilisationsActuelles ?? 0) >= promo.utilisationsMax!) {
      return null;
    }

    if (promo.actif != true) return null;

    return promo;
  }
}