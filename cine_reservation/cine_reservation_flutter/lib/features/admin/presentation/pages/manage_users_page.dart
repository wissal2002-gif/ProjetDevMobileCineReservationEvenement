import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';import '../providers/admin_provider.dart';
import '../../../../core/theme/app_theme.dart';

class ManageUsersPage extends ConsumerWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUtilisateursProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("UTILISATEURS & RÔLES")),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.nom, style: const TextStyle(color: Colors.white)),
              subtitle: Text("${user.role} - Cinéma ID: ${user.cinemaId ?? 'Aucun'}",
                  style: const TextStyle(color: Colors.white54)),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: AppColors.accent),
                onPressed: () => _showEditUserDialog(context, ref, user),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, WidgetRef ref, Utilisateur user) {
    // 1. Liste des rôles autorisés (doit correspondre EXACTEMENT aux items du dropdown)
    const allowedRoles = ['client', 'admin_local', 'super_admin', 'resp_evenements', 'staff'];

    // 2. Initialisation sécurisée : si le rôle du user n'est pas dans la liste, on met 'client'
    String selectedRole = (user.role != null && allowedRoles.contains(user.role))
        ? user.role!
        : 'client';

    int? selectedCinemaId = user.cinemaId;
    final cinemasAsync = ref.watch(allCinemasProvider);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: Text("Modifier ${user.nom}", style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Choix du Rôle ---
              DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: AppColors.cardBg,
                style: const TextStyle(color: Colors.white),
                items: allowedRoles.map((r) =>
                    DropdownMenuItem(
                        value: r,
                        child: Text(r, style: const TextStyle(color: Colors.white))
                    )
                ).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedRole = v!;
                    // Si on change de rôle et que ce n'est plus admin_local, on reset le cinemaId
                    if (selectedRole != 'admin_local') {
                      selectedCinemaId = null;
                    }
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Rôle",
                  labelStyle: TextStyle(color: AppColors.accent),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                ),
              ),

              const SizedBox(height: 20),

              // --- Choix du Cinéma (uniquement si admin_local) ---
              if (selectedRole == 'admin_local')
                cinemasAsync.when(
                  data: (list) => DropdownButtonFormField<int>(
                    value: selectedCinemaId,
                    dropdownColor: AppColors.cardBg,
                    style: const TextStyle(color: Colors.white),
                    hint: const Text("Affecter à un Cinéma", style: TextStyle(color: Colors.white54, fontSize: 14)),
                    items: list.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.nom, style: const TextStyle(color: Colors.white))
                    )).toList(),
                    onChanged: (id) => setState(() => selectedCinemaId = id),
                    decoration: const InputDecoration(
                      labelText: "Cinéma affecté",
                      labelStyle: TextStyle(color: AppColors.accent),
                    ),
                  ),
                  loading: () => const LinearProgressIndicator(color: AppColors.accent),
                  error: (_, __) => const Text("Erreur de chargement des cinémas", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("ANNULER", style: TextStyle(color: Colors.white54))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              onPressed: () async {
                // Mise à jour de l'objet utilisateur avant envoi au serveur
                user.role = selectedRole;
                user.cinemaId = (selectedRole == 'admin_local') ? selectedCinemaId : null;

                try {
                  await client.admin.modifierUtilisateur(user);
                  ref.invalidate(allUtilisateursProvider);
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Utilisateur mis à jour !"), backgroundColor: Colors.green)
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.redAccent)
                  );
                }
              },
              child: const Text("ENREGISTRER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }}