import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/casa_sidebar.dart';

// Provider spécifique pour Casa
final staffCasaProvider = FutureProvider<List<Utilisateur>>((ref) async {
  final all = await client.admin.getAllUtilisateurs();
  return all.where((u) => u.cinemaId == 2 && u.role == 'staff_scanner').toList();
});

class ManageStaffCasaPage extends ConsumerWidget {
  const ManageStaffCasaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffCasaProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A08),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fab_add_staff_casa",
        backgroundColor: Colors.amber,
        onPressed: () => _showAddStaffDialog(context, ref),
        label: const Text("AJOUTER STAFF (CASA)", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.person_add, color: Colors.black),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 280, child: CasaSidebar()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ÉQUIPE CASABLANCA - STAFF SCANNER", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Expanded(
                    child: staffAsync.when(
                      data: (staffList) {
                        if (staffList.isEmpty) return const Center(child: Text("Aucun staff à Casablanca.", style: TextStyle(color: Colors.white24)));
                        return ListView.builder(
                          itemCount: staffList.length,
                          itemBuilder: (context, index) => _buildStaffCard(context, ref, staffList[index]),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
                      error: (e, _) => Center(child: Text("Erreur: $e")),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.amber, child: Text(staff.nom[0].toUpperCase())),
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(staff.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(staff.email, style: const TextStyle(color: Colors.white54))])),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              await client.admin.supprimerUtilisateur(staff.id!);
              ref.invalidate(staffCasaProvider);
            },
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
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Nouveau Staff Casa", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: emailCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Note: Idéalement créer une méthode serveur générique. Ici on simule pour Casa ID 2.
              final u = Utilisateur(nom: nomCtrl.text, email: emailCtrl.text, role: 'staff_scanner', cinemaId: 2, statut: 'actif');
              await client.admin.activerUtilisateur(u.id ?? 0); // À adapter selon votre endpoint ajouterStaff
              ref.invalidate(staffCasaProvider);
              Navigator.pop(ctx);
            },
            child: const Text("CRÉER"),
          )
        ],
      ),
    );
  }
}
