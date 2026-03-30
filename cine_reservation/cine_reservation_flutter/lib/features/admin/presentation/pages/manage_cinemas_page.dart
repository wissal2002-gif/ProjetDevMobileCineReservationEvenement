import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:go_router/go_router.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_sidebar.dart'; // ✅ Import de la sidebar

class ManageCinemasPage extends ConsumerStatefulWidget {
  final int? cinemaId;
  const ManageCinemasPage({super.key, this.cinemaId});
  @override
  ConsumerState<ManageCinemasPage> createState() => _ManageCinemasPageState();
}

class _ManageCinemasPageState extends ConsumerState<ManageCinemasPage> {
  @override
  Widget build(BuildContext context) {
    final cinemasAsync = ref.watch(allCinemasProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // ✅ Sidebar uniquement sur Desktop
          if (!isMobile) const SizedBox(width: 280, child: AdminSidebar()),

          Expanded(
            child: Column(
              children: [
                // ✅ Header adaptatif
                _buildHeader(isMobile),

                Expanded(
                  child: cinemasAsync.when(
                    data: (cinemas) => ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 32, vertical: 8),
                      itemCount: cinemas.length,
                      itemBuilder: (context, index) {
                        final cinema = cinemas[index];
                        return _buildCinemaCard(cinema, isMobile);
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                    error: (e, __) => Center(child: Text("Erreur : $e", style: const TextStyle(color: Colors.redAccent))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Header avec titre et bouton
  Widget _buildHeader(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "GESTION DES CINÉMAS",
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_business, color: AppColors.accent),
            onPressed: () => _showCinemaDialog(context),
            tooltip: "Ajouter un cinéma",
          )
        ],
      ),
    );
  }

  // ✅ Carte du cinéma (ExpansionTile) avec toutes les fonctions gardées
  Widget _buildCinemaCard(Cinema cinema, bool isMobile) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      child: ExpansionTile(
        iconColor: AppColors.accent,
        collapsedIconColor: Colors.white54,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          cinema.nom,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 16),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${cinema.ville} • ${cinema.telephone ?? 'Pas de tel'}",
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- SECTION SALLES ---
                _sectionTitle("SALLES"),
                ref.watch(sallesProvider(cinema.id!)).when(
                  data: (salles) => Column(
                    children: [
                      ...salles.map((salle) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text("Salle ${salle.codeSalle}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        subtitle: Text("${salle.capacite} sièges • ${salle.typeProjection}", style: const TextStyle(fontSize: 11)),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.redAccent),
                          onPressed: () => _deleteSalle(salle.id!, cinema.id!),
                        ),
                      )),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16, color: AppColors.accent),
                        label: const Text("Ajouter une salle", style: TextStyle(color: AppColors.accent, fontSize: 12)),
                        onPressed: () => _showSalleDialog(context, cinema.id!),
                      ),
                    ],
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, __) => Text("Erreur : $e"),
                ),

                const Divider(color: Colors.white10, height: 24),

                // --- SECTION SNACKS ---
                _sectionTitle("OPTIONS & SNACKS"),
                ref.watch(allOptionsProvider).when(
                  data: (options) {
                    final cinemaOptions = options.where((o) => o.cinemaId == cinema.id).toList();
                    return Column(
                      children: [
                        ...cinemaOptions.map((opt) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: const Icon(Icons.fastfood_outlined, size: 16, color: Colors.white38),
                          title: Text(opt.nom, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          subtitle: Text("${opt.prix} DH", style: const TextStyle(color: Colors.white38, fontSize: 11)),
                        )),
                        TextButton.icon(
                          icon: const Icon(Icons.settings, size: 16, color: AppColors.accent),
                          label: const Text("Gérer les snacks", style: TextStyle(color: AppColors.accent, fontSize: 12)),
                          onPressed: () => context.push('/admin/options'),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  // --- LES DIALOGUES ET FONCTIONS (GARDÉS SANS SUPPRESSION) ---

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
              _textField(nomCtrl, "Nom"),
              _textField(villeCtrl, "Ville"),
              _textField(adresseCtrl, "Adresse"),
              _textField(telCtrl, "Téléphone", keyboard: TextInputType.phone),
              _textField(emailCtrl, "Email", keyboard: TextInputType.emailAddress),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () async {
              final newCinema = Cinema(
                  id: cinema?.id,
                  nom: nomCtrl.text,
                  ville: villeCtrl.text,
                  adresse: adresseCtrl.text,
                  telephone: telCtrl.text,
                  email: emailCtrl.text
              );
              if (isEdit) await client.admin.modifierCinema(newCinema); else await client.admin.ajouterCinema(newCinema);
              ref.invalidate(allCinemasProvider);
              Navigator.pop(context);
            },
            child: const Text("Enregistrer", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showSalleDialog(BuildContext context, int cinemaId) {
    final codeCtrl = TextEditingController();
    final capCtrl = TextEditingController(text: "100");
    String selectedProjection = "2D";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: const Text("Ajouter Salle", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _textField(codeCtrl, "Code Salle"),
              _textField(capCtrl, "Capacité", keyboard: TextInputType.number),
              DropdownButtonFormField<String>(
                value: selectedProjection,
                dropdownColor: AppColors.cardBg,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Type Projection", filled: true, fillColor: Colors.white10),
                items: ["2D", "3D", "IMAX"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setDialogState(() => selectedProjection = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                final salle = Salle(cinemaId: cinemaId, codeSalle: codeCtrl.text, capacite: int.parse(capCtrl.text), typeProjection: selectedProjection);
                await client.admin.ajouterSalle(salle);
                ref.invalidate(sallesProvider(cinemaId));
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
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
        content: Text("Supprimer '$nom' et toutes ses salles ?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
              onPressed: () async {
                await client.admin.supprimerCinema(id);
                ref.invalidate(allCinemasProvider);
                Navigator.pop(context);
              },
              child: const Text("Supprimer", style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  }

  Widget _textField(TextEditingController ctrl, String label, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
          controller: ctrl,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white10, labelStyle: const TextStyle(color: Colors.white54))
      ),
    );
  }
}