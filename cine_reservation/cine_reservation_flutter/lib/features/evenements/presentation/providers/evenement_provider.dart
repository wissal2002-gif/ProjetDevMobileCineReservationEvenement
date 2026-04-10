import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

final evenementsProvider = FutureProvider.autoDispose<List<Evenement>>((ref) async {
  try {
    final events = await client.evenements.getEvenements();
    final now = DateTime.now();
    // ✅ Garder seulement les événements actifs et futurs
    return events.where((e) =>
    e.statut == 'actif' &&
        e.dateDebut.isAfter(now)
    ).toList();
  } catch (e) {
    return [];
  }
});