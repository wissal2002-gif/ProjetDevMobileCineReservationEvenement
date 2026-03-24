import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';
import 'package:intl/intl.dart';

class ManagePromosTangerPage extends ConsumerStatefulWidget {
  const ManagePromosTangerPage({super.key});

  @override
  ConsumerState<ManagePromosTangerPage> createState() => _ManagePromosTangerPageState();
}

class _ManagePromosTangerPageState extends ConsumerState<ManagePromosTangerPage> {
  String _searchQuery = "";

  // ✅ CORRECTION : Ajout de la méthode _field manquante
  Widget _field(TextEditingController ctrl, String label, {bool isNumber = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final promosAsync = ref.watch(allCodesPromoProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fab_promo_tanger_unique",
        onPressed: () => _showPromoDialog(context), // ✅ Context passé correctement
        label: const Text("NOUVEAU CODE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber,
      ),
      body: Row(
        children: [
          if (!isMobile) const SizedBox(width: 280, child: TangerSidebar()),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("GESTION DES CODES PROMO",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Rechercher un code...",
                      prefixIcon: const Icon(Icons.search, color: Colors.amber),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: promosAsync.when(
                      data: (promos) {
                        final filtered = promos.where((p) => p.code.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                        if (filtered.isEmpty) return const Center(child: Text("Aucun code promo.", style: TextStyle(color: Colors.white24)));
                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => _buildPromoCard(filtered[index]),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
                      error: (e, _) => Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.redAccent))),
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

  Widget _buildPromoCard(CodePromo p) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(p.code, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        subtitle: Text("${p.reduction} ${p.typeReduction == 'pourcentage' ? '%' : 'DH'} | Max: ${p.utilisationsMax}",
            style: const TextStyle(color: Colors.white70)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showPromoDialog(context, promo: p) // ✅ Context ajouté
            ),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletePromo(p.id!)
            ),
          ],
        ),
      ),
    );
  }

  // ✅ CORRECTION : Ajout de BuildContext context dans la signature
  void _showPromoDialog(BuildContext context, {CodePromo? promo}) {
    final code = TextEditingController(text: promo?.code);
    final desc = TextEditingController(text: promo?.description);
    final reduc = TextEditingController(text: promo?.reduction.toString() ?? "");
    final min = TextEditingController(text: promo?.montantMinimum?.toString() ?? "0");
    final maxU = TextEditingController(text: promo?.utilisationsMax?.toString() ?? "100");
    String type = promo?.typeReduction ?? "pourcentage";
    DateTime? expiry = promo?.dateExpiration;
    bool actif = promo?.actif ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setSt) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(promo == null ? "NOUVEAU CODE" : "MODIFIER LE CODE", style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(code, "CODE (ex: TANGER20)", isNumber: false),
            _field(desc, "Description", isNumber: false),
            _field(reduc, "Valeur réduction"),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: type,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Type de réduction", labelStyle: TextStyle(color: Colors.amber)),
              items: ["pourcentage", "fixe"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setSt(() => type = v!),
            ),
            _field(min, "Montant minimum achat"),
            _field(maxU, "Utilisations max"),
            ListTile(
              title: const Text("Expiration", style: TextStyle(color: Colors.white70, fontSize: 14)),
              subtitle: Text(expiry == null ? "Aucune" : DateFormat('dd/MM/yyyy').format(expiry!), style: const TextStyle(color: Colors.amber)),
              trailing: const Icon(Icons.calendar_today, color: Colors.amber),
              onTap: () async {
                final d = await showDatePicker(
                    context: context,
                    initialDate: expiry ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100)
                );
                if (d != null) setSt(() => expiry = d);
              },
            ),
            SwitchListTile(
                title: const Text("Statut Actif", style: TextStyle(color: Colors.white70)),
                value: actif,
                activeColor: Colors.amber,
                onChanged: (v) => setSt(() => actif = v)
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () async {
                final cp = CodePromo(
                  id: promo?.id,
                  code: code.text.toUpperCase(),
                  description: desc.text,
                  reduction: double.tryParse(reduc.text) ?? 0.0,
                  typeReduction: type,
                  montantMinimum: double.tryParse(min.text) ?? 0.0,
                  dateExpiration: expiry,
                  utilisationsMax: int.tryParse(maxU.text) ?? 100,
                  utilisationsActuelles: promo?.utilisationsActuelles ?? 0,
                  actif: actif,
                );
                if (promo == null) await client.admin.ajouterCodePromo(cp);
                else await client.admin.modifierCodePromo(cp);
                ref.invalidate(allCodesPromoProvider);
                Navigator.pop(context);
              },
              child: const Text("ENREGISTRER", style: TextStyle(color: Colors.black))
          )
        ],
      )),
    );
  }

  void _deletePromo(int id) async {
    await client.admin.supprimerCodePromo(id);
    ref.invalidate(allCodesPromoProvider);
  }
}