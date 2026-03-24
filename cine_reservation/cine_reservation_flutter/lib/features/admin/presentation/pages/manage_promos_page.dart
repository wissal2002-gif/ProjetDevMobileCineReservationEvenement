import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_sidebar.dart'; // Import de la sidebar
import 'package:intl/intl.dart';

class ManagePromosPage extends ConsumerStatefulWidget {
  const ManagePromosPage({super.key});

  @override
  ConsumerState<ManagePromosPage> createState() => _ManagePromosPageState();
}

class _ManagePromosPageState extends ConsumerState<ManagePromosPage> {
  String _filter = "Tous";
  String _searchQuery = "";
  String _sortBy = "Date";

  @override
  Widget build(BuildContext context) {
    final promosAsync = ref.watch(allCodesPromoProvider);
    final summaryAsync = ref.watch(globalPromoSummaryProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("GESTION DES CODES PROMO",
            style: TextStyle(fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.bold)),
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
      body: Row(
        children: [
          // Sidebar masquée sur Pixel 7
          if (!isMobile) const SizedBox(width: 280, child: AdminSidebar()),

          Expanded(
            child: Column(
              children: [
                summaryAsync.when(
                  data: (stats) => _buildSummaryStats(stats, isMobile),
                  loading: () => const LinearProgressIndicator(color: AppColors.accent),
                  error: (_, __) => const SizedBox(),
                ),
                _buildFilterBar(isMobile),
                Expanded(
                  child: promosAsync.when(
                    data: (promos) {
                      final filtered = _applyFilters(promos);
                      if (filtered.isEmpty) {
                        return const Center(child: Text("Aucun code promo trouvé", style: TextStyle(color: Colors.white54)));
                      }

                      // Liste adaptative
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _buildPromoCard(filtered[index], isMobile),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                    error: (e, _) => Center(child: Text("Erreur: $e")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPromoDialog(context),
        label: Text(isMobile ? "Nouveau" : "Nouveau Code", style: const TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  Widget _buildSummaryStats(Map<String, dynamic> stats, bool isMobile) {
    final int activeCodes = stats['activeCodes'] ?? 0;
    final int todayUsages = stats['todayUsages'] ?? 0;
    final double totalSavings = (stats['totalSavings'] ?? 0.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statSummaryItem(isMobile ? "ACTIFS" : "CODES ACTIFS", "$activeCodes", Icons.check_circle_outline, Colors.green, isMobile),
          _statSummaryItem(isMobile ? "USAGES" : "USAGES JOUR", "$todayUsages", Icons.history, Colors.blue, isMobile),
          _statSummaryItem(isMobile ? "ECON." : "ÉCONOMIES (DH)", "${totalSavings.toStringAsFixed(0)}", Icons.savings_outlined, Colors.orange, isMobile),
        ],
      ),
    );
  }

  Widget _statSummaryItem(String label, String value, IconData icon, Color color, bool isMobile) {
    return Column(
      children: [
        Icon(icon, color: color, size: isMobile ? 18 : 22),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9)),
      ],
    );
  }

  Widget _buildFilterBar(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Rechercher un code...",
              prefixIcon: const Icon(Icons.search, color: Colors.white24, size: 20),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          // FIX : Scroll horizontal pour les filtres sur Pixel 7
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip("Tous"),
                _filterChip("Actifs"),
                _filterChip("Expirés"),
                _filterChip("Épuisés"),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _sortBy,
                  dropdownColor: AppColors.cardBg,
                  underline: const SizedBox(),
                  style: const TextStyle(color: AppColors.accent, fontSize: 11),
                  items: ["Date", "Utilisations"].map((s) => DropdownMenuItem(value: s, child: Text("Tri: $s"))).toList(),
                  onChanged: (v) => setState(() => _sortBy = v!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _filter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontSize: 10)),
        selected: isSelected,
        onSelected: (val) => setState(() => _filter = label),
        selectedColor: AppColors.accent,
        backgroundColor: Colors.white10,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  // Card adaptative pour le Pixel 7
  Widget _buildPromoCard(CodePromo p, bool isMobile) {
    return Card(
      color: AppColors.cardBg,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white10), // Utilisez 'side'
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(p.code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(
                "${p.reduction}${p.typeReduction == 'pourcentage' ? '%' : ' DH'}",
                style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Usages: ${p.utilisationsActuelles ?? 0}/${p.utilisationsMax ?? '∞'}", style: const TextStyle(color: Colors.white54, fontSize: 11)),
            Text("Expire le: ${p.dateExpiration != null ? DateFormat('dd/MM/yyyy').format(p.dateExpiration!) : 'Jamais'}", style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, size: 20, color: Colors.blueAccent), onPressed: () => _showPromoDialog(context, promo: p)),
            IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent), onPressed: () => _deletePromo(context, ref, p)),
          ],
        ),
      ),
    );
  }

  List<CodePromo> _applyFilters(List<CodePromo> list) {
    var result = list.where((p) => p.code.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    if (_filter == "Actifs") result = result.where((p) => p.actif == true && (p.dateExpiration == null || p.dateExpiration!.isAfter(DateTime.now()))).toList();
    if (_filter == "Expirés") result = result.where((p) => p.dateExpiration != null && p.dateExpiration!.isBefore(DateTime.now())).toList();
    if (_sortBy == "Utilisations") result.sort((a, b) => (b.utilisationsActuelles ?? 0).compareTo(a.utilisationsActuelles ?? 0));
    return result;
  }

  // --- LOGIQUE DIALOGUES (Garder identique mais ajouter scroll) ---
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
                if (promo == null) await client.admin.ajouterCodePromo(cp); else await client.admin.modifierCodePromo(cp);
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
        title: const Text("Supprimer ?", style: TextStyle(color: Colors.white)),
        content: Text("Supprimer le code '${promo.code}' ?", style: const TextStyle(color: Colors.white70)),
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