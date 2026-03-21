import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;
import '../widgets/casa_sidebar.dart';

class ManageFilmsCasaPage extends ConsumerWidget {
  const ManageFilmsCasaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmsAsync = ref.watch(prog.filmsProvider);
    const int casaCinemaId = 2;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn_casa_films_add",
        backgroundColor: const Color(0xFF8B7355),
        onPressed: () => _showFilmDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 280, child: CasaSidebar()),
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
                        data: (films) {
                          // ✅ FILTRAGE : Uniquement les films de Casa (ID 2)
                          final casaFilms = films.where((f) => f.cinemaId == casaCinemaId).toList();
                          
                          if (casaFilms.isEmpty) return _buildEmptyState();
                          
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: casaFilms.length,
                            itemBuilder: (context, index) =>
                                _buildFilmListItem(context, ref, casaFilms[index]),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF8B7355))),
                        error: (e, _) => Center(child: Text("Erreur : $e", style: const TextStyle(color: Colors.redAccent))),
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
        const Text("GESTION DES FILMS - CASA", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        Text("Catalogue exclusif Casablanca", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
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
              ? Image.network(film.affiche!, width: 60, height: 90, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.movie, color: Colors.white24))
              : const Icon(Icons.movie, color: Colors.white24),
        ),
        title: Text(film.titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(film.genre ?? "Genre non défini", style: const TextStyle(color: Color(0xFF8B7355))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent), onPressed: () => _showFilmDialog(context, ref, film: film)),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _confirmDelete(context, ref, film)),
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
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(isEdit ? "MODIFIER LE FILM" : "AJOUTER UN FILM (CASA)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  _field(castingCtrl, "Casting"),
                  _field(afficheCtrl, "URL de l'affiche"),
                  _field(bandeAnnonceCtrl, "URL Bande Annonce"),
                  Row(
                    children: [
                      Expanded(child: _field(classificationCtrl, "Classification")),
                      const SizedBox(width: 10),
                      Expanded(child: _field(langueCtrl, "Langue")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _datePicker(context, "Date de début", dateDebut, (picked) => setState(() => dateDebut = picked)),
                  _datePicker(context, "Date de fin", dateFin, (picked) => setState(() => dateFin = picked)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ANNULER")),
            ElevatedButton(
              onPressed: () async {
                final newFilm = Film(
                  id: film?.id,
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
                  cinemaId: 2, // ✅ OBLIGATOIRE : Lié à Casa
                  noteMoyenne: film?.noteMoyenne ?? 0.0,
                  nombreAvis: film?.nombreAvis ?? 0,
                );
                if (isEdit) await client.admin.modifierFilm(newFilm); else await client.admin.ajouterFilm(newFilm);
                ref.invalidate(prog.filmsProvider);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B7355)),
              child: const Text("ENREGISTRER"),
            )
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Film film) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("NON")),
          TextButton(onPressed: () async {
            await client.admin.supprimerFilm(film.id!);
            ref.invalidate(prog.filmsProvider);
            Navigator.pop(ctx);
          }, child: const Text("OUI")),
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
        decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _datePicker(BuildContext context, String label, DateTime current, Function(DateTime) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text("$label : ${current.day}/${current.month}/${current.year}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
      trailing: const Icon(Icons.calendar_month, color: Color(0xFF8B7355)),
      onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: current, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (picked != null) onPicked(picked);
      },
    );
  }

  Widget _buildEmptyState() => const Center(child: Text("Aucun film exclusif à Casablanca", style: TextStyle(color: Colors.white24)));
}
