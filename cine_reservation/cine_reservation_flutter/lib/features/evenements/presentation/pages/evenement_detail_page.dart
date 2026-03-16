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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: eventAsync.when(
        data: (events) {
          final event = events.firstWhere((e) => e.id == evenementId);
          return _buildContent(context, ref, event, cinemasAsync);
        },
        loading: () =>
        const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, s) =>
            Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Evenement event,
      AsyncValue<List<Cinema>> cinemasAsync) {
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    final timeFormat = DateFormat('HH:mm');

    String cinemaInfo = event.lieu ?? "Lieu non spécifié";
    cinemasAsync.whenData((list) {
      if (event.cinemaId != null) {
        final cinema = list.firstWhere((c) => c.id == event.cinemaId,
            orElse: () => list.first);
        cinemaInfo = "${cinema.nom} (${cinema.ville})";
      }
    });

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
                    child: const Icon(Icons.event, size: 100),
                  ),
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
                if (event.bandeAnnonce != null && event.bandeAnnonce!.isNotEmpty)
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
                    if (event.annulationGratuite ?? false)
                      _buildCancelBadge("Annulation gratuite"),
                  ],
                ),
                const SizedBox(height: 15),
                Text(event.titre,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text(
                      "${event.noteMoyenne ?? 0.0} (${event.nombreAvis ?? 0} avis)",
                      style: const TextStyle(color: AppColors.textLight)),
                ]),
                const SizedBox(height: 30),
                _buildInfoSection(Icons.calendar_today, "DATE ET HEURE",
                    "${dateFormat.format(event.dateDebut)} à ${timeFormat.format(event.dateDebut)}"),
                _buildInfoSection(Icons.location_on, "LIEU / CINÉMA", cinemaInfo),
                _buildInfoSection(Icons.person, "ORGANISATEUR",
                    event.organisateur ?? "Non spécifié"),
                if (event.annulationGratuite ?? false)
                  _buildInfoSection(Icons.history, "DÉLAI D'ANNULATION",
                      "Jusqu'à ${event.delaiAnnulation ?? 48} heures avant l'événement"),
                const SizedBox(height: 30),
                const Text("À PROPOS DE CET ÉVÉNEMENT",
                    style: TextStyle(
                        color: AppColors.accent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(event.description ?? "Pas de description disponible.",
                    style: const TextStyle(color: Colors.white70, height: 1.6)),
                const SizedBox(height: 30),
                _buildStatusSection(event),
                const SizedBox(height: 40),
                _buildPriceAndBooking(context, ref, event),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndBooking(
      BuildContext context, WidgetRef ref, Evenement event) {
    final bool isFull = (event.placesDisponibles ?? 0) <= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [AppColors.accent.withOpacity(0.2), AppColors.background]),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("PRIX PAR PLACE",
                    style:
                    TextStyle(color: AppColors.textLight, fontSize: 10)),
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isFull
                  ? null
                  : () => _showReservationDialog(context, ref, event),
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

  void _showReservationDialog(
      BuildContext context, WidgetRef ref, Evenement event) {
    int nbPlaces = 1;
    final maxPlaces = event.placesDisponibles ?? 1;
    final prix = event.prix ?? 0.0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final total = nbPlaces * prix;
          return AlertDialog(
            backgroundColor: AppColors.cardBg,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Réserver',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(event.titre,
                    style: const TextStyle(
                        color: AppColors.accent, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nombre de places :',
                    style: TextStyle(color: AppColors.textLight)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouton -
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
                    // Bouton +
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$nbPlaces × ${prix.toStringAsFixed(0)} MAD',
                          style: const TextStyle(
                              color: AppColors.textLight, fontSize: 13)),
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
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Annuler',
                    style: TextStyle(color: AppColors.textLight)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _naviguerVersPanier(context, ref, event, nbPlaces, prix);
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

  void _naviguerVersPanier(BuildContext context, WidgetRef ref,
      Evenement event, int nbPlaces, double prixUnitaire) {
    // Vider le panier et ajouter les places événement
    ref.read(panierProvider.notifier).vider();
    for (int i = 0; i < nbPlaces; i++) {
      ref.read(panierProvider.notifier).ajouterSiege(
        SiegeSelectionne(
          siege: Siege(
            salleId: 0,
            numero: 'P${i + 1}',
            rangee: 'EVENT',
            type: 'standard',
          ),
          typeBillet: 'evenement',
          prix: prixUnitaire,
        ),
      );
    }

    // Stocker dans navigationProvider
    ref.read(navigationProvider.notifier).setContext(
      seance: null,
      evenement: event,
      filmTitre: event.titre,
      salleId: 0,
    );

    // Naviguer vers le panier
    context.push('/panier');
  }

  Widget _buildTypeBadge(String type) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink)),
    child: Text(type.toUpperCase(),
        style: const TextStyle(
            color: Colors.pink, fontSize: 10, fontWeight: FontWeight.bold)),
  );

  Widget _buildCancelBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green)),
    child: Text(text.toUpperCase(),
        style: const TextStyle(
            color: Colors.green,
            fontSize: 10,
            fontWeight: FontWeight.bold)),
  );

  Widget _buildInfoSection(IconData icon, String title, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(icon, color: AppColors.accent, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 15)),
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
        _buildStatItem(
            Icons.groups, "${event.placesTotales ?? 0}", "Capacité"),
        _buildStatItem(Icons.monetization_on,
            "${event.fraisAnnulation ?? 0.0}", "Frais annulation"),
      ],
    ),
  );

  Widget _buildStatItem(IconData icon, String value, String label) => Column(
    children: [
      Icon(icon, color: AppColors.accent, size: 20),
      const SizedBox(height: 5),
      Text(value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      Text(label,
          style:
          const TextStyle(color: AppColors.textLight, fontSize: 10)),
    ],
  );
}