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

  // Contrôleurs pour tous les champs de la BD
  late TextEditingController _titreCtrl, _descCtrl, _lieuCtrl, _villeCtrl,
      _prixCtrl, _placesTotalCtrl, _afficheCtrl, _baCtrl, _orgaCtrl,
      _delaiAnnulCtrl, _fraisAnnulCtrl;

  String _type = 'concert';
  String _statut = 'actif';
  int? _selectedCinemaId;
  int? _selectedSalleId; 
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
      _type = widget.event!.type ?? 'concert';
      _statut = widget.event!.statut ?? 'actif';
      _isAtCinema = widget.event!.cinemaId != null;
      _selectedCinemaId = widget.event!.cinemaId;
      _dateDebut = widget.event!.dateDebut;
      _dateFin = widget.event!.dateFin;
      _annulationGratuite = widget.event!.annulationGratuite ?? true;
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
                _buildTextField(_titreCtrl, "Titre", Icons.title),
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
                              _placesTotalCtrl.text = salle.capacite.toString();
                            });
                          },
                        );
                      },
                    ),
                  ],
                ] else ...[
                  _buildTextField(_lieuCtrl, "Nom du Lieu (Théâtre, Stade...)", Icons.place),
                  const SizedBox(height: 15),
                  _buildTextField(_villeCtrl, "Ville", Icons.location_city),
                ],
              ]),

              _buildSectionTitle("Dates & Prix"),
              _buildCard([
                ListTile(
                  title: const Text("Début"),
                  subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(_dateDebut)),
                  trailing: const Icon(Icons.calendar_today, color: AppColors.accent),
                  onTap: () => _pickDateTime(true),
                ),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_prixCtrl, "Prix (DH)", Icons.money, isNumber: true)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField(_placesTotalCtrl, "Places", Icons.event_seat, isNumber: true)),
                  ],
                ),
              ]),

              _buildSectionTitle("Annulation & Frais"),
              _buildCard([
                SwitchListTile(
                  title: const Text("Annulation Gratuite"),
                  value: _annulationGratuite,
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: const Size(double.infinity, 50)),
                onPressed: _submit,
                child: const Text("ENREGISTRER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets Utilitaires ---
  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(title.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
  );

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)),
    child: Column(children: children),
  );

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1, bool isNumber = false}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20)),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildDropdownType() {
    return DropdownButtonFormField<String>(
      value: _type,
      dropdownColor: AppColors.cardBg,
      items: ['concert', 'theatre', 'festival', 'autre'].map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
      onChanged: (v) => setState(() => _type = v!),
      decoration: const InputDecoration(labelText: "Type"),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final ev = Evenement(
        id: widget.event?.id,
        titre: _titreCtrl.text,
        description: _descCtrl.text,
        type: _type,
        cinemaId: _isAtCinema ? _selectedCinemaId : null,
        lieu: _isAtCinema ? null : _lieuCtrl.text,
        ville: _villeCtrl.text,
        dateDebut: _dateDebut,
        dateFin: _dateFin,
        prix: double.parse(_prixCtrl.text),
        placesTotales: int.parse(_placesTotalCtrl.text),
        placesDisponibles: widget.event == null ? int.parse(_placesTotalCtrl.text) : widget.event!.placesDisponibles,
        affiche: _afficheCtrl.text,
        bandeAnnonce: _baCtrl.text,
        organisateur: _orgaCtrl.text,
        statut: _statut,
        annulationGratuite: _annulationGratuite,
        delaiAnnulation: int.parse(_delaiAnnulCtrl.text),
        fraisAnnulation: double.parse(_fraisAnnulCtrl.text),
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
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
      }
    }
  }
}
