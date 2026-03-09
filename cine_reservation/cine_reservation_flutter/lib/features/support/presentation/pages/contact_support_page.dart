import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/support_provider.dart';

class ContactSupportPage extends ConsumerStatefulWidget {
  const ContactSupportPage({super.key});

  @override
  ConsumerState<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends ConsumerState<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _sujetController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mesDemandes = ref.watch(mesDemandesProvider);
    final envoiState = ref.watch(supportActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Aide & Support")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Envoyer une nouvelle demande", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _sujetController,
                    decoration: const InputDecoration(labelText: "Sujet", border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: "Votre message", border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: envoiState.isLoading ? null : _envoyer,
                    child: envoiState.isLoading ? const CircularProgressIndicator() : const Text("Envoyer à l'admin"),
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            const Text("Mes demandes précédentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            mesDemandes.when(
              data: (list) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final d = list[index];
                  return Card(
                    child: ExpansionTile(
                      title: Text(d.sujet),
                      subtitle: Text("Statut: ${d.statut}"),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Message: ${d.message}"),
                              const Divider(),
                              Text("Réponse Admin: ${d.reponse ?? 'En attente...'}",
                                  style: TextStyle(color: d.reponse != null ? Colors.green : Colors.orange)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Erreur lors de la récupération : $e"),
            )
          ],
        ),
      ),
    );
  }

  void _envoyer() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(supportActionProvider.notifier).envoyerMessage(
          _sujetController.text,
          _messageController.text
      );
      _sujetController.clear();
      _messageController.clear();
      ref.invalidate(mesDemandesProvider); // Rafraîchir la liste
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Demande envoyée !")));
    }
  }
}