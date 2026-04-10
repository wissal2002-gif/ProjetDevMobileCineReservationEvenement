import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/reservation_remote_datasource.dart';

// ─── DATASOURCE ───
final reservationDatasourceProvider = Provider<ReservationRemoteDatasource>(
      (ref) => ReservationRemoteDatasource(),
);

// ─── MODELES PANIER ───
class SiegeSelectionne {
  final Siege siege;
  final String typeBillet;
  final double prix;
  const SiegeSelectionne({
    required this.siege,
    required this.typeBillet,
    required this.prix,
  });
}

class OptionPanier {
  final int id;
  final String nom;
  final double prix;
  int quantite;
  OptionPanier({
    required this.id,
    required this.nom,
    required this.prix,
    this.quantite = 1,
  });
}

class PanierState {
  final List<SiegeSelectionne> sieges;
  final List<OptionPanier> options;
  final double reduction;
  final String? codePromo;
  final int? codePromoId;

  const PanierState({
    this.sieges = const [],
    this.options = const [],
    this.reduction = 0,
    this.codePromo,
    this.codePromoId,
  });

  double get sousTotalSieges =>
      sieges.fold(0, (s, e) => s + e.prix);
  double get sousTotalOptions =>
      options.fold(0, (s, e) => s + e.prix * e.quantite);
  double get total =>
      (sousTotalSieges + sousTotalOptions) * (1 - reduction);
  int get nombreSieges => sieges.length;
}

class PanierNotifier extends StateNotifier<PanierState> {
  PanierNotifier() : super(const PanierState());

  void ajouterSiege(SiegeSelectionne s) {
    if (state.sieges.any((e) => e.siege.id == s.siege.id)) return;
    state = PanierState(
      sieges: [...state.sieges, s],
      options: state.options,
      reduction: state.reduction,
      codePromo: state.codePromo,
      codePromoId: state.codePromoId,
    );
  }

  void retirerSiege(int siegeId) {
    state = PanierState(
      sieges: state.sieges.where((e) => e.siege.id != siegeId).toList(),
      options: state.options,
      reduction: state.reduction,
      codePromo: state.codePromo,
      codePromoId: state.codePromoId,
    );
  }

  void ajouterOption(OptionPanier opt) {
    final idx = state.options.indexWhere((o) => o.id == opt.id);
    if (idx >= 0) {
      final updated = [...state.options];
      updated[idx].quantite++;
      state = PanierState(
        sieges: state.sieges,
        options: updated,
        reduction: state.reduction,
        codePromo: state.codePromo,
        codePromoId: state.codePromoId,
      );
    } else {
      state = PanierState(
        sieges: state.sieges,
        options: [...state.options, opt],
        reduction: state.reduction,
        codePromo: state.codePromo,
        codePromoId: state.codePromoId,
      );
    }
  }

  void retirerOption(String nom) {
    final idx = state.options.indexWhere((o) => o.nom == nom);
    if (idx < 0) return;
    final updated = [...state.options];
    if (updated[idx].quantite > 1) {
      updated[idx].quantite--;
      state = PanierState(
        sieges: state.sieges,
        options: updated,
        reduction: state.reduction,
        codePromo: state.codePromo,
        codePromoId: state.codePromoId,
      );
    } else {
      state = PanierState(
        sieges: state.sieges,
        options: state.options.where((o) => o.nom != nom).toList(),
        reduction: state.reduction,
        codePromo: state.codePromo,
        codePromoId: state.codePromoId,
      );
    }
  }

  void appliquerCodePromo(String code, double taux, {int? promoId}) {
    state = PanierState(
      sieges: state.sieges,
      options: state.options,
      reduction: taux,
      codePromo: code,
      codePromoId: promoId,
    );
  }

  void vider() {
    state = const PanierState();
  }
}

final panierProvider =
StateNotifierProvider<PanierNotifier, PanierState>(
      (ref) => PanierNotifier(),
);

// ─── ASYNC PROVIDERS ───
final siegesBySalleProvider =
FutureProvider.family<List<Siege>, int>((ref, salleId) async {
  return await ref
      .read(reservationDatasourceProvider)
      .getSiegesBySalle(salleId);
});

final siegesOccupesSeanceProvider =
FutureProvider.family<List<int>, int>((ref, seanceId) async {
  return await ref
      .read(reservationDatasourceProvider)
      .getSiegesReservesBySeance(seanceId);
});

final siegesOccupesEvenementProvider =
FutureProvider.family<List<int>, int>((ref, evenementId) async {
  return await ref
      .read(reservationDatasourceProvider)
      .getSiegesReservesByEvenement(evenementId);
});

final mesReservationsProvider =
FutureProvider<List<Reservation>>((ref) async {
  return await ref
      .read(reservationDatasourceProvider)
      .getMesReservations();
});

final mesBilletsProvider =
FutureProvider<List<Billet>>((ref) async {
  return await ref
      .read(reservationDatasourceProvider)
      .getMesBillets();
});

final billetsByReservationProvider =
FutureProvider.family<List<Billet>, int>((ref, reservationId) async {
  return await ref
      .read(reservationDatasourceProvider)
      .getBilletsByReservation(reservationId);
});

// Toutes les options — utilisé si pas de cinéma connu
final optionsSupplementairesProvider =
FutureProvider<List<OptionSupplementaire>>((ref) async {
  return await ref
      .read(reservationDatasourceProvider)
      .getOptions();
});

// Options filtrées par cinéma — NOUVEAU, utilisé dans PanierPage
final optionsByCinemaProvider =
FutureProvider.family<List<OptionSupplementaire>, int>(
        (ref, cinemaId) async {
      return await ref
          .read(reservationDatasourceProvider)
          .getOptionsByCinema(cinemaId);
    });