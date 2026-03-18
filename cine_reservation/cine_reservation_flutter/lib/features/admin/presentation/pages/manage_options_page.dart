import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../providers/admin_provider.dart';

// ✅ IMPORT CORRIGÉ : Chemin vers la sidebar Tanger
import '../../../admin_tanger/presentation/widgets/tanger_sidebar.dart';

class ManageOptionsPage extends ConsumerWidget {
  const ManageOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(allOptionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // ✅ Sidebar fixe à gauche
          const SizedBox(width: 280, child: TangerSidebar()),

          // ✅ Contenu à droite
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text("GESTION GLOBALE DES OPTIONS"),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              floatingActionButton: FloatingActionButton.extended(
                heroTag: "fab_global_options",
                backgroundColor: AppColors.accent,
                onPressed: () => _showOptionDialog(context, ref),
                label: const Text("Ajouter", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.fastfood, color: Colors.black),
              ),
              body: optionsAsync.when(
                data: (options) => options.isEmpty
                    ? const Center(child: Text("Aucun snack configuré", style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: options.length,
                  itemBuilder: (context, index) => _buildOptionRow(context, ref, options[index]),
                ),
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (e, _) => Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.red))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(BuildContext context, WidgetRef ref, OptionSupplementaire item) {
    final cinemasAsync = ref.watch(allCinemasProvider);

    final String cinemaName = item.cinemaId == null
        ? "Tous les cinémas"
        : cinemasAsync.maybeWhen(
        data: (cinemas) => cinemas.firstWhere((c) => c.id == item.cinemaId, orElse: () => Cinema(nom: "Inconnu", adresse: "", ville: "")).nom,
        orElse: () => "Chargement..."
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: item.disponible == false ? Colors.red.withOpacity(0.3) : Colors.white10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  item.image != null && item.image!.isNotEmpty
                      ? Image.network(item.image!, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.fastfood, size: 40, color: Colors.white24))
                      : Container(color: Colors.black26, child: const Center(child: Icon(Icons.fastfood, size: 40, color: Colors.white24))),
                  if (item.disponible == false)
                    Container(
                      color: Colors.black54,
                      child: const Center(child: Text("ÉPUISÉ", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 10))),
                    ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("${item.prix} DH", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(cinemaName, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                  onPressed: () => _showOptionDialog(context, ref, option: item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => _deleteOption(context, ref, item),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showOptionDialog(BuildContext context, WidgetRef ref, {OptionSupplementaire? option}) {
    final nomCtrl = TextEditingController(text: option?.nom);
    final prixCtrl = TextEditingController(text: option?.prix.toString() ?? "");
    final imgCtrl = TextEditingController(text: option?.image);
    final descCtrl = TextEditingController(text: option?.description);

    final List<String> categories = ['snack', 'boisson', 'service', 'vip'];
    String selectedCategorie = option?.categorie ?? 'snack';
    if (!categories.contains(selectedCategorie)) selectedCategorie = 'snack';

    int? selectedCinemaId = option?.cinemaId;
    bool isDisponible = option?.disponible ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final cinemasAsync = ref.watch(allCinemasProvider);

          return AlertDialog(
            backgroundColor: AppColors.cardBg,
            title: Text(option == null ? "Nouvelle Option" : "Modifier l'Option", style: const TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nomCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nom")),
                  TextField(controller: prixCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Prix (DH)"), keyboardType: TextInputType.number),
                  TextField(controller: imgCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "URL Image")),

                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedCategorie,
                    dropdownColor: AppColors.cardBg,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Catégorie"),
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat.toUpperCase()))).toList(),
                    onChanged: (val) => setDialogState(() => selectedCategorie = val!),
                  ),

                  const SizedBox(height: 15),
                  cinemasAsync.when(
                    data: (cinemas) => DropdownButtonFormField<int?>(
                      value: selectedCinemaId,
                      dropdownColor: AppColors.cardBg,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: "Affecter à un Cinéma"),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text("TOUS LES CINÉMAS")),
                        ...cinemas.map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.nom.toUpperCase()))),
                      ],
                      onChanged: (val) => setDialogState(() => selectedCinemaId = val),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text("Erreur cinémas"),
                  ),

                  TextField(controller: descCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Description"), maxLines: 2),

                  SwitchListTile(
                    title: const Text("Disponible", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    value: isDisponible,
                    activeColor: AppColors.accent,
                    onChanged: (val) => setDialogState(() => isDisponible = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                onPressed: () async {
                  if (nomCtrl.text.isEmpty || prixCtrl.text.isEmpty) return;

                  final newOption = OptionSupplementaire(
                    id: option?.id,
                    nom: nomCtrl.text,
                    prix: double.tryParse(prixCtrl.text) ?? 0.0,
                    image: imgCtrl.text,
                    description: descCtrl.text,
                    categorie: selectedCategorie,
                    disponible: isDisponible,
                    cinemaId: selectedCinemaId,
                  );

                  try {
                    if (option == null) {
                      await client.admin.ajouterOption(newOption);
                    } else {
                      await client.admin.modifierOption(newOption);
                    }
                    ref.invalidate(allOptionsProvider);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
                  }
                },
                child: const Text("Enregistrer", style: TextStyle(color: Colors.black)),
              )
            ],
          );
        },
      ),
    );
  }

  void _deleteOption(BuildContext context, WidgetRef ref, OptionSupplementaire item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer ?", style: TextStyle(color: Colors.white)),
        content: Text("Voulez-vous supprimer ${item.nom} ?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await client.admin.supprimerOption(item.id!);
              ref.invalidate(allOptionsProvider);
              Navigator.pop(context);
            },
            child: const Text("Supprimer"),
          )
        ],
      ),
    );
  }
}