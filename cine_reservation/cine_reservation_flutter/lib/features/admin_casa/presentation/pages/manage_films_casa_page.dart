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
                        data: (films) => films.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: films.length,
                          itemBuilder: (context, index) =>
                              _buildFilmListItem(context, ref, films[index]),
                        ),
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
        const Text("GESTION DES FILMS", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        Text("Espace Casablanca • Contrôle du catalogue", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
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
    final genreCtrl = TextEditingController(text: film?.genre);
    final afficheCtrl = TextEditingController(text: film?.affiche);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(isEdit ? "MODIFIER LE FILM" : "AJOUTER UN FILM", style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titreCtrl, decoration: const InputDecoration(labelText: "Titre"), style: const TextStyle(color: Colors.white)),
            TextField(controller: genreCtrl, decoration: const InputDecoration(labelText: "Genre"), style: const TextStyle(color: Colors.white)),
            TextField(controller: afficheCtrl, decoration: const InputDecoration(labelText: "URL Affiche"), style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () async {
              final newFilm = Film(
                id: film?.id,
                titre: titreCtrl.text,
                genre: genreCtrl.text,
                affiche: afficheCtrl.text,
                dateDebut: film?.dateDebut ?? DateTime.now(),
                dateFin: film?.dateFin ?? DateTime.now().add(const Duration(days: 30)),
                noteMoyenne: 0,
                nombreAvis: 0,
              );
              if (isEdit) await client.admin.modifierFilm(newFilm); else await client.admin.ajouterFilm(newFilm);
              ref.invalidate(prog.filmsProvider);
              Navigator.pop(ctx);
            },
            child: const Text("ENREGISTRER"),
          )
        ],
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

  Widget _buildEmptyState() => const Center(child: Text("Aucun film à Casablanca", style: TextStyle(color: Colors.white24)));
}
