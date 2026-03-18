import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManagePromosPage extends ConsumerStatefulWidget {
  const ManagePromosPage({super.key});

  @override
  ConsumerState<ManagePromosPage> createState() => _ManagePromosPageState();
}

class _ManagePromosPageState extends ConsumerState<ManagePromosPage> {
  String _filter = "Tous"; // Tous, Actifs, Expirés, Épuisés
  String _searchQuery = "";
  String _sortBy = "Date"; // Date, Utilisations, Réduction

  @override
  Widget build(BuildContext context) {
    final promosAsync = ref.watch(allCodesPromoProvider);
    final summaryAsync = ref.watch(globalPromoSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION DES CODES PROMO"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            onPressed: () {
              ref.invalidate(allCodesPromoProvider);
              ref.invalidate(globalPromoSummaryProvider);
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Section 1 - Statistiques rapides
          summaryAsync.when(
            data: (stats) => _buildSummaryStats(stats),
            loading: () => const LinearProgressIndicator(color: AppColors.accent),
            error: (_, __) => const SizedBox(),
          ),

          // Barre de filtres et recherche
          _buildFilterBar(),

          // Section 2 - Liste des codes promo (Tableau)
          Expanded(
            child: promosAsync.when(
              data: (promos) {
                final filtered = _applyFilters(promos);
                if (filtered.isEmpty) {
                  return const Center(child: Text("Aucun code promo trouvé", style: TextStyle(color: Colors.white54)));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(16),
                  child: _buildPromoTable(filtered),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Erreur: $e")),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPromoDialog(context),
        label: const Text("Nouveau Code", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  Widget _buildSummaryStats(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statSummaryItem("CODES ACTIFS", "${stats['activeCodes']}", Icons.check_circle_outline, Colors.green),
          _statSummaryItem("USAGES AUJOURD'HUI", "${stats['todayUsages']}", Icons.history, Colors.blue),
          _statSummaryItem("ÉCONOMIES (DH)", "${(stats['totalSavings'] as double).toStringAsFixed(0)}", Icons.savings_outlined, Colors.orange),
        ],
      ),
    );
  }

  Widget _statSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Rechercher par code...",
              prefixIcon: const Icon(Icons.search, color: Colors.white24),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _filterChip("Tous"),
              _filterChip("Actifs"),
              _filterChip("Expirés"),
              _filterChip("Épuisés"),
              const Spacer(),
              DropdownButton<String>(
                value: _sortBy,
                dropdownColor: AppColors.cardBg,
                underline: const SizedBox(),
                style: const TextStyle(color: AppColors.accent, fontSize: 12),
                items: ["Date", "Utilisations", "Réduction"].map((s) => DropdownMenuItem(value: s, child: Text("Tri: $s"))).toList(),
                onChanged: (v) => setState(() => _sortBy = v!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _filter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontSize: 11)),
        selected: isSelected,
        onSelected: (val) => setState(() => _filter = label),
        selectedColor: AppColors.accent,
        backgroundColor: Colors.white10,
      ),
    );
  }

  List<CodePromo> _applyFilters(List<CodePromo> list) {
    var result = list.where((p) => p.code.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    
    if (_filter == "Actifs") result = result.where((p) => p.actif == true && (p.dateExpiration == null || p.dateExpiration!.isAfter(DateTime.now()))).toList();
    if (_filter == "Expirés") result = result.where((p) => p.dateExpiration != null && p.dateExpiration!.isBefore(DateTime.now())).toList();
    if (_filter == "Épuisés") result = result.where((p) => p.utilisationsActuelles! >= (p.utilisationsMax ?? 100)).toList();

    if (_sortBy == "Utilisations") result.sort((a, b) => b.utilisationsActuelles!.compareTo(a.utilisationsActuelles!));
    if (_sortBy == "Réduction") result.sort((a, b) => b.reduction.compareTo(a.reduction));
    
    return result;
  }

  Widget _buildPromoTable(List<CodePromo> promos) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
        5: FixedColumnWidth(80),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
          children: [
            _tableHeader("CODE"),
            _tableHeader("TYPE"),
            _tableHeader("RÉDUC."),
            _tableHeader("USAGES"),
            _tableHeader("EXPIRATION"),
            _tableHeader("ACTIONS"),
          ],
        ),
        ...promos.map((p) => _buildPromoRow(p)),
      ],
    );
  }

  Widget _tableHeader(String text) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(text, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)));

  TableRow _buildPromoRow(CodePromo p) {
    return TableRow(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
      children: [
        InkWell(
          onTap: () => _showPromoDetails(p),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                if (p.description != null) Text(p.description!, style: const TextStyle(color: Colors.white38, fontSize: 9)),
              ],
            ),
          ),
        ),
        _tableCell(p.typeReduction == 'pourcentage' ? "%" : "Fixe"),
        _tableCell("${p.reduction}${p.typeReduction == 'pourcentage' ? '%' : ' DH'}"),
        _tableCell("${p.utilisationsActuelles}/${p.utilisationsMax}"),
        _tableCell(p.dateExpiration != null ? DateFormat('dd/MM/yy').format(p.dateExpiration!) : "-"),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.edit, size: 16, color: Colors.blueAccent), onPressed: () => _showPromoDialog(context, promo: p)),
            IconButton(icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent), onPressed: () => _deletePromo(context, ref, p)),
          ],
        ),
      ],
    );
  }

  Widget _tableCell(String text) => Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)));

  void _showPromoDetails(CodePromo p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Code : ${p.code}", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _detailLine("Total utilisations", "${p.utilisationsActuelles} / ${p.utilisationsMax}"),
            
            ref.watch(codePromoStatsProvider(p.id!)).when(
              data: (stats) => Column(
                children: [
                  _detailLine("Économies générées", "${(stats['totalReduction'] as double).toStringAsFixed(0)} DH"),
                  _detailLine("Dernière utilisation", stats['lastUsage'] != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(stats['lastUsage'])) : "Jamais"),
                  _detailLine("Utilisateurs uniques", "${stats['uniqueUsers']}"),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text("Erreur de chargement des stats", style: TextStyle(color: Colors.redAccent)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text("$label : ", style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showPromoDialog(BuildContext context, {CodePromo? promo}) {
    final codeCtrl = TextEditingController(text: promo?.code);
    final descCtrl = TextEditingController(text: promo?.description);
    final redCtrl = TextEditingController(text: promo?.reduction.toString());
    final minCtrl = TextEditingController(text: promo?.montantMinimum?.toString() ?? "0");
    final maxCtrl = TextEditingController(text: promo?.utilisationsMax?.toString() ?? "100");
    String typeRed = promo?.typeReduction ?? "pourcentage";
    DateTime? expiry = promo?.dateExpiration;
    bool isActif = promo?.actif ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: Text(promo == null ? "Nouveau Code" : "Modifier le Code"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formField(codeCtrl, "Code promo *"),
                _formField(descCtrl, "Description"),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: typeRed,
                        dropdownColor: AppColors.cardBg,
                        decoration: const InputDecoration(labelText: "Type"),
                        items: ["pourcentage", "fixe"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                        onChanged: (v) => setState(() => typeRed = v!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _formField(redCtrl, "Valeur *", isNumber: true)),
                  ],
                ),
                _formField(minCtrl, "Montant minimum DH", isNumber: true),
                _formField(maxCtrl, "Utilisations max", isNumber: true),
                
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Date expiration", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  subtitle: Text(expiry != null ? DateFormat('dd/MM/yyyy').format(expiry!) : "Non définie"),
                  trailing: const Icon(Icons.calendar_today, size: 18, color: AppColors.accent),
                  onTap: () async {
                    final picked = await showDatePicker(context: context, initialDate: expiry ?? DateTime.now().add(const Duration(days: 30)), firstDate: DateTime.now(), lastDate: DateTime(2100));
                    if (picked != null) setState(() => expiry = picked);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Statut Actif", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  value: isActif,
                  onChanged: (v) => setState(() => isActif = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                final cp = CodePromo(
                  id: promo?.id,
                  code: codeCtrl.text.toUpperCase(),
                  description: descCtrl.text,
                  reduction: double.tryParse(redCtrl.text) ?? 0.0,
                  typeReduction: typeRed,
                  montantMinimum: double.tryParse(minCtrl.text) ?? 0.0,
                  utilisationsMax: int.tryParse(maxCtrl.text) ?? 100,
                  utilisationsActuelles: promo?.utilisationsActuelles ?? 0,
                  dateExpiration: expiry,
                  actif: isActif,
                );
                
                if (promo == null) {
                  await client.admin.ajouterCodePromo(cp);
                } else {
                  await client.admin.modifierCodePromo(cp);
                }
                ref.invalidate(allCodesPromoProvider);
                ref.invalidate(globalPromoSummaryProvider);
                Navigator.pop(context);
              },
              child: const Text("Enregistrer"),
            )
          ],
        ),
      ),
    );
  }

  Widget _formField(TextEditingController ctrl, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white.withOpacity(0.05)),
      ),
    );
  }

  void _deletePromo(BuildContext context, WidgetRef ref, CodePromo promo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer ?"),
        content: Text("Supprimer le code '${promo.code}' ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerCodePromo(promo.id!);
              ref.invalidate(allCodesPromoProvider);
              ref.invalidate(globalPromoSummaryProvider);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
