import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/faq_provider.dart';
import '../../../../core/theme/app_theme.dart';

class FaqPage extends ConsumerWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Questions Fréquentes (FAQ)"),
        backgroundColor: Colors.transparent,
      ),
      body: faqsAsync.when(
        data: (faqs) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                iconColor: AppColors.accent,
                collapsedIconColor: Colors.white54,
                title: Text(faq.question,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(faq.reponse,
                        style: const TextStyle(color: Colors.white70, height: 1.5)),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Erreur : $e", style: TextStyle(color: Colors.white))),
      ),
    );
  }
}