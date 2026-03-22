import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/casa_sidebar.dart';

class ManageSeatsCasaPage extends ConsumerStatefulWidget {
  const ManageSeatsCasaPage({super.key});
  @override
  ConsumerState<ManageSeatsCasaPage> createState() => _ManageSeatsCasaPageState();
}

class _ManageSeatsCasaPageState extends ConsumerState<ManageSeatsCasaPage> {
  int? selectedSalleId;
  final int casaCinemaId = 2;

  @override
  Widget build(BuildContext context) {
    final sallesAsync = ref.watch(sallesProvider(casaCinemaId));
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          const SizedBox(width: 280, child: CasaSidebar()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CONFIGURATION DES SIÈGES - CASA", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  sallesAsync.when(
                    data: (salles) => SizedBox(
                      width: 400,
                      child: DropdownButtonFormField<int>(
                        dropdownColor: const Color(0xFF1A1A1A),
                        value: selectedSalleId,
                        decoration: const InputDecoration(labelText: "SÉLECTIONNER UNE SALLE", labelStyle: TextStyle(color: Colors.amber), filled: true, fillColor: Colors.white10),
                        style: const TextStyle(color: Colors.white),
                        items: salles.map((s) => DropdownMenuItem(value: s.id, child: Text("Salle ${s.codeSalle}"))).toList(),
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
                        data: (sieges) => sieges.isEmpty
                            ? Center(child: ElevatedButton(onPressed: () => _showGenDialog(), child: const Text("CRÉER LE PLAN DE SALLE")))
                            : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15, mainAxisSpacing: 6, crossAxisSpacing: 6),
                          itemCount: sieges.length,
                          itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(color: sieges[index].type == 'vip' ? Colors.amber : Colors.white10, borderRadius: BorderRadius.circular(4)),
                            child: Center(child: Text(sieges[index].numero, style: const TextStyle(fontSize: 8, color: Colors.white))),
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text("$e"),
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
    final rows = TextEditingController(text: "8");
    final cols = TextEditingController(text: "10");
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Configuration de la salle", style: TextStyle(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: rows, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Rangées"), style: const TextStyle(color: Colors.white)),
          TextField(controller: cols, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Sièges par rangée"), style: const TextStyle(color: Colors.white)),
        ]),
        actions: [
          ElevatedButton(onPressed: () async {
            await client.admin.genererSiegesPourSalle(selectedSalleId!, int.parse(rows.text), int.parse(cols.text));
            ref.invalidate(siegesBySalleProvider(selectedSalleId!));
            Navigator.pop(ctx);
          }, child: const Text("GÉNÉRER"))
        ],
      ),
    );
  }
}
