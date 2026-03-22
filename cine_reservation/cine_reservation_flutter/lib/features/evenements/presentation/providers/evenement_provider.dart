import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';

final evenementsProvider = FutureProvider<List<Evenement>>((ref) async {
  try {
    return await client.evenements.getEvenements();
  } catch (e) {
    print('Erreur lors de la récupération des événements: $e');
    return [];
  }
});