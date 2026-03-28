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

    // 1. On récupère le profil de l'admin connecté via ton provider
    final adminAsync = ref.watch(adminProfileProvider);
    final optionsAsync = ref.watch(allOptionsProvider);

    return adminAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Erreur profil: $e"))),
      data: (admin) {
        // 2. EXTRACTION DE L'ID DYNAMIQUE
        // Au lieu de "2", on prend l'ID du cinéma de l'admin actuel
        final int? currentCinemaId = admin?.cinemaId;
        final String nomCinema = admin?.nomCinema ?? "MON CINÉMA";

        return Scaffold(
          backgroundColor: const Color(0xFF0D0A08),
          floatingActionButton: FloatingActionButton.extended(
            // On passe l'ID dynamique au dialogue
            onPressed: () => _showOptionDialog(context, ref, currentCinemaId!),
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
                      // TITRE DYNAMIQUE
                      Text("GESTION DES SNACKS - ${nomCinema.toUpperCase()}",
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      Expanded(
                        child: optionsAsync.when(
                          data: (options) {
                            // 3. FILTRAGE DYNAMIQUE
                            // On ne filtre que les snacks qui appartiennent au cinéma de l'admin
                            final filteredOptions = options.where((o) => o.cinemaId == currentCinemaId).toList();

                            if (filteredOptions.isEmpty) return const Center(child: Text("Aucun snack enregistré.", style: TextStyle(color: Colors.white24)));
                            return ListView.builder(
                              itemCount: filteredOptions.length,
                              itemBuilder: (context, index) {
                                final opt = filteredOptions[index];
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
      },
    );
  }

  // DIALOGUE : On ajoute le paramètre 'cinemaId'
  void _showOptionDialog(BuildContext context, WidgetRef ref, int cinemaId) {
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
            final opt = OptionSupplementaire(
                cinemaId: cinemaId, // <--- UTILISE L'ID RÉCUPÉRÉ DYNAMIQUEMENT
                nom: nomCtrl.text,
                prix: double.parse(prixCtrl.text),
                description: "",
                categorie: "snack",
                disponible: true
            );
            await client.admin.ajouterOption(opt);
            ref.invalidate(allOptionsProvider);
            Navigator.pop(ctx);
          }, child: const Text("AJOUTER"))
        ],
      ),
    );
  }
}