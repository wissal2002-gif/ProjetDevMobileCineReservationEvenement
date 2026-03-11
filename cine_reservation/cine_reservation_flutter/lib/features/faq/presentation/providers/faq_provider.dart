import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

final faqsProvider = FutureProvider<List<Faq>>((ref) async {
  return await client.faq.getAllFaqs();
});