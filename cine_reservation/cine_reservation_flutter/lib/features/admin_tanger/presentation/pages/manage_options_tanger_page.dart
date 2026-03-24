import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';

// ✅ LE NOM DOIT ÊTRE ManageOptionsTangerPage
class ManageOptionsTangerPage extends ConsumerWidget {
  const ManageOptionsTangerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(allOptionsProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          if (!isMobile) const SizedBox(width: 280, child: TangerSidebar()),

          Expanded(
            child: optionsAsync.when(
              data: (options) => Center(
                child: Text("Gestion des Snacks (Cinema 9)",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Erreur: $e")),
            ),
          ),
        ],
      ),
    );
  }
}