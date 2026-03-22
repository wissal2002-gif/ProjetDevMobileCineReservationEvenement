import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

final allEvenementsProvider = FutureProvider<List<Evenement>>((ref) async {
  return await client.admin.getAllEvenements();
});

final allCinemasAdminProvider = FutureProvider<List<Cinema>>((ref) async {
  return await client.admin.getAllCinemas();
});