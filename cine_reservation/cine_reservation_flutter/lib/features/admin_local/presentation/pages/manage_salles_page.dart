// manage_salles_local_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';

class ManageSallesLocalPage extends ConsumerStatefulWidget {
  const ManageSallesLocalPage({super.key});

  @override
  ConsumerState<ManageSallesLocalPage> createState() =>
      _ManageSallesLocalPageState();
}

class _ManageSallesLocalPageState
    extends ConsumerState<ManageSallesLocalPage> {
  int? selectedSalleId;

  // ── ÉTAT D'ÉDITION ──────────────────────────────────────────────────────
  final Set<int> _selectedSiegeIds = {};
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final admin = ref.watch(adminProfileProvider).value;
    final cinemaId = admin?.cinemaId;

    final sallesAsync = cinemaId != null
        ? ref.watch(sallesProvider(cinemaId))
        : const AsyncValue<List<Salle>>.loading();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      body: Row(
        children: [
          if (!isMobile) const LocalAdminSidebar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── TITRE ────────────────────────────────────────────
                  Text(
                    "CONFIGURATION DES SIÈGES - "
                        "${admin?.nomCinema?.toUpperCase() ?? 'CINÉMA'}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  // ── DROPDOWN SALLE ───────────────────────────────────
                  sallesAsync.when(
                    data: (salles) {
                      final localSalles = salles
                          .where((s) => s.cinemaId == cinemaId)
                          .toList();

                      if (localSalles.isEmpty) {
                        return const Text(
                          "Aucune salle configurée pour ce cinéma.",
                          style:
                          TextStyle(color: Colors.white24, fontSize: 16),
                        );
                      }

                      return SizedBox(
                        width: 400,
                        child: DropdownButtonFormField<int>(
                          dropdownColor: const Color(0xFF1A1A1A),
                          value: selectedSalleId,
                          decoration: const InputDecoration(
                            labelText: "SÉLECTIONNER UNE SALLE",
                            labelStyle: TextStyle(color: Colors.amber),
                            filled: true,
                            fillColor: Colors.white10,
                          ),
                          style: const TextStyle(color: Colors.white),
                          items: localSalles
                              .map((s) => DropdownMenuItem(
                            value: s.id,
                            child: Text("Salle ${s.codeSalle}"),
                          ))
                              .toList(),
                          onChanged: (val) => setState(() {
                            selectedSalleId = val;
                            _selectedSiegeIds.clear();
                            _editMode = false;
                          }),
                        ),
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text("Erreur: $e",
                        style: const TextStyle(color: Colors.redAccent)),
                  ),

                  const SizedBox(height: 40),

                  // ── GRILLE DES SIÈGES ────────────────────────────────
                  if (selectedSalleId != null)
                    Expanded(
                      child: ref
                          .watch(siegesBySalleProvider(selectedSalleId!))
                          .when(
                        data: (sieges) => sieges.isEmpty
                            ? Center(
                          child: ElevatedButton.icon(
                            onPressed: _showGenDialog,
                            icon: const Icon(Icons.grid_on),
                            label:
                            const Text("CRÉER LE PLAN DE SALLE"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10)),
                            ),
                          ),
                        )
                            : _buildSiegeEditor(sieges, isMobile),
                        loading: () => const Center(
                            child: CircularProgressIndicator(
                                color: Colors.amber)),
                        error: (e, _) => Center(
                            child: Text("Erreur: $e",
                                style: const TextStyle(
                                    color: Colors.redAccent))),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── ÉDITEUR DE SIÈGES ────────────────────────────────────────────────────

  Widget _buildSiegeEditor(List<Siege> sieges, bool isMobile) {
    final hasSelection = _selectedSiegeIds.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── BARRE D'OUTILS ───────────────────────────────────────────
        Row(
          children: [
            // Légende
            _legend(Colors.white10, "Standard"),
            const SizedBox(width: 16),
            _legend(Colors.amber, "VIP"),
            if (_editMode) ...[
              const SizedBox(width: 16),
              _legend(Colors.blue, "Sélectionné"),
            ],
            const Spacer(),
            Text(
              "${sieges.length} sièges",
              style:
              const TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(width: 16),

            // Bouton mode édition
            OutlinedButton.icon(
              onPressed: () => setState(() {
                _editMode = !_editMode;
                _selectedSiegeIds.clear();
              }),
              icon: Icon(
                _editMode ? Icons.close : Icons.edit,
                size: 16,
                color: _editMode ? Colors.redAccent : Colors.white54,
              ),
              label: Text(
                _editMode ? "ANNULER" : "MODIFIER",
                style: TextStyle(
                    color:
                    _editMode ? Colors.redAccent : Colors.white54,
                    fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color:
                    _editMode ? Colors.redAccent : Colors.white24),
              ),
            ),
          ],
        ),

        // ── ACTIONS SUR LA SÉLECTION ─────────────────────────────────
        if (_editMode) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "${_selectedSiegeIds.length} siège(s) sélectionné(s)",
                style: const TextStyle(
                    color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(width: 16),
              if (hasSelection) ...[
                // → Standard
                ElevatedButton.icon(
                  onPressed: () =>
                      _updateType(sieges, 'standard'),
                  icon: const Icon(Icons.chair_alt, size: 14),
                  label: const Text("→ Standard",
                      style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white12,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                // → VIP
                ElevatedButton.icon(
                  onPressed: () => _updateType(sieges, 'vip'),
                  icon: const Icon(Icons.star, size: 14),
                  label: const Text("→ VIP",
                      style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
              const Spacer(),
              // Tout sélectionner / Désélectionner
              TextButton(
                onPressed: () => setState(() {
                  if (_selectedSiegeIds.length == sieges.length) {
                    _selectedSiegeIds.clear();
                  } else {
                    _selectedSiegeIds
                        .addAll(sieges.map((s) => s.id!));
                  }
                }),
                child: Text(
                  _selectedSiegeIds.length == sieges.length
                      ? "Tout désélectionner"
                      : "Tout sélectionner",
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // ── GRILLE ───────────────────────────────────────────────────
        Expanded(
          child: GridView.builder(
            gridDelegate:
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 8 : 15,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: sieges.length,
            itemBuilder: (context, index) {
              final siege = sieges[index];
              final isSelected =
              _selectedSiegeIds.contains(siege.id);
              final isVip = siege.type == 'vip';

              return GestureDetector(
                onTap: _editMode
                    ? () => setState(() {
                  if (isSelected) {
                    _selectedSiegeIds.remove(siege.id);
                  } else {
                    _selectedSiegeIds.add(siege.id!);
                  }
                })
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withOpacity(0.4)
                        : isVip
                        ? Colors.amber
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected
                          ? Colors.blue
                          : isVip
                          ? Colors.amberAccent
                          : Colors.white12,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      siege.numero,
                      style: const TextStyle(
                          fontSize: 8, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── MISE À JOUR DU TYPE ───────────────────────────────────────────────────

  Future<void> _updateType(List<Siege> sieges, String type) async {
    final ids = List<int>.from(_selectedSiegeIds);
    try {
      await client.admin.updateSiegesType(ids, type);
      ref.invalidate(siegesBySalleProvider(selectedSalleId!));
      setState(() {
        _selectedSiegeIds.clear();
        _editMode = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${ids.length} siège(s) mis à jour → $type",
            ),
            backgroundColor: Colors.green.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur: $e"),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ── DIALOG GÉNÉRATION ─────────────────────────────────────────────────────

  void _showGenDialog() {
    final rowsCtrl = TextEditingController(text: "8");
    final colsCtrl = TextEditingController(text: "10");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Configuration de la salle",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rowsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Nombre de rangées",
                labelStyle: TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: colsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Sièges par rangée",
                labelStyle: TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ANNULER",
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black),
            onPressed: () async {
              await client.admin.genererSiegesPourSalle(
                selectedSalleId!,
                int.parse(rowsCtrl.text),
                int.parse(colsCtrl.text),
              );
              ref.invalidate(
                  siegesBySalleProvider(selectedSalleId!));
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text("GÉNÉRER"),
          ),
        ],
      ),
    );
  }

  // ── LÉGENDE ───────────────────────────────────────────────────────────────

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label,
            style:
            const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}