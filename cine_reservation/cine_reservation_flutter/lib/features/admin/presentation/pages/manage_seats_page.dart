import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';

class ManageSeatsPage extends ConsumerStatefulWidget {
  const ManageSeatsPage({super.key});

  @override
  ConsumerState<ManageSeatsPage> createState() => _ManageSeatsPageState();
}

class _ManageSeatsPageState extends ConsumerState<ManageSeatsPage> {
  int? selectedCinemaId;
  int? selectedSalleId;

  @override
  Widget build(BuildContext context) {
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION DES SIÈGES"),
      ),
      body: Column(
        children: [
          // ─── SÉLECTION CINÉMA & SALLE ───
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: cinemasAsync.when(
                    data: (cinemas) => DropdownButtonFormField<int>(
                      dropdownColor: AppColors.cardBg,
                      value: selectedCinemaId,
                      decoration: const InputDecoration(labelText: "Cinéma"),
                      items: cinemas.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nom, style: const TextStyle(color: Colors.white)))).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCinemaId = val;
                          selectedSalleId = null;
                        });
                      },
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text("Erreur"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: selectedCinemaId == null 
                    ? const SizedBox()
                    : ref.watch(sallesProvider(selectedCinemaId!)).when(
                        data: (salles) => DropdownButtonFormField<int>(
                          dropdownColor: AppColors.cardBg,
                          value: selectedSalleId,
                          decoration: const InputDecoration(labelText: "Salle"),
                          items: salles.map((s) => DropdownMenuItem(value: s.id, child: Text(s.codeSalle, style: const TextStyle(color: Colors.white)))).toList(),
                          onChanged: (val) => setState(() => selectedSalleId = val),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => const Text("Erreur"),
                      ),
                ),
              ],
            ),
          ),

          // ─── AFFICHAGE / GÉNÉRATION DES SIÈGES ───
          Expanded(
            child: selectedSalleId == null
              ? const Center(child: Text("Veuillez choisir une salle", style: TextStyle(color: Colors.white54)))
              : ref.watch(siegesBySalleProvider(selectedSalleId!)).when(
                  data: (sieges) {
                    if (sieges.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Aucun siège configuré.", style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => _showGenerateDialog(context, selectedSalleId!),
                              icon: const Icon(Icons.grid_on),
                              label: const Text("Générer automatiquement"),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10, // À dynamiser selon configuration
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: sieges.length,
                      itemBuilder: (context, index) {
                        final siege = sieges[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.2),
                            border: Border.all(color: AppColors.accent),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              siege.numero,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, __) => Center(child: Text("Erreur : $e")),
                ),
          ),
        ],
      ),
    );
  }

  void _showGenerateDialog(BuildContext context, int salleId) {
    final rowsCtrl = TextEditingController(text: "8");
    final colsCtrl = TextEditingController(text: "10");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Configuration de la salle", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rowsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Nombre de rangées (A, B, C...)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: colsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Sièges par rangée"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              try {
                await client.admin.genererSiegesPourSalle(
                  salleId,
                  int.parse(rowsCtrl.text),
                  int.parse(colsCtrl.text),
                );
                ref.invalidate(siegesBySalleProvider(salleId));
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                print("Erreur : $e");
              }
            },
            child: const Text("Générer"),
          ),
        ],
      ),
    );
  }
}

// Ajouter ce provider dans admin_provider.dart plus tard
final siegesBySalleProvider = FutureProvider.family<List<Siege>, int>((ref, salleId) async {
  return await client.admin.getSiegesBySalle(salleId);
});
