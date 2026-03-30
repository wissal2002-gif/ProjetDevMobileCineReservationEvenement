import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:file_picker/file_picker.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../../programmation/presentation/providers/programmation_provider.dart' as prog;

class ManageFilmsLocalPage extends ConsumerWidget {
  const ManageFilmsLocalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(adminProfileProvider).value;
    final filmsAsync = ref.watch(allFilmsProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (!isMobile) const LocalAdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, ref, admin, isMobile),
                Expanded(
                  child: filmsAsync.when(
                    data: (films) {
                      final localFilms = films
                          .where((f) => f.cinemaId == admin?.cinemaId)
                          .toList();

                      if (localFilms.isEmpty) {
                        return const Center(
                          child: Text(
                            "Aucun film dans votre catalogue.",
                            style: TextStyle(color: Colors.white24, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: localFilms.length,
                        itemBuilder: (context, index) =>
                            _buildFilmCard(context, ref, localFilms[index], admin?.cinemaId),
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.accent)),
                    error: (e, _) => Center(
                        child: Text("Erreur: $e",
                            style: const TextStyle(color: Colors.redAccent))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, WidgetRef ref, Utilisateur? admin, bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "FILMS - ${admin?.nomCinema?.toUpperCase() ?? 'LOCAL'}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showFilmDialog(context, ref, admin?.cinemaId),
            icon: const Icon(Icons.add),
            label: Text(isMobile ? "AJOUTER" : "NOUVEAU FILM"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CARD FILM ────────────────────────────────────────────────────────────

  Widget _buildFilmCard(BuildContext context, WidgetRef ref, Film film, int? cinemaId) {
    return Card(
      color: AppColors.cardBg,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: film.affiche != null && film.affiche!.isNotEmpty
              ? Image.network(
              film.affiche!,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderIcon())
              : _placeholderIcon(),
        ),
        title: Text(film.titre,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${film.genre ?? 'Genre N/A'} • ${film.duree ?? 0} min",
          style: const TextStyle(color: Colors.white38),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
              onPressed: () => _showFilmDialog(context, ref, cinemaId, film: film),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, ref, film),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon() => Container(
      color: Colors.white10,
      width: 50,
      height: 70,
      child: const Icon(Icons.movie, color: Colors.white24));

  // ─── FORMULAIRE ───────────────────────────────────────────────────────────

  void _showFilmDialog(BuildContext context, WidgetRef ref, int? cinemaId, {Film? film}) {
    final bool isEdit = film != null;

    final titreCtrl        = TextEditingController(text: film?.titre);
    final synopsisCtrl     = TextEditingController(text: film?.synopsis);
    final dureeCtrl        = TextEditingController(text: film?.duree?.toString());
    final realisateurCtrl  = TextEditingController(text: film?.realisateur);
    final castingCtrl      = TextEditingController(text: film?.casting);
    final bandeAnnonceCtrl = TextEditingController(text: film?.bandeAnnonce);
    final afficheCtrl      = TextEditingController(text: film?.affiche ?? '');

    String selectedGenre          = film?.genre          ?? 'Action';
    String selectedClassification = film?.classification ?? 'Tout public';
    String selectedLangue         = film?.langue         ?? 'VF';
    bool   isUploading            = false;

    DateTime dateDebut = film?.dateDebut ?? DateTime.now();
    DateTime dateFin   = film?.dateFin   ?? DateTime.now().add(const Duration(days: 30));

    final genres = [
      'Action', 'Aventure', 'Animation', 'Comédie', 'Comédie Romantique',
      'Drame', 'Fantastique', 'Horreur', 'Policier', 'Romance',
      'Science-Fiction', 'Thriller', 'Suspense', 'Guerre', 'Western',
      'Historique', 'Biographique', 'Musical', 'Documentaire', 'Familial',
      'Arts Martiaux', 'Espionnage', 'Catastrophe', 'Super-Héros', 'Mystère',
    ];

    final classifications = ['Tout public', '-10', '-12', '-16', '-18'];
    final langues         = ['VF', 'VO', 'VOSTFR', 'AR', 'EN'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            isEdit ? "MODIFIER LE FILM" : "AJOUTER UN FILM",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Titre ───────────────────────────────────────────
                  _field(titreCtrl, "Titre du film *"),

                  // ── Synopsis ────────────────────────────────────────
                  _field(synopsisCtrl, "Synopsis (Résumé)", maxLines: 3),

                  // ── Durée ───────────────────────────────────────────
                  _field(dureeCtrl, "Durée (min)", isNumber: true),

                  // ── Réalisateur ─────────────────────────────────────
                  _field(realisateurCtrl, "Réalisateur"),

                  // ── Casting ─────────────────────────────────────────
                  _field(castingCtrl, "Casting (Acteurs principaux)"),

                  // ── Bande Annonce ───────────────────────────────────
                  _field(bandeAnnonceCtrl, "URL Bande Annonce (YouTube/MP4)"),

                  const SizedBox(height: 12),

                  // ── Affiche (upload) ────────────────────────────────
                  _selectorLabel("Affiche du film"),

                  if (afficheCtrl.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              afficheCtrl.text,
                              height: 140,
                              width: 460,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 140,
                                width: 460,
                                color: Colors.white10,
                                child: const Icon(Icons.broken_image,
                                    color: Colors.white38),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => setState(() => afficheCtrl.text = ''),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(460, 48),
                      side: BorderSide(color: AppColors.accent.withOpacity(0.5)),
                      foregroundColor: AppColors.accent,
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
                          afficheCtrl.text = url;
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
                          strokeWidth: 2, color: AppColors.accent),
                    )
                        : const Icon(Icons.upload_rounded, size: 18),
                    label: Text(isUploading
                        ? "Upload en cours..."
                        : afficheCtrl.text.isNotEmpty
                        ? "Changer l'affiche"
                        : "Importer affiche depuis PC"),
                  ),

                  const SizedBox(height: 16),

                  // ── Genre ───────────────────────────────────────────
                  _selectorLabel("Genre"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: genres
                        .map((g) => ChoiceChip(
                      label: Text(g),
                      selected: selectedGenre == g,
                      onSelected: (_) =>
                          setState(() => selectedGenre = g),
                      selectedColor: AppColors.accent,
                      backgroundColor: Colors.white10,
                      labelStyle: TextStyle(
                        color: selectedGenre == g
                            ? Colors.black
                            : Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── Classification ──────────────────────────────────
                  _selectorLabel("Classification"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: classifications
                        .map((c) => ChoiceChip(
                      label: Text(c),
                      selected: selectedClassification == c,
                      onSelected: (_) =>
                          setState(() => selectedClassification = c),
                      selectedColor: AppColors.accent,
                      backgroundColor: Colors.white10,
                      labelStyle: TextStyle(
                        color: selectedClassification == c
                            ? Colors.black
                            : Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── Langue ──────────────────────────────────────────
                  _selectorLabel("Langue"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: langues
                        .map((l) => ChoiceChip(
                      label: Text(l),
                      selected: selectedLangue == l,
                      onSelected: (_) =>
                          setState(() => selectedLangue = l),
                      selectedColor: AppColors.accent,
                      backgroundColor: Colors.white10,
                      labelStyle: TextStyle(
                        color: selectedLangue == l
                            ? Colors.black
                            : Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── Dates ───────────────────────────────────────────
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
              child: const Text("ANNULER",
                  style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              onPressed: isUploading
                  ? null
                  : () async {
                if (titreCtrl.text.isEmpty) return;

                final newFilm = Film(
                  id:             film?.id,
                  cinemaId:       cinemaId!,
                  titre:          titreCtrl.text,
                  synopsis:       synopsisCtrl.text,
                  genre:          selectedGenre,
                  duree:          int.tryParse(dureeCtrl.text) ?? 0,
                  realisateur:    realisateurCtrl.text,
                  casting:        castingCtrl.text,
                  affiche:        afficheCtrl.text,
                  bandeAnnonce:   bandeAnnonceCtrl.text,
                  classification: selectedClassification,
                  langue:         selectedLangue,
                  dateDebut:      dateDebut,
                  dateFin:        dateFin,
                  noteMoyenne:    film?.noteMoyenne ?? 0.0,
                  nombreAvis:     film?.nombreAvis  ?? 0,
                );

                try {
                  if (isEdit) {
                    await client.admin.modifierFilm(newFilm);
                  } else {
                    await client.admin.ajouterFilm(newFilm);
                  }
                  ref.invalidate(allFilmsProvider);
                  ref.invalidate(prog.filmsProvider); // ✅ AJOUTER

                  if (context.mounted) Navigator.pop(dialogContext);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erreur: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                isEdit ? "ENREGISTRER LES MODIFICATIONS" : "ENREGISTRER LE FILM",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SUPPRESSION ──────────────────────────────────────────────────────────

  void _confirmDelete(BuildContext context, WidgetRef ref, Film film) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Supprimer ?",
            style: TextStyle(color: Colors.white)),
        content: Text(
          "Voulez-vous vraiment supprimer '${film.titre}' ?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("NON",
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerFilm(film.id!);
              ref.invalidate(allFilmsProvider);
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text("OUI, SUPPRIMER",
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // ─── WIDGETS UTILITAIRES ──────────────────────────────────────────────────

  Widget _field(TextEditingController ctrl, String label,
      {bool isNumber = false, int maxLines = 1}) {
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accent),
          ),
        ),
      ),
    );
  }

  Widget _selectorLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ),
    );
  }

  Widget _datePicker(BuildContext context, String label, DateTime current,
      Function(DateTime) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        "$label : ${current.day}/${current.month}/${current.year}",
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      trailing: const Icon(Icons.calendar_month, color: AppColors.accent),
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
}