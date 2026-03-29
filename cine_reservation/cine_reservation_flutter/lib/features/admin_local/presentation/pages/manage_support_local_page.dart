import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/providers/admin_provider.dart';
import '../widgets/local_admin_sidebar.dart';
import 'package:intl/intl.dart';

class ManageSupportLocalPage extends ConsumerWidget {
  const ManageSupportLocalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final admin = ref.watch(adminProfileProvider).value;
    final supportAsync = ref.watch(allDemandesSupportProvider);
    final usersAsync = ref.watch(allUtilisateursProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (!isMobile) const LocalAdminSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SUPPORT CLIENT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 20 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            admin?.nomCinema ?? "Cinéma",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: AppColors.accent, size: 26),
                        tooltip: "Actualiser",
                        onPressed: () {
                          ref.invalidate(allDemandesSupportProvider);
                          ref.invalidate(allUtilisateursProvider);
                        },
                      ),
                    ],
                  ),
                ),

                // ── Contenu ──────────────────────────────────────────
                Expanded(
                  child: supportAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.accent),
                    ),
                    error: (e, _) => Center(
                      child: Text("Erreur: $e",
                          style:
                          const TextStyle(color: Colors.redAccent)),
                    ),
                    data: (demandes) => usersAsync.when(
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.accent)),
                      error: (e, _) => Center(
                          child: Text("Erreur utilisateurs: $e",
                              style: const TextStyle(
                                  color: Colors.redAccent))),
                      data: (users) {
                        // Filtrer par cinéma de l'admin connecté
                        final cinemaId = admin?.cinemaId;
                        final local = demandes
                            .where((d) => d.cinemaId == cinemaId)
                            .toList();

                        if (local.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.support_agent_outlined,
                                    size: 64,
                                    color: Colors.white
                                        .withOpacity(0.1)),
                                const SizedBox(height: 16),
                                Text(
                                  "Aucune demande de support\npour votre cinéma.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                    Colors.white.withOpacity(0.3),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Stats rapides
                        final ouvertes = local
                            .where((d) => d.statut == 'ouvert')
                            .length;
                        final traitees = local
                            .where((d) => d.statut == 'traité')
                            .length;

                        return Column(
                          children: [
                            // Stats
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 16 : 40),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _statCard(
                                      "${local.length}",
                                      "TOTAL",
                                      Icons.inbox_rounded,
                                      Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _statCard(
                                      "$ouvertes",
                                      "EN ATTENTE",
                                      Icons.pending_rounded,
                                      Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _statCard(
                                      "$traitees",
                                      "TRAITÉS",
                                      Icons.check_circle_rounded,
                                      Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Liste
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                    isMobile ? 16 : 40),
                                itemCount: local.length,
                                itemBuilder: (context, index) {
                                  final demande = local[index];
                                  final user =
                                  users.firstWhere(
                                        (u) =>
                                    u.id ==
                                        demande.utilisateurId,
                                    orElse: () => Utilisateur(
                                        nom: "Client",
                                        email: ""),
                                  );
                                  return _buildDemandeCard(
                                      context, ref, demande, user);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Demande ──────────────────────────────────────────────────────────
  Widget _buildDemandeCard(BuildContext context, WidgetRef ref,
      DemandeSupport demande, Utilisateur user) {
    final isClosed = demande.statut == 'traité';
    final date = demande.createdAt ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isClosed
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isClosed
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isClosed
                  ? Icons.check_circle_rounded
                  : Icons.pending_rounded,
              color: isClosed ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          title: Text(
            demande.sujet,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                // Avatar client
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.nom.isNotEmpty
                          ? user.nom[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "${user.nom} • ${DateFormat('dd/MM/yyyy HH:mm').format(date)}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isClosed
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isClosed ? "TRAITÉ" : "EN ATTENTE",
              style: TextStyle(
                color: isClosed ? Colors.green : Colors.orange,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),

                  // Message client
                  const Text(
                    "MESSAGE DU CLIENT",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Text(
                      demande.message,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Réponse ou bouton
                  if (demande.reponse != null) ...[
                    const Text(
                      "VOTRE RÉPONSE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Text(
                        demande.reponse!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showReplyDialog(
                            context, ref, demande),
                        icon: const Icon(Icons.reply_rounded,
                            size: 16),
                        label: const Text("RÉPONDRE AU CLIENT"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog Réponse ────────────────────────────────────────────────────────
  void _showReplyDialog(BuildContext context, WidgetRef ref,
      DemandeSupport demande) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "RÉPONDRE AU CLIENT",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sujet : ${demande.sujet}",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4), fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Saisissez votre réponse...",
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: AppColors.accent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ANNULER",
                style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (ctrl.text.isEmpty) return;
              await client.admin
                  .repondreDemande(demande.id!, ctrl.text);
              ref.invalidate(allDemandesSupportProvider);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text("Réponse envoyée !"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text("ENVOYER",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Stat Card ─────────────────────────────────────────────────────────────
  Widget _statCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}