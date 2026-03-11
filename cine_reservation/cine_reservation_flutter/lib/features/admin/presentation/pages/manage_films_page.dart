import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManageFilmsPage extends ConsumerStatefulWidget {
  const ManageFilmsPage({super.key});

  @override
  ConsumerState<ManageFilmsPage> createState() => _ManageFilmsPageState();
}

class _ManageFilmsPageState extends ConsumerState<ManageFilmsPage> {
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final filmsAsync = ref.watch(prog.filmsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("ADMIN : GESTION EXPERTE FILMS"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_to_photos, color: AppColors.accent),
            onPressed: () => _showExpertFilmDialog(context),
            tooltip: "Ajouter un nouveau film",
          )
        ],
      ),
      body: filmsAsync.when(
        data: (films) => ListView.builder(
          itemCount: films.length,
          itemBuilder: (context, index) {
            final film = films[index];
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: film.affiche != null && film.affiche!.isNotEmpty
                      ? Image.network(film.affiche!, width: 45, height: 70, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.movie))
                      : const Icon(Icons.movie, color: Colors.white24),
                ),
                title: Text(film.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text("${film.genre ?? "N/A"} • ${film.duree ?? 0} min • ${film.langue}", style: const TextStyle(color: Colors.white54)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month, color: AppColors.accent),
                      onPressed: () => _showProgramDialog(context, film),
                      tooltip: "Programmer une séance",
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(context, film.id!, film.titre),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Réalisateur:", film.realisateur ?? "Inconnu"),
                        _infoRow("Casting:", film.casting ?? "N/A"),
                        _infoRow("Note Moyenne:", "${film.noteMoyenne ?? 0.0} / 5"),
                        _infoRow("Classification:", film.classification ?? "Tout public"),
                        _infoRow("Exploitation:", "${film.dateDebut != null ? _dateFormat.format(film.dateDebut!) : '?'} au ${film.dateFin != null ? _dateFormat.format(film.dateFin!) : '?'}"),
                        const SizedBox(height: 8),
                        Text(film.synopsis ?? "Pas de synopsis", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, s) => Center(child: Text("Erreur : $e", style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 12))),
        ],
      ),
    );
  }

  void _showProgramDialog(BuildContext context, Film film) {
    int? selectedCinemaId;
    int? selectedSalleId;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    final prixNormalCtrl = TextEditingController(text: "50.0");
    final prixReduitCtrl = TextEditingController(text: "40.0");
    final prixEnfantCtrl = TextEditingController(text: "30.0");
    final prixVipCtrl = TextEditingController(text: "100.0");

    String selectedLangue = film.langue ?? "VF";
    String selectedProjection = "2D";
    String selectedTypeSeance = "standard";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final cinemasAsync = ref.watch(allCinemasProvider);

          return AlertDialog(
            backgroundColor: AppColors.cardBg,
            title: Text("Programmer : ${film.titre}", style: const TextStyle(color: Colors.white, fontSize: 18)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cinemasAsync.when(
                    data: (cinemas) => DropdownButtonFormField<int>(
                      dropdownColor: AppColors.cardBg,
                      decoration: const InputDecoration(labelText: "Cinéma", labelStyle: TextStyle(color: Colors.white70)),
                      items: cinemas.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nom, style: const TextStyle(color: Colors.white)))).toList(),
                      onChanged: (val) => setDialogState(() { selectedCinemaId = val; selectedSalleId = null; }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text("Erreur cinémas"),
                  ),
                  if (selectedCinemaId != null)
                    ref.watch(sallesProvider(selectedCinemaId!)).when(
                      data: (salles) => DropdownButtonFormField<int>(
                        dropdownColor: AppColors.cardBg,
                        decoration: const InputDecoration(labelText: "Salle", labelStyle: TextStyle(color: Colors.white70)),
                        items: salles.map((s) => DropdownMenuItem(value: s.id, child: Text("${s.codeSalle} (${s.capacite} pl.)", style: const TextStyle(color: Colors.white)))).toList(),
                        onChanged: (val) => setDialogState(() => selectedSalleId = val),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const Text("Erreur salles"),
                    ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(selectedDate == null ? "Date" : _dateFormat.format(selectedDate!)),
                          onPressed: () async {
                            final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                            if (date != null) setDialogState(() => selectedDate = date);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.access_time, size: 18),
                          label: Text(selectedTime == null ? "Heure" : selectedTime!.format(context)),
                          onPressed: () async {
                            final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                            if (time != null) setDialogState(() => selectedTime = time);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedLangue,
                          dropdownColor: AppColors.cardBg,
                          decoration: const InputDecoration(labelText: "Langue Séance"),
                          items: ["VF", "VOSTFR", "VO"].map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(color: Colors.white)))).toList(),
                          onChanged: (v) => setDialogState(() => selectedLangue = v!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedTypeSeance,
                          dropdownColor: AppColors.cardBg,
                          decoration: const InputDecoration(labelText: "Type Séance"),
                          items: [
                            DropdownMenuItem(value: "standard", child: Text("Standard", style: const TextStyle(color: Colors.white, fontSize: 12))),
                            DropdownMenuItem(value: "avant_premiere", child: Text("Avant-première", style: const TextStyle(color: Colors.white, fontSize: 12))),
                            DropdownMenuItem(value: "privee", child: Text("Séance privée", style: const TextStyle(color: Colors.white, fontSize: 12))),
                          ].toList(),
                          onChanged: (v) => setDialogState(() => selectedTypeSeance = v!),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _adminTextField(prixNormalCtrl, "Prix Normal", keyboardType: TextInputType.number)),
                      const SizedBox(width: 8),
                      Expanded(child: _adminTextField(prixReduitCtrl, "Prix Réduit", keyboardType: TextInputType.number)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _adminTextField(prixEnfantCtrl, "Enfant", keyboardType: TextInputType.number)),
                      const SizedBox(width: 8),
                      Expanded(child: _adminTextField(prixVipCtrl, "VIP", keyboardType: TextInputType.number)),
                    ],
                  ),

                  DropdownButtonFormField<String>(
                    value: selectedProjection,
                    dropdownColor: AppColors.cardBg,
                    decoration: const InputDecoration(labelText: "Projection"),
                    items: ["2D", "3D", "IMAX", "4DX"].map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(color: Colors.white)))).toList(),
                    onChanged: (v) => setDialogState(() => selectedProjection = v!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
              ElevatedButton(
                onPressed: (selectedSalleId == null || selectedDate == null || selectedTime == null) ? null : () async {
                  final fullDate = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute);
                  final seance = Seance(
                    filmId: film.id!,
                    salleId: selectedSalleId!,
                    dateHeure: fullDate,
                    prixNormal: double.parse(prixNormalCtrl.text),
                    prixReduit: double.parse(prixReduitCtrl.text),
                    prixEnfant: double.parse(prixEnfantCtrl.text),
                    prixVip: double.parse(prixVipCtrl.text),
                    langue: selectedLangue,
                    typeProjection: selectedProjection,
                    typeSeance: selectedTypeSeance,
                    placesDisponibles: 100, 
                  );
                  await client.admin.ajouterSeance(seance);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text("Valider"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showExpertFilmDialog(BuildContext context) {
    final titreCtrl = TextEditingController();
    final genreCtrl = TextEditingController();
    final dureeCtrl = TextEditingController();
    final realisateurCtrl = TextEditingController();
    final castingCtrl = TextEditingController();
    final afficheCtrl = TextEditingController();
    final trailerCtrl = TextEditingController();
    final synopsisCtrl = TextEditingController();
    final noteCtrl = TextEditingController(text: "0.0");
    String selectedLangue = "VF";
    String selectedClassif = "Tout public";
    DateTime? dateDebut;
    DateTime? dateFin;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: const Text("Nouvelle Fiche Film Expert", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _adminTextField(titreCtrl, "Titre du film"),
                _adminTextField(genreCtrl, "Genre"),
                _adminTextField(castingCtrl, "Casting principal", maxLines: 2),
                Row(
                  children: [
                    Expanded(child: _adminTextField(dureeCtrl, "Durée (min)", keyboardType: TextInputType.number)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _adminTextField(noteCtrl, "Note Moyenne (0-5)", keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedLangue,
                        dropdownColor: AppColors.cardBg,
                        decoration: const InputDecoration(labelText: "Langue Film"),
                        items: ["VF", "VOSTFR", "VO"].map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(color: Colors.white)))).toList(),
                        onChanged: (v) => setDialogState(() => selectedLangue = v!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedClassif,
                        dropdownColor: AppColors.cardBg,
                        decoration: const InputDecoration(labelText: "Classif."),
                        items: ["Tout public", "-12 ans", "-16 ans", "-18 ans"].map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: Colors.white, fontSize: 12)))).toList(),
                        onChanged: (v) => setDialogState(() => selectedClassif = v!),
                      ),
                    ),
                  ],
                ),
                _adminTextField(realisateurCtrl, "Réalisateur"),
                _adminTextField(afficheCtrl, "URL Affiche"),
                _adminTextField(trailerCtrl, "URL Bande-Annonce"),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.date_range, size: 16),
                        label: Text(dateDebut == null ? "Début" : _dateFormat.format(dateDebut!), style: const TextStyle(fontSize: 11)),
                        onPressed: () async {
                          final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                          if (d != null) setDialogState(() => dateDebut = d);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.date_range, size: 16),
                        label: Text(dateFin == null ? "Fin" : _dateFormat.format(dateFin!), style: const TextStyle(fontSize: 11)),
                        onPressed: () async {
                          final d = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 30)), firstDate: DateTime(2020), lastDate: DateTime(2030));
                          if (d != null) setDialogState(() => dateFin = d);
                        },
                      ),
                    ),
                  ],
                ),
                _adminTextField(synopsisCtrl, "Synopsis complet", maxLines: 4),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                final film = Film(
                  titre: titreCtrl.text,
                  genre: genreCtrl.text,
                  duree: int.tryParse(dureeCtrl.text),
                  realisateur: realisateurCtrl.text,
                  casting: castingCtrl.text,
                  affiche: afficheCtrl.text,
                  bandeAnnonce: trailerCtrl.text,
                  classification: selectedClassif,
                  synopsis: synopsisCtrl.text,
                  langue: selectedLangue,
                  dateDebut: dateDebut,
                  dateFin: dateFin,
                  noteMoyenne: double.tryParse(noteCtrl.text) ?? 0.0,
                  nombreAvis: 0,
                );
                try {
                  await client.admin.ajouterFilm(film);
                  ref.invalidate(prog.filmsProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  print("Erreur: $e");
                }
              },
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, String titre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer ?", style: TextStyle(color: Colors.white)),
        content: Text("Voulez-vous vraiment supprimer '$titre' et toutes ses séances ?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await client.admin.supprimerFilm(id);
                ref.invalidate(prog.filmsProvider);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                print("Erreur: $e");
              }
            },
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );
  }

  Widget _adminTextField(TextEditingController ctrl, String label, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
