import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';

class AddEventFormPage extends ConsumerStatefulWidget {
  final Evenement? event;
  const AddEventFormPage({super.key, this.event});

  @override
  ConsumerState<AddEventFormPage> createState() => _AddEventFormPageState();
}

class _AddEventFormPageState extends ConsumerState<AddEventFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titreCtrl, _descCtrl, _lieuCtrl, _villeCtrl,
      _prixCtrl, _placesTotalCtrl, _afficheCtrl, _baCtrl, _orgaCtrl,
      _delaiAnnulCtrl, _fraisAnnulCtrl;

  String _type = 'concert';
  final List<String> _validTypes = ['concert', 'theatre', 'festival', 'autre', 'sport'];
  String _statut = 'actif';
  int? _selectedCinemaId;
  int? _selectedSalleId; 
  String? _selectedSalleName; 
  bool _isAtCinema = false;
  bool _annulationGratuite = true;

  DateTime _dateDebut = DateTime.now().add(const Duration(days: 1));
  DateTime? _dateFin;

  @override
  void initState() {
    super.initState();
    _titreCtrl = TextEditingController(text: widget.event?.titre);
    _descCtrl = TextEditingController(text: widget.event?.description);
    _lieuCtrl = TextEditingController(text: widget.event?.lieu);
    _villeCtrl = TextEditingController(text: widget.event?.ville);
    _prixCtrl = TextEditingController(text: (widget.event?.prix ?? 0.0).toString());
    _placesTotalCtrl = TextEditingController(text: (widget.event?.placesTotales ?? 100).toString());
    _afficheCtrl = TextEditingController(text: widget.event?.affiche);
    _baCtrl = TextEditingController(text: widget.event?.bandeAnnonce);
    _orgaCtrl = TextEditingController(text: widget.event?.organisateur);
    _delaiAnnulCtrl = TextEditingController(text: (widget.event?.delaiAnnulation ?? 48).toString());
    _fraisAnnulCtrl = TextEditingController(text: (widget.event?.fraisAnnulation ?? 0.0).toString());

    if (widget.event != null) {
      // ✅ FIX: Gérer les types qui ne sont pas dans la liste initiale (ex: 'sport')
      final String incomingType = (widget.event!.type ?? 'concert').toLowerCase();
      if (_validTypes.contains(incomingType)) {
        _type = incomingType;
      } else {
        _validTypes.add(incomingType);
        _type = incomingType;
      }

      _statut = widget.event!.statut ?? 'actif';
      _isAtCinema = widget.event!.cinemaId != null;
      _selectedCinemaId = widget.event!.cinemaId;
      _dateDebut = widget.event!.dateDebut;
      _dateFin = widget.event!.dateFin;
      _annulationGratuite = widget.event!.annulationGratuite ?? true;
      _selectedSalleName = widget.event!.lieu;
    }
  }

  Future<void> _pickDateTime(bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _dateDebut : (_dateFin ?? _dateDebut),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _dateDebut : (_dateFin ?? _dateDebut)),
      );

      if (pickedTime != null) {
        setState(() {
          final fullDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
          if (isStart) _dateDebut = fullDate; else _dateFin = fullDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.event == null ? "NOUVEL ÉVÉNEMENT" : "MODIFIER"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Général & Organisateur"),
              _buildCard([
                _buildDropdownType(),
                const SizedBox(height: 15),
                _buildTextField(_titreCtrl, "Titre", Icons.title, required: true),
                const SizedBox(height: 15),
                _buildTextField(_orgaCtrl, "Organisateur", Icons.person),
                const SizedBox(height: 15),
                _buildTextField(_descCtrl, "Description", Icons.description, maxLines: 3),
              ]),

              _buildSectionTitle("Localisation"),
              _buildCard([
                SwitchListTile(
                  title: const Text("Se déroule dans un Cinéma ?", style: TextStyle(color: Colors.white)),
                  value: _isAtCinema,
                  activeColor: AppColors.accent,
                  onChanged: (val) => setState(() {
                    _isAtCinema = val;
                    if (!val) {
                      _selectedCinemaId = null;
                      _selectedSalleId = null;
                      _selectedSalleName = null;
                    }
                  }),
                ),

                if (_isAtCinema) ...[
                  cinemasAsync.when(
                    data: (cinemas) => DropdownButtonFormField<int>(
                      value: _selectedCinemaId,
                      dropdownColor: AppColors.cardBg,
                      decoration: const InputDecoration(labelText: "Sélectionner le Cinéma"),
                      items: cinemas.map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.nom))).toList(),
                      onChanged: (val) => setState(() {
                        _selectedCinemaId = val;
                        _selectedSalleId = null; 
                        _selectedSalleName = null;
                      }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text("Erreur cinémas"),
                  ),

                  if (_selectedCinemaId != null) ...[
                    const SizedBox(height: 15),
                    FutureBuilder<List<Salle>>(
                      future: client.admin.getSallesByCinema(_selectedCinemaId!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const LinearProgressIndicator();

                        return DropdownButtonFormField<int>(
                          value: _selectedSalleId,
                          dropdownColor: AppColors.cardBg,
                          decoration: const InputDecoration(labelText: "Attribuer une Salle"),
                          items: snapshot.data!.map((s) => DropdownMenuItem<int>(
                              value: s.id,
                              child: Text("Salle ${s.codeSalle} (${s.capacite} places)")
                          )).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedSalleId = val;
                              final salle = snapshot.data!.firstWhere((s) => s.id == val);
                              _selectedSalleName = "Salle ${salle.codeSalle}"; 
                              _placesTotalCtrl.text = salle.capacite.toString();
                            });
                          },
                        );
                      },
                    ),
                  ],
                ] else ...[
                  _buildTextField(_lieuCtrl, "Nom du Lieu (Théâtre, Stade...)", Icons.place, required: !_isAtCinema),
                  const SizedBox(height: 15),
                  _buildTextField(_villeCtrl, "Ville", Icons.location_city, required: true),
                ],
              ]),

              _buildSectionTitle("Dates & Prix"),
              _buildCard([
                ListTile(
                  title: const Text("Début", style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(_dateDebut), style: const TextStyle(color: AppColors.accent)),
                  trailing: const Icon(Icons.calendar_today, color: AppColors.accent),
                  onTap: () => _pickDateTime(true),
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_prixCtrl, "Prix (DH)", Icons.money, isNumber: true, required: true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField(_placesTotalCtrl, "Places", Icons.event_seat, isNumber: true, required: true)),
                  ],
                ),
              ]),

              _buildSectionTitle("Annulation & Frais"),
              _buildCard([
                SwitchListTile(
                  title: const Text("Annulation Gratuite", style: TextStyle(color: Colors.white)),
                  value: _annulationGratuite,
                  activeColor: AppColors.accent,
                  onChanged: (val) => setState(() => _annulationGratuite = val),
                ),
                if (!_annulationGratuite) ...[
                  _buildTextField(_delaiAnnulCtrl, "Délai (heures)", Icons.timer, isNumber: true),
                  const SizedBox(height: 10),
                  _buildTextField(_fraisAnnulCtrl, "Frais si retard (DH)", Icons.warning, isNumber: true),
                ]
              ]),

              _buildSectionTitle("Médias"),
              _buildCard([
                _buildTextField(_afficheCtrl, "URL Affiche", Icons.image),
                const SizedBox(height: 10),
                _buildTextField(_baCtrl, "URL Bande Annonce", Icons.movie),
              ]),

              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent, 
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: _submit,
                child: const Text("ENREGISTRER L'ÉVÉNEMENT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(title.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
  );

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withOpacity(0.05))),
    child: Column(children: children),
  );

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1, bool isNumber = false, bool required = false}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      validator: (val) {
        if (required && (val == null || val.trim().isEmpty)) return "Ce champ est obligatoire";
        return null;
      },
      decoration: InputDecoration(
        labelText: label, 
        prefixIcon: Icon(icon, size: 20, color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)
      ),
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  Widget _buildDropdownType() {
    return DropdownButtonFormField<String>(
      value: _type,
      dropdownColor: AppColors.cardBg,
      style: const TextStyle(color: Colors.white),
      items: _validTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
      onChanged: (v) => setState(() => _type = v!),
      decoration: const InputDecoration(labelText: "Type d'événement"),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final double prix = double.tryParse(_prixCtrl.text) ?? 0.0;
      final int places = int.tryParse(_placesTotalCtrl.text) ?? 0;
      final int delai = int.tryParse(_delaiAnnulCtrl.text) ?? 48;
      final double frais = double.tryParse(_fraisAnnulCtrl.text) ?? 0.0;

      final ev = Evenement(
        id: widget.event?.id,
        titre: _titreCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        type: _type,
        cinemaId: _isAtCinema ? _selectedCinemaId : null,
        lieu: _isAtCinema ? _selectedSalleName : _lieuCtrl.text.trim(),
        ville: _villeCtrl.text.trim(),
        dateDebut: _dateDebut,
        dateFin: _dateFin,
        prix: prix,
        placesTotales: places,
        placesDisponibles: widget.event == null ? places : widget.event!.placesDisponibles,
        affiche: _afficheCtrl.text.trim(),
        bandeAnnonce: _baCtrl.text.trim(),
        organisateur: _orgaCtrl.text.trim(),
        statut: _statut,
        annulationGratuite: _annulationGratuite,
        delaiAnnulation: delai,
        fraisAnnulation: frais,
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Événement enregistré !"), backgroundColor: Colors.green));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red));
      }
    }
  }
}
