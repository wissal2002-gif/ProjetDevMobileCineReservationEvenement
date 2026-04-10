import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stocke les objets de navigation entre pages.
/// Nécessaire sur Flutter Web car GoRouter sérialise extra en JSON
/// ce qui détruit les instances Dart (TypeError: _JsonMap is not Seance).
class NavigationState {
  final Seance? seance;
  final Evenement? evenement;
  final String filmTitre;
  final int salleId;
  final int? cinemaId; // NOUVEAU : pour filtrer les options par cinéma

  const NavigationState({
    this.seance,
    this.evenement,
    this.filmTitre = '',
    this.salleId = 1,
    this.cinemaId, // NOUVEAU
  });
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void setContext({
    Seance? seance,
    Evenement? evenement,
    required String filmTitre,
    int salleId = 1,
    int? cinemaId, // NOUVEAU
  }) {
    state = NavigationState(
      seance: seance,
      evenement: evenement,
      filmTitre: filmTitre,
      salleId: salleId,
      cinemaId: cinemaId, // NOUVEAU
    );
  }

  void clear() => state = const NavigationState();
}

final navigationProvider =
StateNotifierProvider<NavigationNotifier, NavigationState>(
      (ref) => NavigationNotifier(),
);