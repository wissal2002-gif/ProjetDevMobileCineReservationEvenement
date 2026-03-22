import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';
import '../../../../core/theme/app_theme.dart';

class ManageSeatsTangerPage extends ConsumerStatefulWidget {
  const ManageSeatsTangerPage({super.key});
  @override
  ConsumerState<ManageSeatsTangerPage> createState() => _ManageSeatsTangerPageState();
}

class _ManageSeatsTangerPageState extends ConsumerState<ManageSeatsTangerPage> {
  int? selectedSalleId;
  final int tangerCinemaId = 9;

  @override
  Widget build(BuildContext context) {
    final sallesAsync = ref.watch(sallesProvider(tangerCinemaId));
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          const SizedBox(width: 280, child: TangerSidebar()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CONFIGURATION DES SIÈGES", 
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const Text("Définissez le plan de salle (rangées et colonnes)", 
                    style: TextStyle(color: Colors.white38, fontSize: 14)),
                  const SizedBox(height: 40),
                  
                  sallesAsync.when(
                    data: (salles) => Container(
                      width: 400,
                      child: DropdownButtonFormField<int>(
                        dropdownColor: const Color(0xFF1A1A1A),
                        value: selectedSalleId,
                        decoration: const InputDecoration(
                          labelText: "SÉLECTIONNER UNE SALLE", 
                          labelStyle: TextStyle(color: Colors.amber, fontSize: 12), 
                          filled: true, 
                          fillColor: Colors.white10
                        ),
                        style: const TextStyle(color: Colors.white),
                        items: salles.map((s) => DropdownMenuItem(value: s.id, child: Text("Salle ${s.codeSalle} (${s.capacite} places)"))).toList(),
                        onChanged: (val) => setState(() => selectedSalleId = val),
                      ),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text("$e"),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  if (selectedSalleId != null)
                    Expanded(
                      child: ref.watch(siegesBySalleProvider(selectedSalleId!)).when(
                        data: (sieges) {
                          if (sieges.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.grid_off, size: 64, color: Colors.white10),
                                  const SizedBox(height: 20),
                                  const Text("Aucun plan de salle n'est configuré pour le moment.", style: TextStyle(color: Colors.white38)),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => _showGenDialog(), 
                                    icon: const Icon(Icons.grid_on),
                                    label: const Text("CRÉER LE PLAN DE SALLE"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${sieges.length} sièges configurés", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                                  TextButton.icon(
                                    onPressed: () => _showGenDialog(),
                                    icon: const Icon(Icons.edit, size: 16),
                                    label: const Text("MODIFIER LE PLAN"),
                                    style: TextButton.styleFrom(foregroundColor: Colors.amber),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(16)),
                                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 15, 
                                      mainAxisSpacing: 6, 
                                      crossAxisSpacing: 6
                                    ),
                                    itemCount: sieges.length,
                                    itemBuilder: (context, index) {
                                      final siege = sieges[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: siege.type == 'vip' ? Colors.amber : Colors.white10,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: Colors.white10),
                                        ),
                                        child: Center(
                                          child: Text(siege.numero, style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
                        error: (e, _) => Center(child: Text("Erreur : $e", style: const TextStyle(color: Colors.red))),
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(
                        child: Text("Veuillez choisir une salle pour configurer les sièges.", style: TextStyle(color: Colors.white24)),
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

  void _showGenDialog() {
    final rowsCtrl = TextEditingController(text: "8");
    final colsCtrl = TextEditingController(text: "10");
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Configuration de la salle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Définissez le nombre de rangées (A, B, C...) et le nombre de sièges par rangée.", 
              style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 20),
            TextField(
              controller: rowsCtrl, 
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Nombre de rangées", labelStyle: TextStyle(color: Colors.white38)), 
              style: const TextStyle(color: Colors.white)
            ),
            const SizedBox(height: 15),
            TextField(
              controller: colsCtrl, 
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Sièges par rangée", labelStyle: TextStyle(color: Colors.white38)), 
              style: const TextStyle(color: Colors.white)
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER", style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () async {
              try {
                // Appel de la méthode de génération automatique sur le serveur
                await client.admin.genererSiegesPourSalle(
                  selectedSalleId!, 
                  int.parse(rowsCtrl.text), 
                  int.parse(colsCtrl.text)
                );
                ref.invalidate(siegesBySalleProvider(selectedSalleId!));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Plan de salle généré avec succès !"), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Erreur : $e"), backgroundColor: Colors.red));
              }
            }, 
            child: const Text("GÉNÉRER LE PLAN")
          )
        ],
      ),
    );
  }
}
