import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/reservation/presentation/providers/reservation_provider.dart';

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

class CineReservationApp extends ConsumerStatefulWidget {
  const CineReservationApp({super.key});

  @override
  ConsumerState<CineReservationApp> createState() => _CineReservationAppState();
}

class _CineReservationAppState extends ConsumerState<CineReservationApp> {
  @override
  void initState() {
    super.initState();
    // Vider le panier au démarrage de l'application
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(panierProvider.notifier).vider();
      print('🗑️ Panier vidé au démarrage de l\'application');
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'CineReservation',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}