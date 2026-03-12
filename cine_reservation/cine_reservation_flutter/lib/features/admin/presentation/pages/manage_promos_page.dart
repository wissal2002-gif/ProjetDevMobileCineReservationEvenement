import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManagePromosPage extends ConsumerWidget {
  const ManagePromosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promosAsync = ref.watch(allCodesPromoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("GESTION DES PROMOTIONS")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPromoDialog(context, ref),
        label: const Text("Créer un Code"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accent,
      ),
      body: promosAsync.when(
        data: (promos) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: promos.length,
          itemBuilder: (context, index) => _buildPromoCard(context, ref, promos[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, WidgetRef ref, CodePromo promo) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(promo.code, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(promo.description ?? "Pas de description", style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: Switch(
          value: promo.actif ?? true,
          onChanged: (val) async {
            await client.admin.modifierCodePromo(promo.copyWith(actif: val));
            ref.invalidate(allCodesPromoProvider);
          },
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Réduction:", "${promo.reduction} ${promo.typeReduction == 'pourcentage' ? '%' : 'DH'}"),
                _infoRow("Min. Achat:", "${promo.montantMinimum ?? 0} DH"),
                _infoRow("Expire le:", promo.dateExpiration != null ? DateFormat('dd/MM/yyyy').format(promo.dateExpiration!) : "Jamais"),
                const Divider(color: Colors.white10, height: 24),
                const Text("ANALYTIQUE", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                ref.watch(codePromoStatsProvider(promo.id!)).when(
                  data: (stats) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem("Utilisations", "${stats['totalUsages']}"),
                      _statItem("Clients uniques", "${stats['uniqueUsers']}"),
                      _statItem("Économie totale", "${stats['totalReduction'].toStringAsFixed(0)} DH"),
                    ],
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text("Erreur stats"),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _deletePromo(context, ref, promo),
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      label: const Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  void _showPromoDialog(BuildContext context, WidgetRef ref) {
    final codeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final redCtrl = TextEditingController();
    final minCtrl = TextEditingController(text: "0");
    String typeRed = "pourcentage";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: const Text("Nouveau Code Promo"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textField(codeCtrl, "CODE (ex: SOLDES2024)"),
                _textField(descCtrl, "Description"),
                Row(
                  children: [
                    Expanded(child: _textField(redCtrl, "Valeur", isNumber: true)),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: typeRed,
                      dropdownColor: AppColors.cardBg,
                      items: ["pourcentage", "fixe"].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setDialogState(() => typeRed = v!),
                    ),
                  ],
                ),
                _textField(minCtrl, "Montant minimum d'achat", isNumber: true),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                final cp = CodePromo(
                  code: codeCtrl.text.toUpperCase(),
                  description: descCtrl.text,
                  reduction: double.parse(redCtrl.text),
                  typeReduction: typeRed,
                  montantMinimum: double.parse(minCtrl.text),
                  actif: true,
                  utilisationsActuelles: 0,
                );
                await client.admin.ajouterCodePromo(cp);
                ref.invalidate(allCodesPromoProvider);
                Navigator.pop(context);
              },
              child: const Text("Créer"),
            )
          ],
        ),
      ),
    );
  }

  void _deletePromo(BuildContext context, WidgetRef ref, CodePromo promo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer le code ?"),
        content: Text("Voulez-vous supprimer le code '${promo.code}' ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerCodePromo(promo.id!);
              ref.invalidate(allCodesPromoProvider);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        SizedBox(width: 100, child: Text("$label ", style: const TextStyle(color: Colors.white38, fontSize: 12))),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ]),
    );
  }

  Widget _textField(TextEditingController ctrl, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white10),
      ),
    );
  }
}
