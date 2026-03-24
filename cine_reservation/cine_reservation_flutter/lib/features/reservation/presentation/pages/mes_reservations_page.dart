import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/reservation_provider.dart';

class MesReservationsPage extends ConsumerWidget {
  MesReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(mesReservationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MES RESERVATIONS',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              IconButton(
                onPressed: () => ref.refresh(mesReservationsProvider),
                icon: const Icon(Icons.refresh, color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Historique de vos reservations',
              style: TextStyle(color: AppColors.textLight)),
          const SizedBox(height: 24),
          Expanded(
            child: reservationsAsync.when(
              data: (list) => list.isEmpty
                  ? const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.confirmation_number_outlined,
                      size: 60, color: Colors.white12),
                  SizedBox(height: 16),
                  Text('Aucune reservation',
                      style: TextStyle(
                          color: AppColors.textLight, fontSize: 16)),
                ]),
              )
                  : ListView.builder(
                itemCount: list.length,
                itemBuilder: (ctx, i) => _card(ctx, ref, list[i]),
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
              error: (e, _) => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.white24),
                  const SizedBox(height: 12),
                  Text('Erreur: $e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white54)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.refresh(mesReservationsProvider),
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

  Widget _card(BuildContext context, WidgetRef ref, reservation) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final couleur = _statutColor(reservation.statut);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Reservation #${reservation.id}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: couleur.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              (reservation.statut ?? 'inconnu').toUpperCase(),
              style: TextStyle(
                  color: couleur, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Text('Date : ${dateFmt.format(reservation.dateReservation.toLocal())}',
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
        Text('Type : ${reservation.typeReservation ?? "N/A"}',
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${reservation.montantTotal.toStringAsFixed(2)} MAD',
              style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          if (reservation.statut != 'annule' &&
              reservation.statut != 'remboursement_demande')
            TextButton.icon(
              onPressed: () async {
                final ok = await ref
                    .read(reservationDatasourceProvider)
                    .annulerReservation(reservation.id!);
                if (ok) ref.refresh(mesReservationsProvider);
              },
              icon: const Icon(Icons.cancel_outlined, size: 16, color: Colors.red),
              label: const Text('Annuler',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ]),
      ]),
    );
  }

  Color _statutColor(String? s) {
    switch (s) {
      case 'confirmee': return Colors.green;
      case 'en_attente': return Colors.orange;
      case 'annule': return Colors.red;
      case 'remboursement_demande': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

