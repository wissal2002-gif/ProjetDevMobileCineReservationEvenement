// lib/features/admin_tanger/presentation/pages/manage_seats_tanger_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';

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
                children: [
                  const Text("GESTION DES SIÈGES", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  sallesAsync.when(
                    data: (salles) => DropdownButtonFormField<int>(
                      dropdownColor: const Color(0xFF1A1A1A),
                      value: selectedSalleId,
                      decoration: const InputDecoration(labelText: "Salle", labelStyle: TextStyle(color: Colors.amber), filled: true, fillColor: Colors.white10),
                      style: const TextStyle(color: Colors.white),
                      items: salles.map((s) => DropdownMenuItem(value: s.id, child: Text(s.codeSalle))).toList(),
                      onChanged: (val) => setState(() => selectedSalleId = val),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text("$e"),
                  ),
                  const SizedBox(height: 20),
                  if (selectedSalleId != null)
                    Expanded(
                      child: ref.watch(siegesBySalleProvider(selectedSalleId!)).when(
                        data: (sieges) => sieges.isEmpty
                            ? Center(child: ElevatedButton(onPressed: () => _showGenDialog(), child: const Text("GÉNÉRER LE PLAN")))
                            : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15, mainAxisSpacing: 4, crossAxisSpacing: 4),
                          itemCount: sieges.length,
                          itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                              color: sieges[index].type == 'vip' ? Colors.amber : Colors.white10,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(child: Text(sieges[index].numero, style: const TextStyle(fontSize: 7, color: Colors.white))),
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
    final r = TextEditingController(text: "8");
    final c = TextEditingController(text: "10");
    String type = "standard";
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setSt) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Générer rangées"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: r, decoration: const InputDecoration(labelText: "Rangées"), style: const TextStyle(color: Colors.white)),
          TextField(controller: c, decoration: const InputDecoration(labelText: "Colonnes"), style: const TextStyle(color: Colors.white)),
          DropdownButton<String>(
            value: type,
            dropdownColor: Colors.black,
            items: ["standard", "vip"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setSt(() => type = v!),
          )
        ]),
        actions: [
          ElevatedButton(onPressed: () async {
            await client.admin.genererSiegesPourSalle(selectedSalleId!, int.parse(r.text), int.parse(c.text));
            ref.invalidate(siegesBySalleProvider(selectedSalleId!));
            Navigator.pop(context);
          }, child: const Text("Valider"))
        ],
      )),
    );
  }
}