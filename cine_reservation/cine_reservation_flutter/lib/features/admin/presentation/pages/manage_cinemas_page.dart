import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';

class ManageCinemasPage extends ConsumerStatefulWidget {
  const ManageCinemasPage({super.key});

  @override
  ConsumerState<ManageCinemasPage> createState() => _ManageCinemasPageState();
}

class _ManageCinemasPageState extends ConsumerState<ManageCinemasPage> {
  @override
  Widget build(BuildContext context) {
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION DES CINÉMAS"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business, color: AppColors.accent),
            onPressed: () => _showCinemaDialog(context),
          )
        ],
      ),
      body: cinemasAsync.when(
        data: (cinemas) => ListView.builder(
          itemCount: cinemas.length,
          itemBuilder: (context, index) {
            final cinema = cinemas[index];
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                iconColor: AppColors.accent,
                collapsedIconColor: Colors.white54,
                title: Text(cinema.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text("${cinema.ville} • ${cinema.telephone ?? 'Pas de tel'}", style: const TextStyle(color: Colors.white54)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                      onPressed: () => _showCinemaDialog(context, cinema: cinema),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () => _confirmDeleteCinema(context, cinema.id!, cinema.nom),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cinema.email != null) Text("Email: ${cinema.email}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        if (cinema.adresse.isNotEmpty) Text("Adresse: ${cinema.adresse}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const Divider(color: Colors.white10),
                        ref.watch(sallesProvider(cinema.id!)).when(
                          data: (salles) => Column(
                            children: [
                              ...salles.map((salle) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: const Icon(Icons.door_sliding_outlined, color: Colors.white38),
                                title: Text("Salle ${salle.codeSalle}", style: const TextStyle(color: Colors.white70)),
                                subtitle: Text("${salle.capacite} sièges • ${salle.typeProjection}\nÉquipements: ${salle.equipements ?? 'Standard'}", style: const TextStyle(color: Colors.white38)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blueAccent),
                                      onPressed: () => _showSalleDialog(context, cinema.id!, salle: salle),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.redAccent),
                                      onPressed: () => _deleteSalle(salle.id!, cinema.id!),
                                    ),
                                  ],
                                ),
                              )),
                              const Divider(color: Colors.white10),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.add_circle_outline, color: AppColors.accent),
                                title: const Text("Ajouter une salle", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                                onTap: () => _showSalleDialog(context, cinema.id!),
                              ),
                            ],
                          ),
                          loading: () => const LinearProgressIndicator(color: AppColors.accent),
                          error: (e, __) => Text("Erreur : $e", style: const TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, __) => Center(child: Text("Erreur : $e")),
      ),
    );
  }

  void _showCinemaDialog(BuildContext context, {Cinema? cinema}) {
    final bool isEdit = cinema != null;
    final nomCtrl = TextEditingController(text: cinema?.nom);
    final villeCtrl = TextEditingController(text: cinema?.ville);
    final adresseCtrl = TextEditingController(text: cinema?.adresse);
    final telCtrl = TextEditingController(text: cinema?.telephone);
    final emailCtrl = TextEditingController(text: cinema?.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(isEdit ? "Modifier Cinéma" : "Nouveau Cinéma", style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _textField(nomCtrl, "Nom du cinéma"),
              _textField(villeCtrl, "Ville"),
              _textField(adresseCtrl, "Adresse complète"),
              _textField(telCtrl, "Téléphone", keyboard: TextInputType.phone),
              _textField(emailCtrl, "Email", keyboard: TextInputType.emailAddress),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (nomCtrl.text.isEmpty) return;
              final newCinema = Cinema(
                id: cinema?.id,
                nom: nomCtrl.text,
                ville: villeCtrl.text,
                adresse: adresseCtrl.text,
                telephone: telCtrl.text,
                email: emailCtrl.text,
              );
              
              if (isEdit) {
                await client.admin.modifierCinema(newCinema);
              } else {
                await client.admin.ajouterCinema(newCinema);
              }
              
              ref.invalidate(allCinemasProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(isEdit ? "Enregistrer" : "Créer"),
          ),
        ],
      ),
    );
  }

  void _showSalleDialog(BuildContext context, int cinemaId, {Salle? salle}) {
    final bool isEdit = salle != null;
    final codeCtrl = TextEditingController(text: salle?.codeSalle);
    final capCtrl = TextEditingController(text: salle?.capacite.toString() ?? "100");
    String selectedProjection = salle?.typeProjection ?? "2D";
    
    List<String> selectedEquipements = salle?.equipements?.split(", ").where((e) => e.isNotEmpty).toList() ?? [];
    final List<String> availableEquipements = ["Dolby Atmos", "4K", "Projecteur Laser", "Sièges VIP", "Accès PMR", "Climatisation"];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: Text(isEdit ? "Modifier Salle" : "Ajouter une Salle", style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textField(codeCtrl, "Nom/Code de la salle"),
                _textField(capCtrl, "Capacité", keyboard: TextInputType.number),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedProjection,
                  dropdownColor: AppColors.cardBg,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Type de Projection",
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                  items: ["2D", "3D", "IMAX", "4DX"]
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedProjection = val!),
                ),
                const SizedBox(height: 16),
                const Text("Équipements", style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: availableEquipements.map((e) {
                    final isSelected = selectedEquipements.contains(e);
                    return FilterChip(
                      label: Text(e, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 12)),
                      selected: isSelected,
                      selectedColor: AppColors.accent,
                      backgroundColor: Colors.white10,
                      onSelected: (bool selected) {
                        setDialogState(() {
                          if (selected) {
                            selectedEquipements.add(e);
                          } else {
                            selectedEquipements.remove(e);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                if (codeCtrl.text.isEmpty) return;
                final newSalle = Salle(
                  id: salle?.id,
                  cinemaId: cinemaId,
                  codeSalle: codeCtrl.text,
                  capacite: int.tryParse(capCtrl.text) ?? 100,
                  typeProjection: selectedProjection,
                  equipements: selectedEquipements.join(", "),
                );
                
                if (isEdit) {
                  await client.admin.modifierSalle(newSalle);
                } else {
                  await client.admin.ajouterSalle(newSalle);
                }
                
                ref.invalidate(sallesProvider(cinemaId));
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(isEdit ? "Enregistrer" : "Ajouter"),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteSalle(int id, int cinemaId) async {
    await client.admin.supprimerSalle(id);
    ref.invalidate(sallesProvider(cinemaId));
  }

  void _confirmDeleteCinema(BuildContext context, int id, String nom) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer ?", style: TextStyle(color: Colors.white)),
        content: Text("Cela supprimera le cinéma '$nom' et toutes ses salles.", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerCinema(id);
              ref.invalidate(allCinemasProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _textField(TextEditingController ctrl, String label, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
