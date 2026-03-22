import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

late final Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('fr_FR', null);

  final serverUrl = await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  runApp(
    const ProviderScope(
      child: CineReservationApp(),
    ),
  );
}

class CineReservationApp extends ConsumerWidget {
  const CineReservationApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'CineReservation',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
