import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/casa_sidebar.dart';
import 'package:intl/intl.dart';

class ManageSeancesCasaPage extends ConsumerStatefulWidget {
  const ManageSeancesCasaPage({super.key});

  @override
  ConsumerState<ManageSeancesCasaPage> createState() => _ManageSeancesCasaPageState();
}

class _ManageSeancesCasaPageState extends ConsumerState<ManageSeancesCasaPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final int casaCinemaId = 2; // ✅ FIX : ID Correct pour Casa

  @override
  Widget build(BuildContext context) {
    final seancesAsync = ref.watch(allSeancesProvider);
    final filmsAsync = ref.watch(prog.filmsProvider);
    final sallesAsync = ref.watch(sallesProvider(casaCinemaId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fab_seance_casa",
        onPressed: () => _showSeanceDialog(context),
        backgroundColor: Colors.amber,
        label: const Text("PROGRAMMER (CASA)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.black),
      ),
      body: Row(
        children: [
          const SizedBox(width: 280, child: CasaSidebar()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GESTION DES SÉANCES - CASABLANCA", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: seancesAsync.when(
                      data: (seances) => filmsAsync.when(
                        data: (films) => sallesAsync.when(
                          data: (salles) {
                            final salleIds = salles.map((s) => s.id).toSet();
                            // ✅ FILTRAGE STRICT : Uniquement les séances des salles de Casa
                            final casaSeances = seances.where((s) => salleIds.contains(s.salleId)).toList();

                            if (casaSeances.isEmpty) {
                              return const Center(child: Text("Aucune séance à Casablanca.", style: TextStyle(color: Colors.white54)));
                            }
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: casaSeances.length,
                              itemBuilder: (context, index) {
                                final seance = casaSeances[index];
                                final film = films.firstWhere((f) => f.id == seance.filmId, orElse: () => Film(titre: "Film inconnu"));
                                final salle = salles.firstWhere((sa) => sa.id == seance.salleId, orElse: () => Salle(cinemaId: casaCinemaId, codeSalle: "?", capacite: 0, typeProjection: ""));
                                return _buildSeanceCard(seance, film.titre, salle.codeSalle);
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text("Erreur salles: $e"),
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text("Erreur films: $e"),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
                      error: (e, __) => Center(child: Text("Erreur séances : $e")),
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

  Widget _buildSeanceCard(Seance seance, String filmTitre, String salleNom) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.videocam_outlined, color: Colors.amber),
        ),
        title: Text(filmTitre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Salle: $salleNom • ${seance.typeProjection} • ${seance.langue}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(_dateFormat.format(seance.dateHeure), style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent), onPressed: () => _showSeanceDialog(context, seance: seance)),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _confirmDeleteSeance(seance.id!, filmTitre)),
          ],
        ),
      ),
    );
  }

  void _showSeanceDialog(BuildContext context, {Seance? seance}) {
    int? selectedFilmId = seance?.filmId;
    int? selectedSalleId = seance?.salleId;
    DateTime selectedDate = seance?.dateHeure ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);

    final pNormal = TextEditingController(text: seance?.prixNormal.toString() ?? "60");
    final places = TextEditingController(text: seance?.placesDisponibles.toString() ?? "100");
    String langue = seance?.langue ?? "VF";
    String proj = seance?.typeProjection ?? "2D";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("PROGRAMMER CASA", style: TextStyle(color: Colors.amber)),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ref.watch(prog.filmsProvider).when(
              data: (films) => DropdownButtonFormField<int>(
                value: selectedFilmId,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: films.map((f) => DropdownMenuItem(value: f.id, child: Text(f.titre))).toList(),
                onChanged: (v) => setSt(() => selectedFilmId = v),
                decoration: const InputDecoration(labelText: "Film"),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text("Erreur films: $e"),
            ),
            // ✅ FIX : Utiliser casaCinemaId pour ne charger QUE les salles de Casa
            ref.watch(sallesProvider(casaCinemaId)).when(
              data: (salles) => DropdownButtonFormField<int>(
                value: selectedSalleId,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: salles.map((s) => DropdownMenuItem(value: s.id, child: Text("Salle ${s.codeSalle}"))).toList(),
                onChanged: (v) => setSt(() => selectedSalleId = v),
                decoration: const InputDecoration(labelText: "Salle"),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text("Erreur salles: $e"),
            ),
            _field(pNormal, "Prix (DH)"),
            _field(places, "Places", isNumber: true),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ANNULER")),
          ElevatedButton(onPressed: () async {
            if (selectedFilmId == null || selectedSalleId == null) return;
            final s = Seance(
              id: seance?.id,
              filmId: selectedFilmId!,
              salleId: selectedSalleId!,
              dateHeure: DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute),
              langue: langue,
              typeProjection: proj,
              typeSeance: "standard",
              placesDisponibles: int.tryParse(places.text) ?? 100,
              prixNormal: double.tryParse(pNormal.text) ?? 60.0,
            );
            if (seance == null) await client.admin.ajouterSeance(s); else await client.admin.modifierSeance(s);
            ref.invalidate(allSeancesProvider);
            Navigator.pop(ctx);
          }, child: const Text("VALIDER"))
        ],
      )),
    );
  }

  void _confirmDeleteSeance(int id, String filmTitre) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Supprimer la séance de $filmTitre ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("NON")),
          TextButton(onPressed: () async {
            await client.admin.supprimerSeance(id);
            ref.invalidate(allSeancesProvider);
            Navigator.pop(ctx);
          }, child: const Text("OUI")),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, {bool isNumber = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(controller: ctrl, keyboardType: isNumber ? TextInputType.number : TextInputType.text, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white10)),
    );
  }
}
