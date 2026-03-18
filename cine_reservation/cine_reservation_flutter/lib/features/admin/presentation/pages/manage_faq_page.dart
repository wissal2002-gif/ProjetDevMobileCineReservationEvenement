import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';

// Provider pour la gestion admin des FAQs
final adminFaqProvider = FutureProvider<List<Faq>>((ref) async {
  return await client.admin.getAdminFaqs();
});

class ManageFaqPage extends ConsumerWidget {
  const ManageFaqPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(adminFaqProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION FAQ"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFaqDialog(context, ref),
        label: const Text("Ajouter une question"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accent,
      ),
      body: faqsAsync.when(
        data: (faqs) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(faq.question, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(faq.reponse, style: const TextStyle(color: Colors.white54), maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => _showFaqDialog(context, ref, faq: faq),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteFaq(context, ref, faq.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  void _showFaqDialog(BuildContext context, WidgetRef ref, {Faq? faq}) {
    final qCtrl = TextEditingController(text: faq?.question);
    final rCtrl = TextEditingController(text: faq?.reponse);
    final oCtrl = TextEditingController(text: (faq?.ordre ?? 0).toString());
    bool active = faq?.actif ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: Text(faq == null ? "Ajouter FAQ" : "Modifier FAQ"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: qCtrl, decoration: const InputDecoration(labelText: "Question")),
                const SizedBox(height: 10),
                TextField(controller: rCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Réponse")),
                const SizedBox(height: 10),
                TextField(controller: oCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Ordre")),
                SwitchListTile(
                  title: const Text("Actif"),
                  value: active,
                  onChanged: (v) => setState(() => active = v),
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
            ElevatedButton(
              onPressed: () async {
                final newFaq = Faq(
                  id: faq?.id,
                  question: qCtrl.text,
                  reponse: rCtrl.text,
                  ordre: int.tryParse(oCtrl.text) ?? 0,
                  actif: active,
                );
                if (faq == null) await client.admin.ajouterFaq(newFaq);
                else await client.admin.modifierFaq(newFaq);
                ref.invalidate(adminFaqProvider);
                Navigator.pop(context);
              },
              child: const Text("ENREGISTRER"),
            )
          ],
        ),
      ),
    );
  }

  void _deleteFaq(BuildContext context, WidgetRef ref, int id) async {
    await client.admin.supprimerFaq(id);
    ref.invalidate(adminFaqProvider);
  }
}
