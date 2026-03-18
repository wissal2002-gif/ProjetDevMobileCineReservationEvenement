// lib/features/admin/presentation/providers/admin_options_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

final allOptionsProvider = FutureProvider<List<OptionSupplementaire>>((ref) async {
  return await client.admin.getAllOptions();
});