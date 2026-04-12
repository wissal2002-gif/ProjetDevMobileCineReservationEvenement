import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';
import 'package:file_picker/file_picker.dart';

class AddEventFormPage extends ConsumerStatefulWidget {
  final Evenement? event;
  const AddEventFormPage({super.key, this.event});

  @override
  ConsumerState<AddEventFormPage> createState() => _AddEventFormPageState();
}

class _AddEventFormPageState extends ConsumerState<AddEventFormPage> {
  final _formKey = GlobalKey<FormState>();

  // ── Contrôleurs texte ────────────────────────────────────────────────────
  late TextEditingController _titreCtrl, _descCtrl, _lieuCtrl, _villeCtrl,
      _prixCtrl, _prixVipCtrl, _prixReduitCtrl, _prixSeniorCtrl,
      _prixEnfantCtrl, _placesTotalCtrl, _afficheCtrl, _baCtrl, _orgaCtrl,
      _delaiAnnulCtrl, _fraisAnnulCtrl;

  // ── État ─────────────────────────────────────────────────────────────────
  String _type = 'concert';
  final List<String> _validTypes = [
    'theatre',
    'sketch',
    'danse',
    'soiree_musicale',
    'musique_traditionnelle',
    'concert',
    'avant_premiere',
    'cine_debat',
    'conference',
    'exposition',
    'sport_live',
    'tournoi',
    'autre',
  ];
  String _statut = 'actif';
  int? _selectedCinemaId;
  int? _selectedSalleId;
  String? _selectedSalleName;
  bool _isAtCinema = false;
  bool _annulationGratuite = true;
  bool _isUploading = false;
  bool _hasSiegesVip = false;

  DateTime _dateDebut = DateTime.now().add(const Duration(days: 1));
  DateTime? _dateFin;

  @override
  void initState() {
    super.initState();
    final e = widget.event;

    _titreCtrl       = TextEditingController(text: e?.titre);
    _descCtrl        = TextEditingController(text: e?.description);
    // ✅ FIX : si événement cinéma, _lieuCtrl vide (lieu = salleName, pas lieuCtrl)
    _lieuCtrl        = TextEditingController(text: e?.cinemaId != null ? '' : e?.lieu);
    _villeCtrl       = TextEditingController(text: e?.ville);
    _prixCtrl        = TextEditingController(text: (e?.prix ?? 0.0).toString());
    _prixVipCtrl     = TextEditingController(text: (e?.prixVip ?? 0.0).toString());
    _prixReduitCtrl  = TextEditingController(text: (e?.prixReduit ?? 0.0).toString());
    _prixSeniorCtrl  = TextEditingController(text: (e?.prixSenior ?? 0.0).toString());
    _prixEnfantCtrl  = TextEditingController(text: (e?.prixEnfant ?? 0.0).toString());
    _placesTotalCtrl = TextEditingController(text: (e?.placesTotales ?? 100).toString());
    _afficheCtrl     = TextEditingController(text: e?.affiche ?? '');
    _baCtrl          = TextEditingController(text: e?.bandeAnnonce);
    _orgaCtrl        = TextEditingController(text: e?.organisateur);
    _delaiAnnulCtrl  = TextEditingController(text: (e?.delaiAnnulation ?? 48).toString());
    _fraisAnnulCtrl  = TextEditingController(text: (e?.fraisAnnulation ?? 0.0).toString());

    if (e != null) {
      final String incomingType = (e.type ?? 'concert').toLowerCase();
      _type               = _validTypes.contains(incomingType) ? incomingType : 'autre';
      _statut             = e.statut ?? 'actif';
      _isAtCinema         = e.cinemaId != null;
      _selectedCinemaId   = e.cinemaId;
      _dateDebut          = e.dateDebut;
      _dateFin            = e.dateFin;
      _annulationGratuite = e.annulationGratuite ?? true;
      _selectedSalleName  = e.lieu;

      // Récupérer la salle si événement dans un cinéma
      if (e.cinemaId != null && e.lieu != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            final salles = await client.admin.getSallesByCinema(e.cinemaId!);
            final salle = salles.firstWhere(
                  (s) => "Salle ${s.codeSalle}" == e.lieu,
              orElse: () => salles.first,
            );
            final sieges = await client.admin.getSiegesBySalle(salle.id!);
            final hasVip = sieges.any((s) => s.type == 'vip');
            setState(() {
              _selectedSalleId = salle.id;
              _hasSiegesVip    = hasVip;
            });
          } catch (_) {}
        });
      }
    }

    // ✅ FIX : Auto-remplir la ville uniquement (PAS le cinemaId)
    // Le cinemaId ne sera assigné que si _isAtCinema est activé via le toggle
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final admin = ref.read(adminProfileProvider).value;
      if (admin?.role == 'resp_evenements' && admin?.cinemaId != null) {
        // ✅ NE PAS auto-assigner _selectedCinemaId ici
        // Il sera assigné uniquement via le SwitchListTile onChanged

        // Auto-remplir la ville depuis le cinéma (pour événement hors cinéma aussi)
        try {
          final cinemas = ref.read(allCinemasProvider).value ?? [];
          final cinema = cinemas.firstWhere(
                (c) => c.id == admin!.cinemaId,
            orElse: () => Cinema(nom: '', adresse: '', ville: ''),
          );
          if (cinema.ville.isNotEmpty && _villeCtrl.text.isEmpty) {
            setState(() => _villeCtrl.text = cinema.ville);
          }
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    for (final c in [
      _titreCtrl, _descCtrl, _lieuCtrl, _villeCtrl,
      _prixCtrl, _prixVipCtrl, _prixReduitCtrl, _prixSeniorCtrl,
      _prixEnfantCtrl, _placesTotalCtrl, _afficheCtrl, _baCtrl,
      _orgaCtrl, _delaiAnnulCtrl, _fraisAnnulCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Sélecteur date/heure ─────────────────────────────────────────────────
  Future<void> _pickDateTime(bool isStart) async {
    final initial = isStart ? _dateDebut : (_dateFin ?? _dateDebut);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null) return;
    setState(() {
      final full = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
          pickedTime.hour, pickedTime.minute);
      if (isStart) _dateDebut = full; else _dateFin = full;
    });
  }

  // ════════════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final admin        = ref.watch(adminProfileProvider).value;
    final cinemasAsync = ref.watch(allCinemasProvider);
    final isRespEvent  = admin?.role == 'resp_evenements';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          widget.event == null ? "NOUVEL ÉVÉNEMENT" : "MODIFIER L'ÉVÉNEMENT",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── 1. GÉNÉRAL ──────────────────────────────────────────────
              _sectionTitle("Général & Organisateur"),
              _card([
                _buildDropdownType(),
                const SizedBox(height: 15),
                _field(_titreCtrl, "Titre de l'événement *", Icons.title, required: true),
                const SizedBox(height: 15),
                _field(_orgaCtrl, "Organisateur", Icons.person),
                const SizedBox(height: 15),
                _field(_descCtrl, "Description", Icons.description, maxLines: 3),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _statut,
                  dropdownColor: AppColors.cardBg,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Statut",
                    prefixIcon: Icon(Icons.toggle_on, color: Colors.white38, size: 20),
                    filled: true, fillColor: Colors.white10,
                  ),
                  items: ['actif', 'inactif', 'complet', 'annule']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase())))
                      .toList(),
                  onChanged: (v) => setState(() => _statut = v!),
                ),
              ]),

              // ── 2. LOCALISATION ─────────────────────────────────────────
              _sectionTitle("Localisation"),
              _card([
                SwitchListTile(
                  title: const Text("Se déroule dans un Cinéma ?",
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    _isAtCinema
                        ? "Les prix seront définis par type de siège"
                        : "Un seul prix pour tous les billets",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 12),
                  ),
                  value: _isAtCinema,
                  activeColor: AppColors.accent,
                  // ✅ FIX : gestion correcte du cinemaId selon le toggle
                  onChanged: (val) {
                    final admin = ref.read(adminProfileProvider).value;
                    setState(() {
                      _isAtCinema = val;
                      if (val) {
                        // Active cinéma → assigner cinemaId de l'admin si resp_evenements
                        if (admin?.role == 'resp_evenements' && admin?.cinemaId != null) {
                          _selectedCinemaId = admin!.cinemaId;
                        }
                        // Vider les champs hors-cinéma
                        _lieuCtrl.clear();
                      } else {
                        // ✅ Désactive cinéma → VIDER tous les champs cinéma sans exception
                        _selectedCinemaId  = null;
                        _selectedSalleId   = null;
                        _selectedSalleName = null;
                        _hasSiegesVip      = false;
                        // ✅ VIDER aussi _lieuCtrl pour éviter qu'il garde
                        // le nom de salle de l'ancien événement cinéma
                        _lieuCtrl.clear();
                        // Remettre la ville depuis le cinéma de l'admin si dispo
                        if (admin?.role == 'resp_evenements' && admin?.cinemaId != null) {
                          final cinemas = ref.read(allCinemasProvider).value ?? [];
                          try {
                            final cinema = cinemas.firstWhere((c) => c.id == admin!.cinemaId);
                            if (cinema.ville.isNotEmpty) _villeCtrl.text = cinema.ville;
                          } catch (_) {}
                        }
                      }
                    });
                  },
                ),
                if (_isAtCinema) ...[
                  const SizedBox(height: 12),

                  // Dropdown cinéma — fixé si resp_evenements
                  if (isRespEvent && _selectedCinemaId != null)
                    cinemasAsync.when(
                      data: (cinemas) {
                        final c = cinemas.firstWhere(
                              (c) => c.id == _selectedCinemaId,
                          orElse: () => Cinema(nom: 'Cinéma', adresse: '', ville: ''),
                        );
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.business_rounded,
                                  color: AppColors.accent, size: 18),
                              const SizedBox(width: 10),
                              Text(c.nom,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              const Text("Votre cinéma",
                                  style: TextStyle(
                                      color: AppColors.accent, fontSize: 11)),
                            ],
                          ),
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    )
                  else
                    cinemasAsync.when(
                      data: (cinemas) => DropdownButtonFormField<int>(
                        value: _selectedCinemaId,
                        dropdownColor: AppColors.cardBg,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Sélectionner le Cinéma",
                          prefixIcon: Icon(Icons.business, color: Colors.white38, size: 20),
                          filled: true, fillColor: Colors.white10,
                        ),
                        items: cinemas
                            .map((c) => DropdownMenuItem<int>(
                            value: c.id, child: Text(c.nom)))
                            .toList(),
                        onChanged: (val) => setState(() {
                          _selectedCinemaId  = val;
                          _selectedSalleId   = null;
                          _selectedSalleName = null;
                          _hasSiegesVip      = false;
                        }),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const Text("Erreur cinémas",
                          style: TextStyle(color: Colors.redAccent)),
                    ),

                  // Dropdown salle
                  if (_selectedCinemaId != null) ...[
                    const SizedBox(height: 15),
                    FutureBuilder<List<Salle>>(
                      future: client.admin.getSallesByCinema(_selectedCinemaId!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const LinearProgressIndicator(color: AppColors.accent);
                        }
                        return DropdownButtonFormField<int>(
                          value: _selectedSalleId,
                          dropdownColor: AppColors.cardBg,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Attribuer une Salle",
                            prefixIcon: Icon(Icons.meeting_room,
                                color: Colors.white38, size: 20),
                            filled: true, fillColor: Colors.white10,
                          ),
                          items: snapshot.data!
                              .map((s) => DropdownMenuItem<int>(
                            value: s.id,
                            child: Text(
                                "Salle ${s.codeSalle} — ${s.capacite} places"),
                          ))
                              .toList(),
                          onChanged: (val) async {
                            final salle =
                            snapshot.data!.firstWhere((s) => s.id == val);
                            final sieges =
                            await client.admin.getSiegesBySalle(val!);
                            final hasVip = sieges.any((s) => s.type == 'vip');
                            setState(() {
                              _selectedSalleId   = val;
                              _selectedSalleName = "Salle ${salle.codeSalle}";
                              _placesTotalCtrl.text = salle.capacite.toString();
                              _hasSiegesVip = hasVip;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ] else ...[
                  // Événement hors cinéma
                  const SizedBox(height: 12),
                  _field(_lieuCtrl, "Nom du Lieu (Théâtre, Stade...)",
                      Icons.place, required: true),
                  const SizedBox(height: 15),
                  _field(_villeCtrl, "Ville", Icons.location_city, required: true),
                ],
              ]),

              // ── 3. DATES ────────────────────────────────────────────────
              _sectionTitle("Dates"),
              _card([
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: AppColors.accent),
                  title: const Text("Date de début",
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(_dateDebut),
                    style: const TextStyle(
                        color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.white38, size: 18),
                  onTap: () => _pickDateTime(true),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_month, color: Colors.white38),
                  title: const Text("Date de fin (optionnel)",
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  subtitle: Text(
                    _dateFin != null
                        ? DateFormat('dd/MM/yyyy HH:mm').format(_dateFin!)
                        : "Non définie",
                    style: TextStyle(
                        color: _dateFin != null ? AppColors.accent : Colors.white38),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.white38, size: 18),
                  onTap: () => _pickDateTime(false),
                ),
              ]),

              // ── 4. PRIX & PLACES ────────────────────────────────────────
              _sectionTitle("Prix & Places"),
              _card([
                _field(_placesTotalCtrl, "Places totales *",
                    Icons.event_seat, isNumber: true, required: true),
                const SizedBox(height: 16),

                if (_isAtCinema && _selectedSalleId != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.accent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _hasSiegesVip
                                ? "Cette salle a des sièges VIP. Définissez les prix par type."
                                : "Définissez le prix normal pour cette salle.",
                            style: const TextStyle(
                                color: AppColors.accent, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _field(_prixCtrl, "Prix Normal (DH) *",
                      Icons.money, isNumber: true, required: true),
                  if (_hasSiegesVip) ...[
                    const SizedBox(height: 12),
                    _field(_prixVipCtrl, "Prix VIP (DH)", Icons.star, isNumber: true),
                  ],
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: _field(_prixReduitCtrl, "Prix Réduit",
                          Icons.discount, isNumber: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(_prixSeniorCtrl, "Prix Senior",
                          Icons.elderly, isNumber: true),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _field(_prixEnfantCtrl, "Prix Enfant (DH)",
                      Icons.child_care, isNumber: true),
                ] else ...[
                  _field(_prixCtrl, "Prix du billet (DH) *",
                      Icons.money, isNumber: true, required: true),
                ],
              ]),

              // ── 5. ANNULATION ───────────────────────────────────────────
              _sectionTitle("Politique d'Annulation"),
              _card([
                SwitchListTile(
                  title: const Text("Annulation Gratuite",
                      style: TextStyle(color: Colors.white)),
                  value: _annulationGratuite,
                  activeColor: AppColors.accent,
                  onChanged: (val) => setState(() => _annulationGratuite = val),
                ),
                if (!_annulationGratuite) ...[
                  const SizedBox(height: 10),
                  _field(_delaiAnnulCtrl, "Délai avant (heures)",
                      Icons.timer, isNumber: true),
                  const SizedBox(height: 10),
                  _field(_fraisAnnulCtrl, "Frais si retard (DH)",
                      Icons.warning, isNumber: true),
                ],
              ]),

              // ── 6. MÉDIAS ───────────────────────────────────────────────
              _sectionTitle("Médias"),
              _card([
                if (_afficheCtrl.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _afficheCtrl.text,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 140,
                              color: Colors.white10,
                              child: const Icon(Icons.broken_image,
                                  color: Colors.white38),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6, right: 6,
                          child: GestureDetector(
                            onTap: () => setState(() => _afficheCtrl.text = ''),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6)),
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
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: AppColors.accent.withOpacity(0.5)),
                    foregroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isUploading ? null : _uploadAffiche,
                  icon: _isUploading
                      ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.accent))
                      : const Icon(Icons.upload_rounded, size: 18),
                  label: Text(_isUploading
                      ? "Upload en cours..."
                      : _afficheCtrl.text.isNotEmpty
                      ? "Changer l'affiche"
                      : "Importer affiche depuis PC"),
                ),
                const SizedBox(height: 12),
                _field(_baCtrl, "URL Bande Annonce (YouTube/MP4)", Icons.movie),
              ]),

              // ── BOUTON ENREGISTRER ───────────────────────────────────────
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submit,
                child: const Text(
                  "ENREGISTRER L'ÉVÉNEMENT",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Upload affiche ────────────────────────────────────────────────────────
  Future<void> _uploadAffiche() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (result == null) return;
    setState(() => _isUploading = true);
    try {
      final url = await client.admin.uploadOptionImage(
          result.files.first.bytes!, result.files.first.name);
      setState(() {
        _afficheCtrl.text = url;
        _isUploading = false;
      });
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur upload: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── Soumission ────────────────────────────────────────────────────────────
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // ✅ FIX PRINCIPAL : forcer le reset de tous les champs cinéma si toggle désactivé
    // Cela garantit qu'aucune valeur résiduelle en mémoire ne fuite dans l'objet Evenement
    if (!_isAtCinema) {
      _selectedCinemaId  = null;
      _selectedSalleId   = null;
      _selectedSalleName = null;
      _hasSiegesVip      = false;
    }

    final double prixNormal = double.tryParse(_prixCtrl.text) ?? 0.0;
    final int    places     = int.tryParse(_placesTotalCtrl.text) ?? 0;
    final int    delai      = int.tryParse(_delaiAnnulCtrl.text) ?? 48;
    final double frais      = double.tryParse(_fraisAnnulCtrl.text) ?? 0.0;

    final bool saveInCinema =
        _isAtCinema == true &&
            _selectedCinemaId != null &&
            _selectedSalleId != null;
    debugPrint("🔥 isAtCinema: $_isAtCinema");
    debugPrint("🔥 selectedCinemaId: $_selectedCinemaId");
    debugPrint("🔥 selectedSalleId: $_selectedSalleId");
    debugPrint("🔥 saveInCinema: $saveInCinema");
    // Lieu final
    final String lieu = saveInCinema
        ? (_selectedSalleName ?? '')
        : _lieuCtrl.text.trim();
    // Ville : si cinéma, récupérer depuis la liste
    String ville = _villeCtrl.text.trim();
    if (saveInCinema && _selectedCinemaId != null){
      final cinemas = ref.read(allCinemasProvider).value ?? [];
      final cinema = cinemas.firstWhere(
            (c) => c.id == _selectedCinemaId,
        orElse: () => Cinema(nom: '', adresse: '', ville: ''),
      );
      if (cinema.ville.isNotEmpty) ville = cinema.ville;
    }


    // ✅ cinemaId est null si _isAtCinema est false, garanti par le reset ci-dessus
    final int? cinemaId =
    (_isAtCinema && _selectedCinemaId != null)
        ? _selectedCinemaId
        : null;
    debugPrint("🔍 isAtCinema: $_isAtCinema | cinemaId: $cinemaId | lieu: $lieu | ville: $ville");

    final ev = Evenement(
      id:                widget.event?.id,
      titre:             _titreCtrl.text.trim(),
      description:       _descCtrl.text.trim(),
      type:              _type,
      cinemaId:          cinemaId,
      lieu:              lieu,
      ville:             ville,
      dateDebut:         _dateDebut,
      dateFin:           _dateFin,
      prix:              prixNormal,
      prixVip:           double.tryParse(_prixVipCtrl.text)   ?? 0.0,
      prixReduit:        double.tryParse(_prixReduitCtrl.text) ?? 0.0,
      prixSenior:        double.tryParse(_prixSeniorCtrl.text) ?? 0.0,
      prixEnfant:        double.tryParse(_prixEnfantCtrl.text) ?? 0.0,
      placesTotales:     places,
      placesDisponibles: widget.event == null
          ? places
          : widget.event!.placesDisponibles,
      affiche:           _afficheCtrl.text.trim(),
      bandeAnnonce:      _baCtrl.text.trim(),
      organisateur:      _orgaCtrl.text.trim(),
      statut:            _statut,
      annulationGratuite: _annulationGratuite,
      delaiAnnulation:   delai,
      fraisAnnulation:   frais,
      noteMoyenne:       widget.event?.noteMoyenne ?? 0.0,
      nombreAvis:        widget.event?.nombreAvis  ?? 0,
    );

    try {
      if (widget.event == null) {
        await client.admin.ajouterEvenement(ev);
      } else {
        await client.admin.modifierEvenement(ev);
      }
      if (mounted) {
        ref.invalidate(allEvenementsProvider);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Événement enregistré !"),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── Widgets utilitaires ───────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
          color: AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2),
    ),
  );

  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    ),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _field(
      TextEditingController ctrl,
      String label,
      IconData icon, {
        int maxLines  = 1,
        bool isNumber = false,
        bool required = false,
      }) {
    return TextFormField(
      controller:   ctrl,
      maxLines:     maxLines,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: (val) {
        if (required && (val == null || val.trim().isEmpty)) {
          return "Ce champ est obligatoire";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText:  label,
        prefixIcon: Icon(icon, size: 20, color: Colors.white38),
        filled:     true,
        fillColor:  Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accent)),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  Widget _buildDropdownType() {
    return DropdownButtonFormField<String>(
      value:         _type,
      dropdownColor: AppColors.cardBg,
      style:         const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText:  "Type d'événement",
        prefixIcon: const Icon(Icons.category, color: Colors.white38, size: 20),
        filled:     true,
        fillColor:  Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      items: _validTypes
          .map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase())))
          .toList(),
      onChanged: (v) => setState(() => _type = v!),
    );
  }
}