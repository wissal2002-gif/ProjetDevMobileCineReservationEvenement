import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManageSeancesPage extends ConsumerStatefulWidget {
  final int? cinemaId; // ✅ Ajoute ceci
  const ManageSeancesPage({super.key, this.cinemaId});
  @override
  ConsumerState<ManageSeancesPage> createState() => _ManageSeancesPageState();
}

class _ManageSeancesPageState extends ConsumerState<ManageSeancesPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final seancesAsync = ref.watch(allSeancesProvider);
    final filmsAsync = ref.watch(prog.filmsProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION DES SÉANCES"),
      ),
      body: seancesAsync.when(
        data: (seances) => filmsAsync.when(
          data: (films) => cinemasAsync.when(
            data: (cinemas) {
              if (seances.isEmpty) {
                return const Center(child: Text("Aucune séance programmée.", style: TextStyle(color: Colors.white54)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: seances.length,
                itemBuilder: (context, index) {
                  final seance = seances[index];
                  final film = films.firstWhere((f) => f.id == seance.filmId, orElse: () => Film(titre: "Film inconnu"));
                  
                  return Card(
                    color: Colors.white.withOpacity(0.05),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.videocam_outlined, color: AppColors.accent),
                      ),
                      title: Text(film.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salle ID: ${seance.salleId} • ${seance.typeProjection} • ${seance.langue}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          Text(_dateFormat.format(seance.dateHeure), style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text("Prix: ${seance.prixNormal} DH", style: const TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                            onPressed: () => _showEditSeanceDialog(context, seance, film.titre),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            onPressed: () => _confirmDeleteSeance(context, seance.id!, film.titre),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, __) => Center(child: Text("Erreur cinémas: $e")),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Center(child: Text("Erreur films: $e")),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text("Erreur séances : $e")),
      ),
    );
  }

  void _showEditSeanceDialog(BuildContext context, Seance seance, String filmTitre) {
    DateTime selectedDate = seance.dateHeure;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(seance.dateHeure);
    final prixNormalCtrl = TextEditingController(text: seance.prixNormal.toString());
    final prixReduitCtrl = TextEditingController(text: seance.prixReduit?.toString() ?? "40.0");
    String selectedLangue = seance.langue ?? "VF";
    String selectedProjection = seance.typeProjection ?? "2D";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: Text("Modifier séance : $filmTitre", style: const TextStyle(color: Colors.white, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final d = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now().subtract(const Duration(days: 30)), lastDate: DateTime.now().add(const Duration(days: 365)));
                          if (d != null) setDialogState(() => selectedDate = d);
                        },
                        child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final t = await showTimePicker(context: context, initialTime: selectedTime);
                          if (t != null) setDialogState(() => selectedTime = t);
                        },
                        child: Text(selectedTime.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _adminTextField(prixNormalCtrl, "Prix Normal (DH)", keyboardType: TextInputType.number),
                _adminTextField(prixReduitCtrl, "Prix Réduit (DH)", keyboardType: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: selectedLangue,
                  dropdownColor: AppColors.cardBg,
                  decoration: const InputDecoration(labelText: "Langue"),
                  items: ["VF", "VOSTFR", "VO"].map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (v) => setDialogState(() => selectedLangue = v!),
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
              onPressed: () async {
                final fullDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                final updatedSeance = seance.copyWith(
                  dateHeure: fullDate,
                  prixNormal: double.tryParse(prixNormalCtrl.text) ?? seance.prixNormal,
                  prixReduit: double.tryParse(prixReduitCtrl.text),
                  langue: selectedLangue,
                  typeProjection: selectedProjection,
                );
                
                try {
                  await client.admin.modifierSeance(updatedSeance);
                  ref.invalidate(allSeancesProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  print("Erreur modification: $e");
                }
              },
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSeance(BuildContext context, int id, String filmTitre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer la séance ?"),
        content: Text("Voulez-vous supprimer cette séance pour '$filmTitre' ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              try {
                await client.admin.supprimerSeance(id);
                ref.invalidate(allSeancesProvider);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                print("Erreur suppression: $e");
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
