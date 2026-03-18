import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';
import 'package:intl/intl.dart';

class ManageSeancesTangerPage extends ConsumerStatefulWidget {
  const ManageSeancesTangerPage({super.key});

  @override
  ConsumerState<ManageSeancesTangerPage> createState() => _ManageSeancesTangerPageState();
}

class _ManageSeancesTangerPageState extends ConsumerState<ManageSeancesTangerPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final int tangerCinemaId = 9;

  @override
  Widget build(BuildContext context) {
    final seancesAsync = ref.watch(allSeancesProvider);
    final filmsAsync = ref.watch(prog.filmsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fab_seance_tanger",
        onPressed: () => _showSeanceDialog(context),
        backgroundColor: Colors.amber,
        label: const Text("PROGRAMMER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.black),
      ),
      body: Row(
        children: [
          const SizedBox(width: 280, child: TangerSidebar()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "GESTION DES SÉANCES - TANGER",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: seancesAsync.when(
                      data: (seances) => filmsAsync.when(
                        data: (films) {
                          if (seances.isEmpty) {
                            return const Center(child: Text("Aucune séance programmée.", style: TextStyle(color: Colors.white54)));
                          }
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: seances.length,
                            itemBuilder: (context, index) {
                              final seance = seances[index];
                              final film = films.firstWhere((f) => f.id == seance.filmId, orElse: () => Film(titre: "Film inconnu"));
                              return _buildSeanceCard(seance, film.titre);
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
                        error: (e, __) => Center(child: Text("Erreur films: $e")),
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

  Widget _buildSeanceCard(Seance seance, String filmTitre) {
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
            Text("Salle: ${seance.salleId} • ${seance.typeProjection} • ${seance.langue}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(_dateFormat.format(seance.dateHeure), style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
              onPressed: () => _showSeanceDialog(context, seance: seance),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _confirmDeleteSeance(seance.id!, filmTitre),
            ),
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
    final pVip = TextEditingController(text: seance?.prixVip?.toString() ?? "100");
    final pEnfant = TextEditingController(text: seance?.prixEnfant?.toString() ?? "40");
    final pSenior = TextEditingController(text: seance?.prixSenior?.toString() ?? "50");
    final pReduit = TextEditingController(text: seance?.prixReduit?.toString() ?? "45");
    final places = TextEditingController(text: seance?.placesDisponibles.toString() ?? "100");

    String langue = seance?.langue ?? "VF";
    String proj = seance?.typeProjection ?? "2D";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setSt) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("PROGRAMMATION DÉTAILLÉE", style: TextStyle(color: Colors.amber)),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Dropdown Film
            ref.watch(prog.filmsProvider).when(
              data: (films) => DropdownButtonFormField<int>(
                value: selectedFilmId,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: films.map((f) => DropdownMenuItem(value: f.id, child: Text(f.titre))).toList(),
                onChanged: (v) => setSt(() => selectedFilmId = v),
                decoration: const InputDecoration(labelText: "Film", labelStyle: TextStyle(color: Colors.amber)),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const Text("Erreur films"),
            ),
            const SizedBox(height: 10),
            // Dropdown Salle
            ref.watch(sallesProvider(tangerCinemaId)).when(
              data: (salles) => DropdownButtonFormField<int>(
                value: selectedSalleId,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: salles.map((s) => DropdownMenuItem(value: s.id, child: Text("Salle ${s.codeSalle}"))).toList(),
                onChanged: (v) => setSt(() => selectedSalleId = v),
                decoration: const InputDecoration(labelText: "Salle", labelStyle: TextStyle(color: Colors.amber)),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const Text("Erreur salles"),
            ),
            const SizedBox(height: 15),
            // Date et Heure
            Row(children: [
              Expanded(child: TextButton(
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                  if (d != null) setSt(() => selectedDate = d);
                },
                child: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
              )),
              Expanded(child: TextButton(
                onPressed: () async {
                  final t = await showTimePicker(context: context, initialTime: selectedTime);
                  if (t != null) setSt(() => selectedTime = t);
                },
                child: Text(selectedTime.format(context)),
              )),
            ]),
            _field(pNormal, "Prix Normal (DH)"),
            _field(pVip, "Prix VIP (DH)"),
            _field(pEnfant, "Prix Enfant (DH)"),
            _field(pSenior, "Prix Senior (DH)"),
            _field(pReduit, "Prix Réduit (DH)"),
            _field(places, "Places disponibles", isNumber: true),
            DropdownButtonFormField<String>(
              value: langue,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: ["VF", "VOSTFR", "VO"].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (v) => setSt(() => langue = v!),
              decoration: const InputDecoration(labelText: "Langue"),
            ),
            DropdownButtonFormField<String>(
              value: proj,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: ["2D", "3D", "IMAX", "4DX"].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (v) => setSt(() => proj = v!),
              decoration: const InputDecoration(labelText: "Projection"),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          ElevatedButton(onPressed: () async {
            if (selectedFilmId == null || selectedSalleId == null) return;

            final finalDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);

            final s = Seance(
              id: seance?.id,
              filmId: selectedFilmId!,
              salleId: selectedSalleId!,
              dateHeure: finalDateTime,
              langue: langue,
              typeProjection: proj,
              typeSeance: "standard",
              placesDisponibles: int.tryParse(places.text) ?? 100,
              prixNormal: double.tryParse(pNormal.text) ?? 0.0,
              prixVip: double.tryParse(pVip.text) ?? 0.0,
              prixEnfant: double.tryParse(pEnfant.text) ?? 0.0,
              prixSenior: double.tryParse(pSenior.text) ?? 0.0,
              prixReduit: double.tryParse(pReduit.text) ?? 0.0,
            );

            if (seance == null) await client.admin.ajouterSeance(s);
            else await client.admin.modifierSeance(s);

            ref.invalidate(allSeancesProvider);
            Navigator.pop(context);
          }, child: const Text("VALIDER"))
        ],
      )),
    );
  }

  void _confirmDeleteSeance(int id, String filmTitre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Supprimer ?"),
        content: Text("Supprimer la séance pour '$filmTitre' ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("NON")),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerSeance(id);
              ref.invalidate(allSeancesProvider);
              Navigator.pop(context);
            },
            child: const Text("OUI, SUPPRIMER", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, {bool isNumber = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}