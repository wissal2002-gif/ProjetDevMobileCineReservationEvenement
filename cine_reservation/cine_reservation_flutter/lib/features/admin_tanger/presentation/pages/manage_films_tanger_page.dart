import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:go_router/go_router.dart';
import '../../../../main.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../widgets/tanger_sidebar.dart';

class ManageFilmsTangerPage extends ConsumerWidget {
  const ManageFilmsTangerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmsAsync = ref.watch(prog.filmsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      // Bouton avec HeroTag unique pour éviter le crash
      floatingActionButton: FloatingActionButton(
        heroTag: "btn_tanger_films_add",
        backgroundColor: const Color(0xFF8B7355),
        onPressed: () => _showFilmDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar avec largeur fixe pour Chrome
          const SizedBox(
            width: 280,
            child: TangerSidebar(),
          ),

          // Contenu principal
          Expanded(
            child: Container(
              color: const Color(0xFF0D0A08),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    Expanded(
                      child: filmsAsync.when(
                        data: (films) => films.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: films.length,
                          itemBuilder: (context, index) =>
                              _buildFilmListItem(context, ref, films[index]),
                        ),
                        loading: () => const Center(
                            child: CircularProgressIndicator(color: Color(0xFF8B7355))),
                        error: (e, _) => Center(
                            child: Text("Erreur : $e",
                                style: const TextStyle(color: Colors.redAccent))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("GESTION DES FILMS",
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
        Text("Espace Tanger • Contrôle du catalogue",
            style: TextStyle(
                color: Colors.white.withOpacity(0.5), fontSize: 14)),
      ],
    );
  }

  Widget _buildFilmListItem(BuildContext context, WidgetRef ref, Film film) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: film.affiche != null && film.affiche!.isNotEmpty
              ? Image.network(film.affiche!,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 90,
                  color: Colors.white10,
                  child: const Icon(Icons.broken_image, color: Colors.white24)))
              : Container(
            width: 60,
            height: 90,
            color: Colors.white10,
            child: const Icon(Icons.movie, color: Colors.white24),
          ),
        ),
        title: Text(
          film.titre,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          film.genre ?? "Genre non défini",
          style: const TextStyle(color: Color(0xFF8B7355)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
              onPressed: () => _showFilmDialog(context, ref, film: film),
              tooltip: "Modifier le film",
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, ref, film),
              tooltip: "Supprimer le film",
            ),
          ],
        ),
      ),
    );
  }

  void _showFilmDialog(BuildContext context, WidgetRef ref, {Film? film}) {
    final bool isEdit = film != null;
    final titreCtrl = TextEditingController(text: film?.titre);
    final synopsisCtrl = TextEditingController(text: film?.synopsis);
    final genreCtrl = TextEditingController(text: film?.genre);
    final dureeCtrl = TextEditingController(text: film?.duree?.toString());
    final realisateurCtrl = TextEditingController(text: film?.realisateur);
    final castingCtrl = TextEditingController(text: film?.casting);
    final afficheCtrl = TextEditingController(text: film?.affiche);
    final bandeAnnonceCtrl = TextEditingController(text: film?.bandeAnnonce);
    final classificationCtrl = TextEditingController(text: film?.classification);
    final langueCtrl = TextEditingController(text: film?.langue ?? "VF");

    DateTime dateDebut = film?.dateDebut ?? DateTime.now();
    DateTime dateFin = film?.dateFin ?? DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(isEdit ? "MODIFIER LE FILM" : "AJOUTER UN FILM COMPLET", 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _field(titreCtrl, "Titre du film *"),
                  _field(synopsisCtrl, "Synopsis (Résumé)", maxLines: 3),
                  Row(
                    children: [
                      Expanded(child: _field(genreCtrl, "Genre")),
                      const SizedBox(width: 10),
                      Expanded(child: _field(dureeCtrl, "Durée (min)", isNumber: true)),
                    ],
                  ),
                  _field(realisateurCtrl, "Réalisateur"),
                  _field(castingCtrl, "Casting (Acteurs principaux)"),
                  _field(afficheCtrl, "URL de l'affiche (Image)"),
                  _field(bandeAnnonceCtrl, "URL Bande Annonce (YouTube/MP4)"),
                  Row(
                    children: [
                      Expanded(child: _field(classificationCtrl, "Classification (Ex: -12)")),
                      const SizedBox(width: 10),
                      Expanded(child: _field(langueCtrl, "Langue (Ex: VF, VOSTFR)")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _datePicker(context, "Date de début", dateDebut, (picked) {
                    setState(() => dateDebut = picked);
                  }),
                  _datePicker(context, "Date de fin", dateFin, (picked) {
                    setState(() => dateFin = picked);
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("ANNULER", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titreCtrl.text.isEmpty) return;

                final updatedFilm = Film(
                  id: film?.id, // Important pour la modification
                  titre: titreCtrl.text,
                  synopsis: synopsisCtrl.text,
                  genre: genreCtrl.text,
                  duree: int.tryParse(dureeCtrl.text) ?? 120,
                  realisateur: realisateurCtrl.text,
                  casting: castingCtrl.text,
                  affiche: afficheCtrl.text,
                  bandeAnnonce: bandeAnnonceCtrl.text,
                  classification: classificationCtrl.text,
                  langue: langueCtrl.text,
                  dateDebut: dateDebut,
                  dateFin: dateFin,
                  noteMoyenne: film?.noteMoyenne ?? 0.0,
                  nombreAvis: film?.nombreAvis ?? 0,
                );

                try {
                  if (isEdit) {
                    await client.admin.modifierFilm(updatedFilm);
                  } else {
                    await client.admin.ajouterFilm(updatedFilm);
                  }
                  ref.invalidate(prog.filmsProvider);
                  if (context.mounted) Navigator.pop(dialogContext);
                } catch (e) {
                  print("Erreur : $e");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B7355)),
              child: Text(isEdit ? "ENREGISTRER LES MODIFICATIONS" : "ENREGISTRER LE FILM"),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Film film) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Supprimer ?", style: TextStyle(color: Colors.white)),
        content: Text("Voulez-vous vraiment supprimer '${film.titre}' ?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("NON")),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerFilm(film.id!);
              ref.invalidate(prog.filmsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("OUI, SUPPRIMER", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _datePicker(BuildContext context, String label, DateTime current, Function(DateTime) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text("$label : ${current.day}/${current.month}/${current.year}",
          style: const TextStyle(color: Colors.white70, fontSize: 14)),
      trailing: const Icon(Icons.calendar_month, color: Color(0xFF8B7355)),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: current,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onPicked(picked);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter_outlined, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text("Aucun film à Tanger", style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }
}
