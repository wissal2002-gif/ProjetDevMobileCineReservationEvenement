import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../reservation/presentation/providers/reservation_provider.dart';

class BilletsPage extends ConsumerWidget {
  const BilletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billetsAsync = ref.watch(mesBilletsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('MES BILLETS',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          const Text('Tous vos billets disponibles',
              style: TextStyle(color: AppColors.textLight)),
          const SizedBox(height: 24),
          Expanded(
            child: billetsAsync.when(
              data: (billets) => billets.isEmpty
                  ? const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.airplane_ticket_outlined,
                      size: 60, color: Colors.white12),
                  SizedBox(height: 16),
                  Text('Aucun billet',
                      style: TextStyle(
                          color: AppColors.textLight, fontSize: 16)),
                ]),
              )
                  : ListView.builder(
                itemCount: billets.length,
                itemBuilder: (ctx, i) => _card(ctx, billets[i]),
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, _) => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.white24),
                  const SizedBox(height: 12),
                  Text('Erreur: $e',
                      style: const TextStyle(color: Colors.white54)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.refresh(mesBilletsProvider),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent),
                    child: const Text('Reessayer'),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _card(BuildContext context, Billet billet) {
    final valide = billet.estValide == true;
    return GestureDetector(
      onTap: () => context.push('/billet-detail', extra: billet),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: valide
                  ? Colors.green.withOpacity(0.4)
                  : Colors.red.withOpacity(0.3)),
        ),
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: valide
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              valide
                  ? Icons.confirmation_number
                  : Icons.confirmation_number_outlined,
              color: valide ? Colors.green : Colors.red,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Billet #${billet.id}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text(
                  'Emis le ${DateFormat('dd/MM/yyyy').format(billet.dateEmission.toLocal())}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(
                  (billet.typeBillet ?? 'STANDARD').toUpperCase(),
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(valide ? 'VALIDE' : 'UTILISE',
                style: TextStyle(
                    color: valide ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 11)),
            const SizedBox(height: 4),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ]),
        ]),
      ),
    );
  }
}
