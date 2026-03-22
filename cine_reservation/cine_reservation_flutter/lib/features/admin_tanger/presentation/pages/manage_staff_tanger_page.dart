import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart'; // Accès au client Serverpod
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/tanger_sidebar.dart';

class ManageStaffTangerPage extends ConsumerWidget {
  const ManageStaffTangerPage({super.key});

  final int tangerCinemaId = 9;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On observe le staff de Tanger via le provider (à définir dans admin_provider.dart)
    final staffAsync = ref.watch(staffTangerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fab_add_staff_tanger",
        backgroundColor: Colors.amber,
        onPressed: () => _showAddStaffDialog(context, ref),
        label: const Text("AJOUTER STAFF", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.person_add, color: Colors.black),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Sidebar fixe (SANS CONST pour éviter les erreurs de calcul sur Chrome)
          SizedBox(width: 280, child: TangerSidebar()),

          // 2. Contenu principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ÉQUIPE TANGER - STAFF SCANNER",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Gérez les accès pour le contrôle des billets à l'entrée des salles",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  Expanded(
                    child: staffAsync.when(
                      data: (staffList) {
                        if (staffList.isEmpty) {
                          return const Center(child: Text("Aucun membre du staff pour Tanger.", style: TextStyle(color: Colors.white24)));
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: staffList.length,
                          itemBuilder: (context, index) => _buildStaffCard(context, ref, staffList[index]),
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

  Widget _buildStaffCard(BuildContext context, WidgetRef ref, Utilisateur staff) {
    final bool isSuspended = staff.statut == 'suspendu';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSuspended ? Colors.red.withOpacity(0.2) : Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isSuspended ? Colors.grey : Colors.amber,
            child: Text(staff.nom[0].toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(staff.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(staff.email, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
          // Actions: Activer/Suspendre
          TextButton.icon(
            icon: Icon(isSuspended ? Icons.play_arrow : Icons.pause, color: isSuspended ? Colors.green : Colors.orange),
            label: Text(isSuspended ? "ACTIVER" : "SUSPENDRE", style: TextStyle(color: isSuspended ? Colors.green : Colors.orange, fontSize: 12)),
            onPressed: () async {
              if (isSuspended) {
                await client.admin.activerUtilisateur(staff.id!);
              } else {
                await client.admin.suspendreUtilisateur(staff.id!);
              }
              ref.invalidate(staffTangerProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, ref, staff),
          ),
        ],
      ),
    );
  }

  void _showAddStaffDialog(BuildContext context, WidgetRef ref) {
    final nomCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("AJOUTER UN STAFF SCANNER", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nom complet")),
            TextField(controller: emailCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () async {
              if (nomCtrl.text.isEmpty || emailCtrl.text.isEmpty) return;
              await client.admin.ajouterStaff(nomCtrl.text, emailCtrl.text);
              ref.invalidate(staffTangerProvider);
              Navigator.pop(context);
            },
            child: const Text("CRÉER COMPTE", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Utilisateur staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Supprimer l'accès ?"),
        content: Text("Voulez-vous vraiment supprimer '${staff.nom}' de l'équipe de Tanger ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("NON")),
          TextButton(
            onPressed: () async {
              await client.admin.supprimerUtilisateur(staff.id!);
              ref.invalidate(staffTangerProvider);
              Navigator.pop(context);
            },
            child: const Text("OUI, SUPPRIMER", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

// ─── PROVIDER À AJOUTER DANS VOTRE admin_provider.dart ───
// final staffTangerProvider = FutureProvider<List<Utilisateur>>((ref) async {
//   return await client.admin.getStaffTanger();
// });