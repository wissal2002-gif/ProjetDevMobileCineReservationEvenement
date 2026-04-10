import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/evenement_provider.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart';
import '../../../reservation/presentation/providers/reservation_provider.dart';
import '../../../../core/router/navigation_state_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EvenementDetailPage extends ConsumerWidget {
  final int evenementId;
  const EvenementDetailPage({super.key, required this.evenementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(evenementsProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);
    final sallesAsync = ref.watch(allSallesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: eventAsync.when(
        data: (events) {
          final event = events.firstWhere((e) => e.id == evenementId);

          // ✅ FIX : utiliser .value directement pour avoir les données
          // même si le provider est déjà chargé (évite le problème de whenData)
          final salles = sallesAsync.value ?? [];
          final cinemas = cinemasAsync.value ?? [];

          // Récupérer le vrai salleId depuis la liste des salles
          int salleId = 0;
          String cinemaInfo = event.lieu ?? "Lieu non spécifié";

          if (event.cinemaId != null && salles.isNotEmpty) {
            try {
              final salle =
              salles.firstWhere((s) => s.cinemaId == event.cinemaId);
              salleId = salle.id ?? 0;
            } catch (_) {}
          }
          if (event.cinemaId != null && cinemas.isNotEmpty && salleId > 0) {
            try {
              final cinema =
              cinemas.firstWhere((c) => c.id == event.cinemaId);
              cinemaInfo = "${cinema.nom} (${cinema.ville})";
            } catch (_) {}
          }

          // Si salles pas encore chargées, afficher un loader
          if (event.cinemaId != null &&
              salleId == 0 &&
              sallesAsync.isLoading) {
            return const Center(
                child:
                CircularProgressIndicator(color: AppColors.accent));
          }

          return _buildContent(
              context, ref, event, cinemaInfo, salleId);
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, s) => Center(
            child: Text("Erreur: $e",
                style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      WidgetRef ref,
      Evenement event,
      String cinemaInfo,
      int salleId,
      ) {
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    final timeFormat = DateFormat('HH:mm');

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          backgroundColor: AppColors.background,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: event.affiche ?? "",
                  fit: BoxFit.cover,
                  errorWidget: (c, u, e) => Container(
                      color: AppColors.cardBg,
                      child: const Icon(Icons.event, size: 100)),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.background],
                    ),
                  ),
                ),
                if (event.bandeAnnonce != null &&
                    event.bandeAnnonce!.isNotEmpty)
                  Center(
                    child: FloatingActionButton.extended(
                      heroTag: 'bande_annonce_event_${event.id}',
                      onPressed: () async {
                        final Uri url = Uri.parse(event.bandeAnnonce!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      label: const Text("BANDE ANNONCE"),
                      icon: const Icon(Icons.play_arrow),
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTypeBadge(event.type ?? "Événement"),
                    _buildCancelBadge(
                      event.annulationGratuite == true
                          ? "Annulation gratuite"
                          : "Annulation payante",
                      isFree: event.annulationGratuite ?? false,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(event.titre,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 30),
                _buildInfoSection(
                    Icons.calendar_today,
                    "DATE ET HEURE",
                    "${dateFormat.format(event.dateDebut)} à ${timeFormat.format(event.dateDebut)}"),
                _buildInfoSection(
                    Icons.location_on, "LIEU / CINÉMA", cinemaInfo),
                _buildInfoSection(Icons.person, "ORGANISATEUR",
                    event.organisateur ?? "Non spécifié"),
                if (event.annulationGratuite ?? false)
                  _buildInfoSection(
                      Icons.history,
                      "DÉLAI D'ANNULATION",
                      "Jusqu'à ${event.delaiAnnulation ?? 48} heures avant l'événement"),
                const SizedBox(height: 30),
                const Text("À PROPOS DE CET ÉVÉNEMENT",
                    style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                    event.description ??
                        "Pas de description disponible.",
                    style: const TextStyle(
                        color: Colors.white70, height: 1.6)),
                const SizedBox(height: 30),
                _buildStatusSection(event),
                const SizedBox(height: 40),
                _buildPriceAndBooking(context, ref, event, salleId),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndBooking(
      BuildContext context,
      WidgetRef ref,
      Evenement event,
      int salleId,
      ) {
    final bool isFull = (event.placesDisponibles ?? 0) <= 0;
    final bool hasPrixVip = (event.prixVip ?? 0) > 0;
    final bool hasPrixReduit = (event.prixReduit ?? 0) > 0;
    final bool hasPrixSenior = (event.prixSenior ?? 0) > 0;
    final bool hasPrixEnfant = (event.prixEnfant ?? 0) > 0;
    final bool hasMultiplePrix =
        hasPrixVip || hasPrixReduit || hasPrixSenior || hasPrixEnfant;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColors.accent.withOpacity(0.2),
          AppColors.background
        ]),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasMultiplePrix) ...[
            const Text("PRIX PAR TYPE",
                style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 10,
                    letterSpacing: 1.5)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _prixChip('Normal', event.prix ?? 0, AppColors.accent),
                  if (hasPrixVip)
                    _prixChip('VIP', event.prixVip!, Colors.purple),
                  if (hasPrixReduit)
                    _prixChip('Réduit', event.prixReduit!, Colors.blue),
                  if (hasPrixSenior)
                    _prixChip('Senior', event.prixSenior!, Colors.orange),
                  if (hasPrixEnfant)
                    _prixChip('Enfant', event.prixEnfant!, Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (!isFull)
              Text(
                "${event.placesDisponibles ?? 0} places restantes",
                style: TextStyle(
                  color: (event.placesDisponibles ?? 0) < 10
                      ? Colors.orange
                      : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("PRIX PAR PLACE",
                          style: TextStyle(
                              color: AppColors.textLight, fontSize: 10)),
                      Text("${event.prix ?? 0.0} MAD",
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    ]),
                if (!isFull)
                  Text(
                    "${event.placesDisponibles ?? 0} places restantes",
                    style: TextStyle(
                      color: (event.placesDisponibles ?? 0) < 10
                          ? Colors.orange
                          : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isFull
                  ? null
                  : () => _showReservationDialog(
                  context, ref, event, salleId),
              icon: const Icon(Icons.confirmation_number_outlined),
              label: Text(
                isFull ? "COMPLET" : "RÉSERVER",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? Colors.grey : AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prixChip(String label, double prix, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text('${prix.toStringAsFixed(0)} MAD',
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showReservationDialog(
      BuildContext context,
      WidgetRef ref,
      Evenement event,
      int salleId,
      ) {
    // ✅ FIX : événement cinéma → seat_selection avec le bon salleId
    final isCinemaEvent = event.cinemaId != null && salleId > 0;

    if (isCinemaEvent) {
      ref.read(navigationProvider.notifier).setContext(
        seance: null,
        evenement: event,
        filmTitre: event.titre,
        salleId: salleId, // ✅ vrai salleId
        cinemaId: event.cinemaId,
      );
      ref.read(panierProvider.notifier).vider();
      context.push('/seat-selection');
      return;
    }

    // Événement externe → dialog
    int nbPlaces = 1;
    final maxPlaces = event.placesDisponibles ?? 1;

    final tarifs = <_TarifOption>[
      _TarifOption('normal', 'Normal', event.prix ?? 0, AppColors.accent),
      if ((event.prixVip ?? 0) > 0)
        _TarifOption('vip', 'VIP', event.prixVip!, Colors.purple),
      if ((event.prixReduit ?? 0) > 0)
        _TarifOption('reduit', 'Réduit', event.prixReduit!, Colors.blue),
      if ((event.prixSenior ?? 0) > 0)
        _TarifOption('senior', 'Senior', event.prixSenior!, Colors.orange),
      if ((event.prixEnfant ?? 0) > 0)
        _TarifOption('enfant', 'Enfant', event.prixEnfant!, Colors.green),
    ];

    String tarifSelectionne = 'normal';
    double prixSelectionne = event.prix ?? 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final total = nbPlaces * prixSelectionne;
          return AlertDialog(
            backgroundColor: AppColors.cardBg,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Réserver',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text(event.titre,
                    style: const TextStyle(
                        color: AppColors.accent, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tarifs.length > 1) ...[
                    const Text('Type de tarif :',
                        style: TextStyle(
                            color: AppColors.textLight, fontSize: 12)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tarifs.map((t) {
                        final sel = tarifSelectionne == t.key;
                        return GestureDetector(
                          onTap: () => setDialogState(() {
                            tarifSelectionne = t.key;
                            prixSelectionne = t.prix;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? t.color.withOpacity(0.2)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: sel ? t.color : AppColors.divider,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(t.label,
                                    style: TextStyle(
                                        color: sel
                                            ? t.color
                                            : Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    '${t.prix.toStringAsFixed(0)} MAD',
                                    style: TextStyle(
                                        color: sel
                                            ? t.color
                                            : Colors.white54,
                                        fontSize: 11)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text('Nombre de places :',
                      style: TextStyle(color: AppColors.textLight)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: nbPlaces > 1
                            ? () => setDialogState(() => nbPlaces--)
                            : null,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: nbPlaces > 1
                                ? AppColors.accent
                                : AppColors.divider,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.remove,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text('$nbPlaces',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: nbPlaces < maxPlaces
                            ? () => setDialogState(() => nbPlaces++)
                            : null,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: nbPlaces < maxPlaces
                                ? AppColors.accent
                                : AppColors.divider,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '$nbPlaces × ${prixSelectionne.toStringAsFixed(0)} MAD',
                            style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 13)),
                        Text('${total.toStringAsFixed(2)} MAD',
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Annuler',
                    style: TextStyle(color: AppColors.textLight)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _naviguerVersPanierExterne(context, ref, event,
                      nbPlaces, prixSelectionne, tarifSelectionne);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('CONTINUER',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _naviguerVersPanierExterne(
      BuildContext context,
      WidgetRef ref,
      Evenement event,
      int nbPlaces,
      double prixUnitaire,
      String typeTarif,
      ) {
    ref.read(navigationProvider.notifier).setContext(
      seance: null,
      evenement: event,
      filmTitre: event.titre,
      salleId: 0,
      cinemaId: null,
    );

    ref.read(panierProvider.notifier).vider();

    for (int i = 0; i < nbPlaces; i++) {
      ref.read(panierProvider.notifier).ajouterSiege(
        SiegeSelectionne(
          siege: Siege(
            id: -i - 1,
            salleId: 0,
            numero: 'T${i + 1}',
            rangee: 'EXT',
            type: 'standard',
          ),
          typeBillet: typeTarif,
          prix: prixUnitaire,
        ),
      );
    }

    context.push('/panier');
  }

  Widget _buildTypeBadge(String type) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink)),
    child: Text(type.toUpperCase(),
        style: const TextStyle(
            color: Colors.pink,
            fontSize: 10,
            fontWeight: FontWeight.bold)),
  );

  Widget _buildCancelBadge(String text, {required bool isFree}) {
    final color = isFree ? Colors.green : Colors.orange;
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color)),
      child: Text(text.toUpperCase(),
          style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoSection(
      IconData icon, String title, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(icon, color: AppColors.accent, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15)),
                ]),
          ),
        ]),
      );

  Widget _buildStatusSection(Evenement event) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(Icons.event_seat,
            "${event.placesDisponibles ?? 0}", "Places dispo"),
        _buildStatItem(Icons.groups,
            "${event.placesTotales ?? 0}", "Capacité"),
        _buildStatItem(
          Icons.money_off,
          event.annulationGratuite == true
              ? "GRATUIT"
              : "${event.fraisAnnulation ?? 0.0} MAD",
          "Frais annulation",
        ),
      ],
    ),
  );

  Widget _buildStatItem(
      IconData icon, String value, String label) =>
      Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textLight, fontSize: 10)),
        ],
      );
}

class _TarifOption {
  final String key;
  final String label;
  final double prix;
  final Color color;
  const _TarifOption(this.key, this.label, this.prix, this.color);
}