import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';

// Utilisez le type Notification du client Serverpod
typedef Notification = cine_reservation_client.Notification;

final notificationProvider = FutureProvider<List<Notification>>((ref) async {
  try {
    return await client.notification.getMyNotifications();
  } catch (e) {
    print('Erreur chargement notifications: $e');
    return [];
  }
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  try {
    return await client.notification.getUnreadCount();
  } catch (e) {
    return 0;
  }
});