import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

final filmsProvider = FutureProvider.autoDispose<List<Film>>((ref) async {
  try {
    final films = await client.films.getFilms();
    final now = DateTime.now();
    final List<Film> filmsActifs = [];
    for (final film in films) {
      if (film.id == null) continue;
      final seances = await client.seances.getSeancesByFilm(film.id!);
      final aSeanceValide = seances.any((s) =>
      s.dateHeure.isAfter(now) &&
          (s.placesDisponibles ?? 0) > 0);
      if (aSeanceValide) filmsActifs.add(film);
    }
    return filmsActifs;
  } catch (e) {
    return [];
  }
});

final filmDetailProvider =
FutureProvider.family<Film?, int>((ref, id) async {
  return await client.films.getFilmById(id);
});

final seancesFilmProvider =
FutureProvider.autoDispose.family<List<Seance>, int>((ref, filmId) async {
  try {
    final seances = await client.seances.getSeancesByFilm(filmId);
    final now = DateTime.now();
    return seances.where((s) => s.dateHeure.isAfter(now)).toList();
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

final allCinemasProvider = FutureProvider.autoDispose<List<Cinema>>((ref) async {
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