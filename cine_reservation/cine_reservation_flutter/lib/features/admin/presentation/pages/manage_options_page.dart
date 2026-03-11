// lib/features/admin/presentation/pages/manage_options_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_options_provider.dart';
import '../../../../main.dart';

class ManageOptionsPage extends ConsumerWidget {
  const ManageOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(allOptionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION DES OPTIONS & SNACKS"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        onPressed: () => _showOptionDialog(context, ref),
        label: const Text("Ajouter", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.fastfood, color: Colors.black),
      ),
      body: optionsAsync.when(
        data: (options) => options.isEmpty
            ? const Center(child: Text("Aucun snack configuré", style: TextStyle(color: Colors.white54)))
            : GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) => _buildOptionCard(context, ref, options[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, WidgetRef ref, OptionSupplementaire item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: item.image != null && item.image!.isNotEmpty
                  ? Image.network(item.image!, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.fastfood, size: 50, color: Colors.white24))
                  : Container(color: Colors.black26, child: const Center(child: Icon(Icons.fastfood, size: 50, color: Colors.white24))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text("${item.prix} DH", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                )
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
    final catCtrl = TextEditingController(text: option?.categorie ?? "snack");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(option == null ? "Nouvelle Option" : "Modifier l'Option", style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nom")),
              TextField(controller: prixCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Prix (DH)"), keyboardType: TextInputType.number),
              TextField(controller: imgCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "URL Image")),
              TextField(controller: catCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Catégorie (snack/boisson)")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () async {
              final newOption = OptionSupplementaire(
                id: option?.id,
                nom: nomCtrl.text,
                prix: double.tryParse(prixCtrl.text) ?? 0.0,
                image: imgCtrl.text,
                categorie: catCtrl.text,
                disponible: true,
              );

              if (option == null) {
                await client.admin.ajouterOption(newOption);
              } else {
                await client.admin.modifierOption(newOption);
              }
              ref.invalidate(allOptionsProvider);
              Navigator.pop(context);
            },
            child: const Text("Enregistrer", style: TextStyle(color: Colors.black)),
          )
        ],
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