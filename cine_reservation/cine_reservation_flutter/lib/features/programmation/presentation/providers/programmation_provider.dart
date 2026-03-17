import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

final filmsProvider = FutureProvider<List<Film>>((ref) async {
  try {
    return await client.films.getFilms();
  } catch (e) {
    return [];
  }
});

final filmDetailProvider =
FutureProvider.family<Film?, int>((ref, id) async {
  return await client.films.getFilmById(id);
});

final seancesFilmProvider =
FutureProvider.family<List<Seance>, int>((ref, filmId) async {
  try {
    return await client.seances.getSeancesByFilm(filmId);
  } catch (e) {
    return [];
  }
});

/// Charge les séances correspondant à une liste d'IDs.
/// Utilisé par HomePage pour croiser :
/// Reservation.seanceId → Seance.filmId → Film.genre
final seancesByIdsProvider =
FutureProvider.family<List<Seance>, List<int>>((ref, ids) async {
  if (ids.isEmpty) return [];
  try {
    return await client.seances.getSeancesByIds(ids);
  } catch (e) {
    return [];
  }
});

final optionsProvider =
FutureProvider<List<OptionSupplementaire>>((ref) async {
  try {
    return await client.options.getOptions();
  } catch (e) {
    return [];
  }
});

final allCinemasProvider = FutureProvider<List<Cinema>>((ref) async {
  try {
    return await client.cinemas.getCinemas();
  } catch (e) {
    return [];
  }
});

final allSallesProvider = FutureProvider<List<Salle>>((ref) async {
  try {
    return await client.salles.getSalles();
  } catch (e) {
    return [];
  }
});