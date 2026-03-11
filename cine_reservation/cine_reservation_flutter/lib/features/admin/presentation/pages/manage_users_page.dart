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
        title: const Text("GESTION DES UTILISATEURS"),
      ),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final bool isSuspended = user.statut == 'suspendu';

            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.accent.withOpacity(0.1),
                  backgroundImage: user.photoProfil != null ? NetworkImage(user.photoProfil!) : null,
                  child: user.photoProfil == null ? Text(user.nom[0].toUpperCase(), style: const TextStyle(color: AppColors.accent)) : null,
                ),
                title: Text(user.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(user.email, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(isSuspended ? Icons.play_circle_outline : Icons.pause_circle_outline, 
                           color: isSuspended ? Colors.greenAccent : Colors.orangeAccent),
                      onPressed: () => _toggleUserStatus(context, ref, user),
                      tooltip: isSuspended ? "Activer" : "Suspendre",
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _confirmDeleteUser(context, ref, user),
                      tooltip: "Supprimer",
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Informations Personnelles", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        _infoItem(Icons.phone, "Téléphone", user.telephone ?? "Non renseigné"),
                        _infoItem(Icons.cake, "Date de naissance", user.dateNaissance != null ? DateFormat('dd/MM/yyyy').format(user.dateNaissance!) : "Non renseigné"),
                        _infoItem(Icons.star, "Points fidélité", "${user.pointsFidelite ?? 0} pts"),
                        _infoItem(Icons.admin_panel_settings, "Rôle", user.role ?? "Client"),
                        _infoItem(Icons.info_outline, "Statut", user.statut?.toUpperCase() ?? "ACTIF"),
                        
                        const SizedBox(height: 16),
                        const Text("Préférences", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: (user.preferences ?? ["Aucune"]).map((p) => Chip(
                            label: Text(p, style: const TextStyle(fontSize: 10)),
                            backgroundColor: Colors.white10,
                          )).toList(),
                        ),

                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _showUserHistory(context, ref, user),
                          icon: const Icon(Icons.history),
                          label: const Text("Voir historique d'achat"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent.withOpacity(0.2)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, __) => Center(child: Text("Erreur : $e", style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 10),
          Text("$label : ", style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }

  void _showUserHistory(BuildContext context, WidgetRef ref, Utilisateur user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Historique de ${user.nom}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(color: Colors.white10),
              Expanded(
                child: ref.watch(userHistoryProvider(user.id!)).when(
                  data: (history) {
                    if (history.isEmpty) {
                      return const Center(child: Text("Aucun achat trouvé.", style: TextStyle(color: Colors.white54)));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final res = history[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.confirmation_number_outlined, color: AppColors.accent),
                          title: Text("Réservation #${res.id}", style: const TextStyle(color: Colors.white)),
                          subtitle: Text("${DateFormat('dd/MM/yyyy HH:mm').format(res.dateReservation)} • ${res.statut}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          trailing: Text("${res.montantTotal} DH", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, __) => Text("Erreur : $e"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleUserStatus(BuildContext context, WidgetRef ref, Utilisateur user) async {
    final bool isSuspended = user.statut == 'suspendu';
    try {
      if (isSuspended) {
        await client.admin.activerUtilisateur(user.id!);
      } else {
        await client.admin.suspendreUtilisateur(user.id!);
      }
      ref.invalidate(allUtilisateursProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Utilisateur ${isSuspended ? 'activé' : 'suspendu'} !"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red));
    }
  }

  void _confirmDeleteUser(BuildContext context, WidgetRef ref, Utilisateur user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text("Supprimer l'utilisateur ?"),
        content: Text("Voulez-vous vraiment supprimer définitivement ${user.nom} ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              try {
                await client.admin.supprimerUtilisateur(user.id!);
                ref.invalidate(allUtilisateursProvider);
                Navigator.pop(context);
              } catch (e) {
                print("Erreur: $e");
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
