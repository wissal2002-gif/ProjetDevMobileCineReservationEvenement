import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:intl/intl.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';

class ManageSeancesLocalPage extends ConsumerStatefulWidget {
  const ManageSeancesLocalPage({super.key});

  @override
  ConsumerState<ManageSeancesLocalPage> createState() =>
      _ManageSeancesLocalPageState();
}

class _ManageSeancesLocalPageState
    extends ConsumerState<ManageSeancesLocalPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final admin = ref.watch(adminProfileProvider).value;
    final cinemaId = admin?.cinemaId;

    final seancesAsync = ref.watch(allSeancesProvider);
    final filmsAsync = ref.watch(prog.filmsProvider);
    final sallesAsync = cinemaId != null
        ? ref.watch(sallesProvider(cinemaId))
        : const AsyncValue<List<Salle>>.loading();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: cinemaId == null
          ? null
          : FloatingActionButton.extended(
        heroTag: "fab_seance_local",
        onPressed: () => _showSeanceDialog(context, cinemaId: cinemaId),
        backgroundColor: Colors.amber,
        label: const Text("PROGRAMMER",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.black),
      ),
      body: Row(
        children: [
          if (!isMobile) const LocalAdminSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GESTION DES SÉANCES - ${admin?.nomCinema?.toUpperCase() ?? 'CINÉMA'}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: seancesAsync.when(
                      data: (seances) => filmsAsync.when(
                        data: (films) => sallesAsync.when(
                          data: (salles) {
                            final salleIds =
                            salles.map((s) => s.id).toSet();
                            // FILTRAGE DYNAMIQUE PAR CINÉMA
                            final localSeances = seances
                                .where((s) =>
                            s.cinemaId == cinemaId ||
                                salleIds.contains(s.salleId))
                                .toList();

                            if (localSeances.isEmpty) {
                              return const Center(
                                child: Text(
                                  "Aucune séance programmée.",
                                  style: TextStyle(color: Colors.white54),
                                ),
                              );
                            }

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: localSeances.length,
                              itemBuilder: (context, index) {
                                final seance = localSeances[index];
                                final film = films.firstWhere(
                                      (f) => f.id == seance.filmId,
                                  orElse: () =>
                                      Film(titre: "Film inconnu"),
                                );
                                final salle = salles.firstWhere(
                                      (s) => s.id == seance.salleId,
                                  orElse: () => Salle(
                                      cinemaId: cinemaId ?? 0,
                                      codeSalle: "?",
                                      capacite: 0,
                                      typeProjection: ""),
                                );
                                return _buildSeanceCard(
                                  seance,
                                  film.titre,
                                  salle.codeSalle,
                                  cinemaId: cinemaId!,
                                );
                              },
                            );
                          },
                          loading: () => const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.amber)),
                          error: (e, _) => Center(
                              child: Text("Erreur salles: $e",
                                  style: const TextStyle(
                                      color: Colors.redAccent))),
                        ),
                        loading: () => const Center(
                            child: CircularProgressIndicator(
                                color: Colors.amber)),
                        error: (e, _) => Center(
                            child: Text("Erreur films: $e",
                                style: const TextStyle(
                                    color: Colors.redAccent))),
                      ),
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              color: Colors.amber)),
                      error: (e, _) => Center(
                          child: Text("Erreur séances: $e",
                              style: const TextStyle(
                                  color: Colors.redAccent))),
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

  // ── CARD SÉANCE ───────────────────────────────────────────────────────────

  Widget _buildSeanceCard(
      Seance seance,
      String filmTitre,
      String salleNom, {
        required int cinemaId,
      }) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child:
          const Icon(Icons.videocam_outlined, color: Colors.amber),
        ),
        title: Text(filmTitre,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Salle: $salleNom • ${seance.typeProjection} • ${seance.langue}",
              style:
              const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              _dateFormat.format(seance.dateHeure),
              style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: Colors.blueAccent),
              onPressed: () => _showSeanceDialog(context,
                  seance: seance, cinemaId: cinemaId),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Colors.redAccent),
              onPressed: () =>
                  _confirmDeleteSeance(seance.id!, filmTitre),
            ),
          ],
        ),
      ),
    );
  }

  // ── DIALOG AJOUT / MODIFICATION ───────────────────────────────────────────

  void _showSeanceDialog(
      BuildContext context, {
        Seance? seance,
        required int cinemaId,
      }) {
    int? selectedFilmId = seance?.filmId;
    int? selectedSalleId = seance?.salleId;
    DateTime selectedDate = seance?.dateHeure ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);

    final pNormal =
    TextEditingController(text: seance?.prixNormal.toString() ?? "60");
    final pVip = TextEditingController(
        text: seance?.prixVip?.toString() ?? "100");
    final pEnfant = TextEditingController(
        text: seance?.prixEnfant?.toString() ?? "40");
    final pSenior = TextEditingController(
        text: seance?.prixSenior?.toString() ?? "50");
    final pReduit = TextEditingController(
        text: seance?.prixReduit?.toString() ?? "45");
    final places = TextEditingController(
        text: seance?.placesDisponibles.toString() ?? "100");

    String langue = seance?.langue ?? "VF";
    String proj = seance?.typeProjection ?? "2D";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSt) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text("PROGRAMMATION DÉTAILLÉE",
              style: TextStyle(color: Colors.amber)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── FILM ─────────────────────────────────────────
                ref.watch(prog.filmsProvider).when(
                  data: (films) {
                    final localFilms = films
                        .where((f) => f.cinemaId == cinemaId)
                        .toList();
                    return DropdownButtonFormField<int>(
                      value: selectedFilmId,
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white),
                      items: localFilms
                          .map((f) => DropdownMenuItem(
                          value: f.id, child: Text(f.titre)))
                          .toList(),
                      onChanged: (v) =>
                          setSt(() => selectedFilmId = v),
                      decoration: const InputDecoration(
                          labelText: "Film",
                          labelStyle:
                          TextStyle(color: Colors.amber)),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) =>
                  const Text("Erreur films",
                      style: TextStyle(color: Colors.redAccent)),
                ),
                const SizedBox(height: 10),

                // ── SALLE ─────────────────────────────────────────
                ref.watch(sallesProvider(cinemaId)).when(
                  data: (salles) => DropdownButtonFormField<int>(
                    value: selectedSalleId,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    items: salles
                        .map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text("Salle ${s.codeSalle}")))
                        .toList(),
                    onChanged: (v) =>
                        setSt(() => selectedSalleId = v),
                    decoration: const InputDecoration(
                        labelText: "Salle",
                        labelStyle:
                        TextStyle(color: Colors.amber)),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) =>
                  const Text("Erreur salles",
                      style: TextStyle(color: Colors.redAccent)),
                ),
                const SizedBox(height: 15),

                // ── DATE & HEURE ──────────────────────────────────
                Row(children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 90)),
                        );
                        if (d != null) setSt(() => selectedDate = d);
                      },
                      child: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(selectedDate),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final t = await showTimePicker(
                            context: context,
                            initialTime: selectedTime);
                        if (t != null) setSt(() => selectedTime = t);
                      },
                      child: Text(selectedTime.format(context),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ]),

                // ── PRIX ──────────────────────────────────────────
                _field(pNormal, "Prix Normal (DH)"),
                _field(pVip, "Prix VIP (DH)"),
                _field(pEnfant, "Prix Enfant (DH)"),
                _field(pSenior, "Prix Senior (DH)"),
                _field(pReduit, "Prix Réduit (DH)"),
                _field(places, "Places disponibles"),

                // ── LANGUE ────────────────────────────────────────
                DropdownButtonFormField<String>(
                  value: langue,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  items: ["VF", "VOSTFR", "VO", "EN","AR"]
                      .map((l) => DropdownMenuItem(
                      value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) => setSt(() => langue = v!),
                  decoration:
                  const InputDecoration(labelText: "Langue"),
                ),

                // ── PROJECTION ────────────────────────────────────
                DropdownButtonFormField<String>(
                  value: proj,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  items: ["2D", "3D", "IMAX", "4DX"]
                      .map((l) => DropdownMenuItem(
                      value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) => setSt(() => proj = v!),
                  decoration: const InputDecoration(
                      labelText: "Projection"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ANNULER",
                  style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black),
              onPressed: () async {
                if (selectedFilmId == null ||
                    selectedSalleId == null) return;

                final finalDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final s = Seance(
                  id: seance?.id,
                  filmId: selectedFilmId!,
                  cinemaId: cinemaId,
                  salleId: selectedSalleId!,
                  dateHeure: finalDateTime,
                  langue: langue,
                  typeProjection: proj,
                  typeSeance: "standard",
                  placesDisponibles:
                  int.tryParse(places.text) ?? 100,
                  prixNormal:
                  double.tryParse(pNormal.text) ?? 0.0,
                  prixVip: double.tryParse(pVip.text) ?? 0.0,
                  prixEnfant:
                  double.tryParse(pEnfant.text) ?? 0.0,
                  prixSenior:
                  double.tryParse(pSenior.text) ?? 0.0,
                  prixReduit:
                  double.tryParse(pReduit.text) ?? 0.0,
                );

                if (seance == null) {
                  await client.admin.ajouterSeance(s);
                } else {
                  await client.admin.modifierSeance(s);
                }

                ref.invalidate(allSeancesProvider);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("VALIDER"),
            ),
          ],
        ),
      ),
    );
  }

  // ── SUPPRESSION ───────────────────────────────────────────────────────────

  void _confirmDeleteSeance(int id, String filmTitre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Supprimer ?",
            style: TextStyle(color: Colors.white)),
        content: Text(
          "Supprimer la séance pour '$filmTitre' ?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("NON",
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerSeance(id);
              ref.invalidate(allSeancesProvider);
              ref.invalidate(prog.filmsProvider);        // ✅ AJOUTER
              ref.invalidate(allFilmsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("OUI, SUPPRIMER",
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // ── CHAMP TEXTE ───────────────────────────────────────────────────────────

  Widget _field(TextEditingController ctrl, String label,
      {bool isNumber = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: ctrl,
        keyboardType:
        isNumber ? TextInputType.number : TextInputType.text,
        style:
        const TextStyle(color: Colors.white, fontSize: 14),
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