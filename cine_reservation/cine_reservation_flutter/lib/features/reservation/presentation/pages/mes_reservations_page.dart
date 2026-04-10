import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/reservation_provider.dart';
import '../../data/reservation_remote_datasource.dart';

// ─── Provider pour charger les détails d'une réservation ───
final detailReservationProvider =
FutureProvider.family<Map<String, dynamic>, int>((ref, reservationId) async {
  final ds = ReservationRemoteDatasource();
  final billets = await ds.getBilletsByReservation(reservationId);
  return {
    'billets': billets,
  };
});

class MesReservationsPage extends ConsumerWidget {
  const MesReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(mesReservationsProvider);
    final ds = ref.read(reservationDatasourceProvider);

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
                child:
                Column(mainAxisSize: MainAxisSize.min, children: [
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
                itemBuilder: (ctx, i) =>
                    _card(ctx, ds, ref, list[i]),
              ),
              loading: () => const Center(
                  child:
                  CircularProgressIndicator(color: AppColors.accent)),
              error: (e, _) => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.wifi_off,
                      size: 48, color: Colors.white24),
                  const SizedBox(height: 12),
                  Text('Erreur: $e',
                      textAlign: TextAlign.center,
                      style:
                      const TextStyle(color: Colors.white54)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        ref.refresh(mesReservationsProvider),
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

  Widget _card(BuildContext context, ReservationRemoteDatasource ds,
      WidgetRef ref, Reservation reservation) {
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
        // ── En-tête : numéro + statut ──
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Reservation #${reservation.id}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: couleur.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              (reservation.statut ?? 'inconnu').toUpperCase(),
              style: TextStyle(
                  color: couleur,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        const SizedBox(height: 10),

        // ── Infos date + type ──
        Text(
            'Date : ${dateFmt.format(reservation.dateReservation.toLocal())}',
            style:
            const TextStyle(color: Colors.white60, fontSize: 12)),
        Text('Type : ${reservation.typeReservation ?? "N/A"}',
            style:
            const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 10),

        // ── Montant + boutons ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${reservation.montantTotal.toStringAsFixed(2)} MAD',
                style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Bouton DÉTAIL ──
                TextButton.icon(
                  onPressed: () => _showDetail(context, ref, reservation),
                  icon: const Icon(Icons.info_outline,
                      size: 16, color: AppColors.accent),
                  label: const Text('Détail',
                      style: TextStyle(
                          color: AppColors.accent, fontSize: 12)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),

                // ── Bouton ANNULER (si applicable) ──
                if (reservation.statut != 'annule' &&
                    reservation.statut != 'rembourse') ...[
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () async {
                      final ok = await ds
                          .annulerReservation(reservation.id!);
                      if (ok) {
                        ref.refresh(mesReservationsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Réservation annulée'),
                                backgroundColor: Colors.green),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.cancel_outlined,
                        size: 16, color: Colors.red),
                    label: const Text('Annuler',
                        style:
                        TextStyle(color: Colors.red, fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ]),
    );
  }

  // ─── Affichage du Bottom Sheet de détail ───
  void _showDetail(
      BuildContext context, WidgetRef ref, Reservation reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailBottomSheet(
        reservation: reservation,
        ref: ref,
      ),
    );
  }

  Color _statutColor(String? s) {
    switch (s) {
      case 'confirmee':
        return Colors.green;
      case 'en_attente':
        return Colors.orange;
      case 'annule':
        return Colors.red;
      case 'rembourse':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

// ─── Bottom Sheet : détails de la réservation ───
class _DetailBottomSheet extends ConsumerWidget {
  final Reservation reservation;
  final WidgetRef ref;

  const _DetailBottomSheet({
    required this.reservation,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFmt = DateFormat('dd/MM/yyyy');
    final timeFmt = DateFormat('HH:mm');
    final couleur = _statutColor(reservation.statut);
    final detailAsync =
    ref.watch(detailReservationProvider(reservation.id!));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Poignée ──
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DÉTAIL DE LA RÉSERVATION',
                          style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1.5)),
                      Text('#${reservation.id}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: couleur.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: couleur.withOpacity(0.4)),
                    ),
                    child: Text(
                      (reservation.statut ?? 'inconnu').toUpperCase(),
                      style: TextStyle(
                          color: couleur,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12, height: 24),

            // ── Corps scrollable ──
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                children: [
                  // ── Bloc : Informations générales ──
                  _sectionTitle('INFORMATIONS'),
                  const SizedBox(height: 12),
                  _infoBlock([
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date de réservation',
                      value: dateFmt.format(
                          reservation.dateReservation.toLocal()),
                    ),
                    _InfoRow(
                      icon: Icons.access_time,
                      label: 'Heure',
                      value: timeFmt.format(
                          reservation.dateReservation.toLocal()),
                    ),
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: 'Type',
                      value: reservation.typeReservation == 'evenement'
                          ? 'Événement'
                          : 'Cinéma',
                    ),
                    if (reservation.seanceId != null)
                      _InfoRow(
                        icon: Icons.movie_outlined,
                        label: 'ID Séance',
                        value: '#${reservation.seanceId}',
                      ),
                    if (reservation.evenementId != null)
                      _InfoRow(
                        icon: Icons.event_outlined,
                        label: 'ID Événement',
                        value: '#${reservation.evenementId}',
                      ),
                    if (reservation.cinemaId != null)
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'ID Cinéma',
                        value: '#${reservation.cinemaId}',
                      ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Bloc : Montant ──
                  _sectionTitle('MONTANT'),
                  const SizedBox(height: 12),
                  _infoBlock([
                    _InfoRow(
                      icon: Icons.receipt_outlined,
                      label: 'Montant total',
                      value:
                      '${reservation.montantTotal.toStringAsFixed(2)} MAD',
                      valueColor: AppColors.accent,
                      valueBold: true,
                    ),
                    if (reservation.montantApresReduction != null &&
                        reservation.montantApresReduction !=
                            reservation.montantTotal)
                      _InfoRow(
                        icon: Icons.local_offer_outlined,
                        label: 'Après réduction',
                        value:
                        '${reservation.montantApresReduction!.toStringAsFixed(2)} MAD',
                        valueColor: Colors.green,
                        valueBold: true,
                      ),
                    if (reservation.codePromoId != null)
                      _InfoRow(
                        icon: Icons.discount_outlined,
                        label: 'Code promo',
                        value: 'Appliqué (#${reservation.codePromoId})',
                        valueColor: Colors.green,
                      ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Bloc : Billets (chargement async) ──
                  _sectionTitle('BILLETS'),
                  const SizedBox(height: 12),
                  detailAsync.when(
                    data: (detail) {
                      final billets =
                      detail['billets'] as List<Billet>;
                      if (billets.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.divider),
                          ),
                          child: const Row(children: [
                            Icon(Icons.info_outline,
                                color: Colors.white38, size: 16),
                            SizedBox(width: 8),
                            Text('Aucun billet associé',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13)),
                          ]),
                        );
                      }
                      return Column(
                        children: billets
                            .map((b) => _billetTile(b))
                            .toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: AppColors.accent,
                              strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (e, _) => Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Impossible de charger les billets',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12)),
                        ),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Résumé visuel statut ──
                  _statutResume(reservation.statut, couleur),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(
        color: AppColors.accent,
        fontWeight: FontWeight.bold,
        fontSize: 11,
        letterSpacing: 1.5),
  );

  Widget _infoBlock(List<_InfoRow> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          final row = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(row.icon,
                        color: AppColors.accent.withOpacity(0.7),
                        size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(row.label,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 13)),
                    ),
                    Text(
                      row.value,
                      style: TextStyle(
                        color: row.valueColor ?? Colors.white,
                        fontSize: 13,
                        fontWeight: row.valueBold
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                    color: Colors.white10, height: 1, thickness: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _billetTile(Billet billet) {
    final estValide = billet.estValide == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: estValide
              ? Colors.green.withOpacity(0.4)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // ── Icône billet ──
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: estValide
                  ? Colors.green.withOpacity(0.12)
                  : Colors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              estValide
                  ? Icons.confirmation_number
                  : Icons.confirmation_number_outlined,
              color: estValide ? Colors.green : Colors.red,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // ── Infos ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Billet #${billet.id}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 2),
                Row(children: [
                  if (billet.siegeId != null) ...[
                    const Icon(Icons.event_seat,
                        color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Text('Siège #${billet.siegeId}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11)),
                    const SizedBox(width: 10),
                  ],
                  if (billet.typeBillet != null) ...[
                    const Icon(Icons.local_offer,
                        color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      (billet.typeBillet ?? 'normal').toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ]),
              ],
            ),
          ),

          // ── Statut ──
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: estValide
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              estValide ? 'VALIDE' : 'UTILISÉ',
              style: TextStyle(
                  color: estValide ? Colors.green : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statutResume(String? statut, Color couleur) {
    String message;
    IconData icone;
    switch (statut) {
      case 'confirmee':
        message = 'Réservation confirmée. Vos billets sont valides.';
        icone = Icons.check_circle_outline;
        break;
      case 'en_attente':
        message =
        'En attente de confirmation. Complétez le paiement si ce n\'est pas fait.';
        icone = Icons.hourglass_empty_outlined;
        break;
      case 'annule':
        message = 'Cette réservation a été annulée.';
        icone = Icons.cancel_outlined;
        break;
      case 'rembourse':
        message = 'Remboursement effectué pour cette réservation.';
        icone = Icons.replay_outlined;
        break;
      default:
        message = 'Statut inconnu.';
        icone = Icons.help_outline;
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: couleur.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icone, color: couleur, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message,
              style: TextStyle(
                  color: couleur.withOpacity(0.9),
                  fontSize: 12,
                  height: 1.4)),
        ),
      ]),
    );
  }

  Color _statutColor(String? s) {
    switch (s) {
      case 'confirmee':
        return Colors.green;
      case 'en_attente':
        return Colors.orange;
      case 'annule':
        return Colors.red;
      case 'rembourse':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

// ─── Modèle interne pour les lignes d'info ───
class _InfoRow {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });
}