import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resAsync = ref.watch(allReservationsProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("RAPPORTS D'ACTIVITÉS"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("ALERTES RÉCENTES"),
            const SizedBox(height: 16),
            resAsync.when(
              data: (res) {
                final annulations = res.where((r) => r.statut == 'annule').take(5).toList();
                if (annulations.isEmpty) return _emptyCard("Aucune alerte critique");
                return Column(
                  children: annulations.map((r) => _alertItem(r)).toList(),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text("Erreur: $e"),
            ),
            
            const SizedBox(height: 40),
            _buildSectionTitle("DERNIERS UTILISATEURS INSCRITS"),
            const SizedBox(height: 16),
            usersAsync.when(
              data: (users) {
                final recentUsers = users.reversed.take(5).toList();
                return Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: recentUsers.map((u) => ListTile(
                      leading: const Icon(Icons.person_add_alt_1, color: Colors.greenAccent),
                      title: Text(u.nom, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(u.email, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      trailing: Text(u.role?.toUpperCase() ?? "CLIENT", style: const TextStyle(fontSize: 10, color: AppColors.accent)),
                    )).toList(),
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 40),
            _buildSectionTitle("FLUX DES RÉSERVATIONS"),
            const SizedBox(height: 16),
            resAsync.when(
              data: (res) => _buildMiniStats(res),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13));

  Widget _alertItem(Reservation r) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent.withOpacity(0.2))),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Annulation Réservation #${r.id}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text("Montant: ${r.montantTotal} DH - ${DateFormat('dd/MM HH:mm').format(r.dateReservation)}", style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _emptyCard(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12)),
    child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white24)),
  );

  Widget _buildMiniStats(List<Reservation> res) {
    final today = DateTime.now();
    final todayRes = res.where((r) => r.dateReservation.day == today.day && r.dateReservation.month == today.month).length;
    final totalRevenu = res.fold(0.0, (sum, r) => sum + r.montantTotal);

    return Row(
      children: [
        _statBox("Aujourd'hui", todayRes.toString(), Icons.today, Colors.blue),
        const SizedBox(width: 16),
        _statBox("Revenu Global", "${totalRevenu.toStringAsFixed(0)} DH", Icons.account_balance_wallet, Colors.amber),
      ],
    );
  }

  Widget _statBox(String label, String val, IconData icon, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 12),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    ),
  );
}
