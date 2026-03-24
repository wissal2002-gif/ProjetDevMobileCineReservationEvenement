import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/casa_sidebar.dart';

class ManageOptionsCasaPage extends ConsumerWidget {
  const ManageOptionsCasaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final optionsAsync = ref.watch(allOptionsProvider);
    const int casaCinemaId = 2;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showOptionDialog(context, ref),
        label: const Text("AJOUTER SNACK"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      body: Row(
        children: [
          if (!isMobile) const SizedBox(width: 280, child: CasaSidebar()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GESTION DES SNACKS - CASA", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Expanded(
                    child: optionsAsync.when(
                      data: (options) {
                        final casaOptions = options.where((o) => o.cinemaId == casaCinemaId).toList();
                        if (casaOptions.isEmpty) return const Center(child: Text("Aucun snack à Casablanca.", style: TextStyle(color: Colors.white24)));
                        return ListView.builder(
                          itemCount: casaOptions.length,
                          itemBuilder: (context, index) {
                            final opt = casaOptions[index];
                            return Card(
                              color: Colors.white10,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: const Icon(Icons.fastfood, color: Colors.amber),
                                title: Text(opt.nom, style: const TextStyle(color: Colors.white)),
                                subtitle: Text("${opt.prix} DH", style: const TextStyle(color: Colors.white54)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () async {
                                    await client.admin.supprimerOption(opt.id!);
                                    ref.invalidate(allOptionsProvider);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text("Erreur: $e")),
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

  void _showOptionDialog(BuildContext context, WidgetRef ref) {
    final nomCtrl = TextEditingController();
    final prixCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Nouveau Snack", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: "Nom"), style: const TextStyle(color: Colors.white)),
            TextField(controller: prixCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Prix (DH)"), style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () async {
            final opt = OptionSupplementaire(cinemaId: 2, nom: nomCtrl.text, prix: double.parse(prixCtrl.text), description: "", categorie: "snack", disponible: true);
            await client.admin.ajouterOption(opt);
            ref.invalidate(allOptionsProvider);
            Navigator.pop(ctx);
          }, child: const Text("AJOUTER"))
        ],
      ),
    );
  }
}
