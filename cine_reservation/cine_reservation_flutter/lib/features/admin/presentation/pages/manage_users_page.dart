import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';

class ManageUsersPage extends ConsumerWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUtilisateursProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("GESTION UTILISATEURS & RÔLES"),
        centerTitle: true,
      ),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final bool isSuspended = user.statut == 'suspendu';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.accent.withOpacity(0.1),
                  child: Text(user.nom.isNotEmpty ? user.nom[0].toUpperCase() : "U", 
                       style: const TextStyle(color: AppColors.accent)),
                ),
                title: Text(user.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${user.email} • ${user.role?.toUpperCase()}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings, color: Colors.blueAccent),
                      onPressed: () => _showRoleDialog(context, ref, user),
                      tooltip: "Modifier le rôle",
                    ),
                    IconButton(
                      icon: Icon(isSuspended ? Icons.play_arrow : Icons.pause, 
                           color: isSuspended ? Colors.green : Colors.orange),
                      onPressed: () => _toggleStatus(context, ref, user),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _infoRow("ID Interne", "#${user.id}"),
                        _infoRow("Téléphone", user.telephone ?? "N/A"),
                        _infoRow("Cinéma lié", user.cinemaId?.toString() ?? "Aucun (Global)"),
                        _infoRow("Points", "${user.pointsFidelite ?? 0}"),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _showHistory(context, ref, user),
                          child: const Text("VOIR HISTORIQUE"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, WidgetRef ref, Utilisateur user) {
    final roles = ['client', 'admin_local', 'resp_evenements', 'super_admin'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Rôle pour ${user.nom}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: roles.map((r) => ListTile(
            title: Text(r.toUpperCase()),
            onTap: () async {
              await client.admin.modifierUtilisateurRole(user.id!, r);
              ref.invalidate(allUtilisateursProvider);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _toggleStatus(BuildContext context, WidgetRef ref, Utilisateur user) async {
    if (user.statut == 'suspendu') await client.admin.activerUtilisateur(user.id!);
    else await client.admin.suspendreUtilisateur(user.id!);
    ref.invalidate(allUtilisateursProvider);
  }

  void _showHistory(BuildContext context, WidgetRef ref, Utilisateur user) {
    // Logique déjà existante pour l'historique
  }

  Widget _infoRow(String label, String val) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [Text("$label: ", style: const TextStyle(color: Colors.white38)), Text(val)]),
  );
}
