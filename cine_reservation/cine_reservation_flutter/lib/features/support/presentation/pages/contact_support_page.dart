import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/support_provider.dart';
import '../../../admin/presentation/providers/admin_provider.dart';

class ContactSupportPage extends ConsumerStatefulWidget {
  const ContactSupportPage({super.key});

  @override
  ConsumerState<ContactSupportPage> createState() =>
      _ContactSupportPageState();
}

class _ContactSupportPageState extends ConsumerState<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _sujetController = TextEditingController();
  final _messageController = TextEditingController();
  int? _selectedCinemaId;

  @override
  void dispose() {
    _sujetController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mesDemandes = ref.watch(mesDemandesProvider);
    final envoiState = ref.watch(supportActionProvider);
    final cinemasAsync = ref.watch(allCinemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Aide & Support",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            tooltip: "Actualiser",
            onPressed: () {
              ref.invalidate(mesDemandesProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Demandes actualisées"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section formulaire ────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.support_agent_rounded,
                              color: AppColors.accent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Nouvelle demande",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Sélecteur cinéma ─────────────────────────
                    const Text(
                      "CINÉMA CONCERNÉ",
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    cinemasAsync.when(
                      loading: () => const LinearProgressIndicator(
                          color: AppColors.accent),
                      error: (e, _) => Text("Erreur: $e",
                          style: const TextStyle(color: Colors.redAccent)),
                      data: (cinemas) => DropdownButtonFormField<int>(
                        value: _selectedCinemaId,
                        dropdownColor: const Color(0xFF1A1A1A),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Sélectionnez votre cinéma",
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.3)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.accent)),
                          prefixIcon: const Icon(Icons.business_rounded,
                              color: AppColors.accent, size: 18),
                        ),
                        items: [
                          // Option super admin
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text("Support général (Super Admin)"),
                          ),
                          ...cinemas.map((c) => DropdownMenuItem<int>(
                            value: c.id,
                            child: Text(c.nom),
                          )),
                        ],
                        onChanged: (val) =>
                            setState(() => _selectedCinemaId = val),
                        validator: (_) => null, // optionnel
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Sujet ────────────────────────────────────
                    const Text(
                      "SUJET",
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _sujetController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Ex: Problème de réservation",
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.accent)),
                        prefixIcon: const Icon(Icons.subject_rounded,
                            color: AppColors.accent, size: 18),
                      ),
                      validator: (v) =>
                      v == null || v.isEmpty ? "Champ requis" : null,
                    ),

                    const SizedBox(height: 16),

                    // ── Message ──────────────────────────────────
                    const Text(
                      "VOTRE MESSAGE",
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Décrivez votre problème en détail...",
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.accent)),
                      ),
                      validator: (v) =>
                      v == null || v.isEmpty ? "Champ requis" : null,
                    ),

                    const SizedBox(height: 20),

                    // ── Bouton envoyer ───────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                        envoiState.isLoading ? null : _envoyer,
                        icon: envoiState.isLoading
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black),
                        )
                            : const Icon(Icons.send_rounded, size: 16),
                        label: Text(
                          envoiState.isLoading
                              ? "Envoi en cours..."
                              : "ENVOYER LA DEMANDE",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.black,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                    // Info cinéma sélectionné
                    if (_selectedCinemaId == null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.white.withOpacity(0.3),
                              size: 14),
                          const SizedBox(width: 6),
                          Text(
                            "Sans cinéma sélectionné → envoyé au Super Admin",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Mes demandes précédentes ──────────────────────────
            const Text(
              "MES DEMANDES PRÉCÉDENTES",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            mesDemandes.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
              error: (e, _) => Text(
                "Erreur: $e",
                style: const TextStyle(color: Colors.redAccent),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        "Aucune demande pour l'instant.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final d = list[index];
                    final isClosed = d.statut == 'traité';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isClosed
                              ? Colors.green.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                        ),
                      ),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: Icon(
                            isClosed
                                ? Icons.check_circle_rounded
                                : Icons.pending_rounded,
                            color:
                            isClosed ? Colors.green : Colors.orange,
                            size: 20,
                          ),
                          title: Text(
                            d.sujet,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          subtitle: Text(
                            isClosed ? "Traité ✓" : "En attente de réponse",
                            style: TextStyle(
                              color: isClosed
                                  ? Colors.green
                                  : Colors.orange,
                              fontSize: 11,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Divider(color: Colors.white10),
                                  const SizedBox(height: 8),
                                  Text(
                                    d.message,
                                    style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 13),
                                  ),
                                  if (d.reponse != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.green
                                            .withOpacity(0.05),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.green
                                                .withOpacity(0.2)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Réponse :",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 11),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            d.reponse!,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
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
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Envoi ─────────────────────────────────────────────────────────────────
  void _envoyer() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(supportActionProvider.notifier).envoyerMessage(
      _sujetController.text,
      _messageController.text,
      cinemaId: _selectedCinemaId,
    );

    _sujetController.clear();
    _messageController.clear();
    setState(() => _selectedCinemaId = null);

    ref.invalidate(mesDemandesProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Demande envoyée avec succès !"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}