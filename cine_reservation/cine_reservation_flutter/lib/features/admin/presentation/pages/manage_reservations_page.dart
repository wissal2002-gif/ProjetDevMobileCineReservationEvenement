import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
// ✅ Import corrigé vers le dossier admin_tanger
import '../../../admin_tanger/presentation/widgets/tanger_sidebar.dart';
import 'package:intl/intl.dart';

// ✅ Classe renommée pour éviter le conflit
class ManageReservationsPage extends ConsumerWidget {
  const ManageReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resAsync = ref.watch(allReservationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          // Sidebar avec largeur fixe (SANS CONST)
          SizedBox(width: 280, child: TangerSidebar()),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GESTION GLOBALE DES RÉSERVATIONS",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Expanded(
                    child: resAsync.when(
                      data: (list) {
                        if (list.isEmpty) return const Center(child: Text("Aucune réservation dans le système.", style: TextStyle(color: Colors.white24)));
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) => _buildGlobalResCard(list[index]),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text("Erreur: $e")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalResCard(Reservation res) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text("Client ID: ${res.utilisateurId}", style: const TextStyle(color: Colors.white)),
        subtitle: Text("Date: ${res.dateReservation} - Total: ${res.montantTotal} DH", style: const TextStyle(color: Colors.white38)),
      ),
    );
  }
}