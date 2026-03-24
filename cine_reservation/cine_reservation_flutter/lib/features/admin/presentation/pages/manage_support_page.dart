import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManageSupportPage extends ConsumerWidget {
  const ManageSupportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportAsync = ref.watch(allDemandesSupportProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("SUPPORT CLIENT"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            tooltip: "Actualiser",
            onPressed: () {
              ref.invalidate(allDemandesSupportProvider);
              ref.invalidate(allUtilisateursProvider);
            },
          )
        ],
      ),
      body: supportAsync.when(
        data: (demandes) => usersAsync.when(
          data: (users) {
            if (demandes.isEmpty) {
              return const Center(child: Text("Aucune demande de support.", style: TextStyle(color: Colors.white54)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: demandes.length,
              itemBuilder: (context, index) {
                final demande = demandes[index];
                final user = users.firstWhere((u) => u.id == demande.utilisateurId, orElse: () => Utilisateur(nom: "Inconnu", email: "N/A"));
                final bool isClosed = demande.statut == 'traité';

                return Card(
                  color: Colors.white.withOpacity(0.05),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: Icon(isClosed ? Icons.check_circle : Icons.error_outline, 
                                 color: isClosed ? Colors.greenAccent : Colors.orangeAccent),
                    title: Text(demande.sujet, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text("Par: ${user.nom} • ${DateFormat('dd/MM/yyyy HH:mm').format(demande.createdAt ?? DateTime.now())}", 
                                   style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Message de l'utilisateur :", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(demande.message, style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 16),
                            if (demande.reponse != null) ...[
                              const Text("Votre réponse :", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(demande.reponse!, style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
                            ] else ...[
                              ElevatedButton.icon(
                                onPressed: () => _showReplyDialog(context, ref, demande),
                                icon: const Icon(Icons.reply),
                                label: const Text("Répondre"),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent.withOpacity(0.2)),
                              ),
                            ],
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Center(child: Text("Erreur utilisateurs: $e")),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, __) => Center(child: Text("Erreur support : $e")),
      ),
    );
  }

  void _showReplyDialog(BuildContext context, WidgetRef ref, DemandeSupport demande) {
    final reponseCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Répondre à la demande", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: reponseCtrl,
          maxLines: 5,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Saisissez votre réponse ici...",
            hintStyle: TextStyle(color: Colors.white24),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (reponseCtrl.text.isEmpty) return;
              try {
                await client.admin.repondreDemande(demande.id!, reponseCtrl.text);
                ref.invalidate(allDemandesSupportProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Réponse envoyée !"), backgroundColor: Colors.green));
              } catch (e) {
                print("Erreur: $e");
              }
            },
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }
}
