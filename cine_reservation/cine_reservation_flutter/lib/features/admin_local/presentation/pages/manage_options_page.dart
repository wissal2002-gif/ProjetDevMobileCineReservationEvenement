import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';

class ManageOptionsPage extends ConsumerWidget {
  const ManageOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile     = MediaQuery.of(context).size.width < 768;
    final adminAsync   = ref.watch(adminProfileProvider);
    final optionsAsync = ref.watch(allOptionsProvider);

    return adminAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Erreur: $e"))),
      data: (admin) {
        final cinemaId   = admin?.cinemaId;
        final cinemaName = admin?.nomCinema ?? "Cinéma";

        final filtered = optionsAsync.value
            ?.where((o) => o.cinemaId == cinemaId)
            .toList() ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFF0D0A08),
          floatingActionButton: cinemaId == null
              ? null
              : FloatingActionButton.extended(
            onPressed: () => _showOptionDialog(context, ref, cinemaId, null),
            label: const Text("AJOUTER SNACK",
                style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          body: Row(
            children: [
              if (!isMobile) const LocalAdminSidebar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SNACKS & OPTIONS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 20 : 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$cinemaName — ID: ${cinemaId ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.amber, size: 28),
                            tooltip: "Actualiser",
                            onPressed: () => ref.invalidate(allOptionsProvider),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: optionsAsync.when(
                          loading: () => const Center(
                              child: CircularProgressIndicator(color: Colors.amber)),
                          error: (e, _) => Center(
                              child: Text("Erreur: $e",
                                  style: const TextStyle(color: Colors.redAccent))),
                          data: (_) {
                            if (filtered.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.fastfood,
                                        color: Colors.white.withOpacity(0.1),
                                        size: 64),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Aucun snack pour ce cinéma.",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.24),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final Map<String, List<OptionSupplementaire>> grouped = {};
                            for (final opt in filtered) {
                              final cat = opt.categorie ?? 'snack';
                              grouped.putIfAbsent(cat, () => []).add(opt);
                            }

                            return ListView(
                              children: grouped.entries.map((entry) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                                      child: Row(children: [
                                        Icon(_categoryIcon(entry.key),
                                            color: Colors.amber, size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          entry.key.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.amber,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ]),
                                    ),
                                    ...entry.value.map((opt) =>
                                        _buildOptionCard(context, ref, opt, cinemaId)),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }).toList(),
                            );
                          },
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

  Widget _buildOptionCard(BuildContext context, WidgetRef ref,
      OptionSupplementaire opt, int? cinemaId) {
    final bool disponible = opt.disponible ?? true;

    return Card(
      color: Colors.white.withOpacity(0.04),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: opt.image != null && opt.image!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  opt.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    _categoryIcon(opt.categorie ?? 'snack'),
                    color: Colors.amber,
                    size: 22,
                  ),
                ),
              )
                  : Icon(_categoryIcon(opt.categorie ?? 'snack'),
                  color: Colors.amber, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(opt.nom,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  if (opt.description != null && opt.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(opt.description!,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4), fontSize: 12)),
                  ],
                  const SizedBox(height: 6),
                  Row(children: [
                    Text("${opt.prix.toStringAsFixed(2)} DH",
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: disponible
                            ? Colors.green.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        disponible ? "DISPONIBLE" : "INDISPONIBLE",
                        style: TextStyle(
                          color: disponible ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white38, size: 20),
                  tooltip: "Modifier",
                  onPressed: () => _showOptionDialog(context, ref, cinemaId!, opt),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  tooltip: "Supprimer",
                  onPressed: () => _confirmDelete(context, ref, opt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionDialog(BuildContext context, WidgetRef ref, int cinemaId,
      OptionSupplementaire? existing) {
    final nomCtrl  = TextEditingController(text: existing?.nom ?? '');
    final prixCtrl = TextEditingController(text: existing?.prix.toString() ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');

    String  selectedCategorie = existing?.categorie ?? 'snack';
    bool    disponible        = existing?.disponible ?? true;
    String? imageUrl          = existing?.image;
    bool    isUploading       = false;

    final categories = ['snack', 'boisson', 'combo', 'autre'];
    final isEdit     = existing != null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isEdit ? "Modifier le snack" : "Nouveau Snack",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(nomCtrl, "Nom du produit", Icons.fastfood),
                const SizedBox(height: 12),
                _dialogField(prixCtrl, "Prix (DH)", Icons.attach_money,
                    keyboard: TextInputType.number),
                const SizedBox(height: 12),
                _dialogField(descCtrl, "Description (optionnel)", Icons.description),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Image du produit",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4), fontSize: 12)),
                ),
                const SizedBox(height: 8),

                // ── Aperçu image ── CORRIGÉ : width fixe au lieu de double.infinity
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl!,
                          height: 120,
                          width: 460, // ✅ FIX
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            width: 460, // ✅ FIX
                            color: Colors.white.withOpacity(0.05),
                            child: const Icon(Icons.broken_image, color: Colors.white38),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => setState(() => imageUrl = null),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 8),

                // ── Bouton upload ── CORRIGÉ : plus de SizedBox(width: double.infinity)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(460, 48), // ✅ FIX
                    side: BorderSide(color: Colors.amber.withOpacity(0.5)),
                    foregroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: isUploading
                      ? null
                      : () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );
                    if (result == null) return;

                    final bytes    = result.files.first.bytes!;
                    final fileName = result.files.first.name;

                    setState(() => isUploading = true);

                    try {
                      final url = await client.admin
                          .uploadOptionImage(bytes, fileName);
                      setState(() {
                        imageUrl    = url;
                        isUploading = false;
                      });
                    } catch (e) {
                      setState(() => isUploading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erreur upload: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: isUploading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.amber),
                  )
                      : const Icon(Icons.upload_rounded, size: 18),
                  label: Text(isUploading
                      ? "Upload en cours..."
                      : imageUrl != null
                      ? "Changer l'image"
                      : "Choisir une image depuis le PC"),
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Catégorie",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4), fontSize: 12)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: categories
                      .map((cat) => ChoiceChip(
                    label: Text(cat.toUpperCase()),
                    selected: selectedCategorie == cat,
                    onSelected: (_) =>
                        setState(() => selectedCategorie = cat),
                    selectedColor: Colors.amber,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    labelStyle: TextStyle(
                      color: selectedCategorie == cat
                          ? Colors.black
                          : Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Disponible",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7), fontSize: 14)),
                    Switch(
                      value: disponible,
                      onChanged: (v) => setState(() => disponible = v),
                      activeColor: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("ANNULER", style: TextStyle(color: Colors.white38)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isUploading
                  ? null
                  : () async {
                final opt = OptionSupplementaire(
                  id: existing?.id,
                  cinemaId: cinemaId,
                  nom: nomCtrl.text.trim(),
                  prix: double.tryParse(prixCtrl.text) ?? 0,
                  description: descCtrl.text.trim(),
                  image: imageUrl,
                  categorie: selectedCategorie,
                  disponible: disponible,
                );
                if (isEdit) {
                  await client.admin.modifierOption(opt);
                } else {
                  await client.admin.ajouterOption(opt);
                }
                ref.invalidate(allOptionsProvider);
                Navigator.pop(ctx);
              },
              child: Text(isEdit ? "ENREGISTRER" : "AJOUTER",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, OptionSupplementaire opt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Supprimer le snack", style: TextStyle(color: Colors.white)),
        content: Text(
          "Voulez-vous vraiment supprimer « ${opt.nom} » ?",
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ANNULER", style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              await client.admin.supprimerOption(opt.id!);
              ref.invalidate(allOptionsProvider);
              Navigator.pop(ctx);
            },
            child: const Text("SUPPRIMER",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController ctrl, String label, IconData icon,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        prefixIcon: Icon(icon, color: Colors.amber, size: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.amber),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'boisson': return Icons.local_drink;
      case 'combo':   return Icons.lunch_dining;
      case 'autre':   return Icons.more_horiz;
      default:        return Icons.fastfood;
    }
  }
}