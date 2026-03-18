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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(allUtilisateursProvider),
          )
        ],
      ),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final bool isSuspended = user.statut == 'suspendu';
            final String role = user.role ?? 'client';

            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.accent.withOpacity(0.1),
                  child: Text(user.nom.isNotEmpty ? user.nom[0].toUpperCase() : "U", 
                       style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                ),
                title: Text(user.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text("${user.email} • ${role.toUpperCase()}", 
                    style: TextStyle(color: role == 'super_admin' ? Colors.amber : Colors.white54, fontSize: 12)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings, color: Colors.blueAccent),
                      onPressed: () => _showRoleDialog(context, ref, user),
                      tooltip: "Modifier le rôle",
                    ),
                    IconButton(
                      icon: Icon(isSuspended ? Icons.play_circle_outline : Icons.pause_circle_outline, 
                           color: isSuspended ? Colors.greenAccent : Colors.orangeAccent),
                      onPressed: () => _toggleStatus(context, ref, user),
                      tooltip: isSuspended ? "Activer" : "Suspendre",
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(Icons.fingerprint, "ID Utilisateur", "#${user.id}"),
                        _infoRow(Icons.phone, "Téléphone", user.telephone ?? "Non renseigné"),
                        _infoRow(Icons.location_city, "Cinéma ID", user.cinemaId?.toString() ?? "Accès Global"),
                        _infoRow(Icons.star, "Points Fidélité", "${user.pointsFidelite ?? 0}"),
                        _infoRow(Icons.info_outline, "Statut Compte", (user.statut ?? 'ACTIF').toUpperCase()),
                        
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showHistory(context, ref, user),
                            icon: const Icon(Icons.history, size: 18),
                            label: const Text("VOIR L'HISTORIQUE DES ACHATS"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text("Erreur: $e", style: const TextStyle(color: Colors.redAccent))),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, WidgetRef ref, Utilisateur user) {
    final roles = ['client', 'admin_local', 'resp_evenements', 'super_admin'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("Assigner un rôle à ${user.nom}", style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: roles.map((r) => ListTile(
            title: Text(r.toUpperCase(), style: TextStyle(color: user.role == r ? AppColors.accent : Colors.white70)),
            trailing: user.role == r ? const Icon(Icons.check, color: AppColors.accent) : null,
            onTap: () async {
              try {
                await client.admin.modifierUtilisateurRole(user.id!, r);
                ref.invalidate(allUtilisateursProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Rôle mis à jour : ${r.toUpperCase()}"), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.redAccent));
              }
            },
          )).toList(),
        ),
      ),
    );
  }

  void _toggleStatus(BuildContext context, WidgetRef ref, Utilisateur user) async {
    final bool isSuspended = user.statut == 'suspendu';
    try {
      if (isSuspended) {
        await client.admin.activerUtilisateur(user.id!);
      } else {
        await client.admin.suspendreUtilisateur(user.id!);
      }
      ref.invalidate(allUtilisateursProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Utilisateur ${isSuspended ? 'activé' : 'suspendu'} !"), backgroundColor: Colors.amber),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  void _showHistory(BuildContext context, WidgetRef ref, Utilisateur user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Historique : ${user.nom}", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              const Divider(color: Colors.white10, height: 32),
              Expanded(
                child: ref.watch(userHistoryProvider(user.id!)).when(
                  data: (history) {
                    if (history.isEmpty) return const Center(child: Text("Aucune réservation trouvée.", style: TextStyle(color: Colors.white24)));
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final res = history[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.receipt_long, color: AppColors.accent, size: 20),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Réservation #${res.id}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text(DateFormat('dd/MM/yyyy HH:mm').format(res.dateReservation), style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Text("${res.montantTotal} DH", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Erreur : $e")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white24),
          const SizedBox(width: 12),
          Text("$label : ", style: const TextStyle(color: Colors.white38, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
