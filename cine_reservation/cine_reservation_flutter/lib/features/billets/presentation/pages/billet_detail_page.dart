import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../../../core/theme/app_theme.dart';

class BilletDetailPage extends StatelessWidget {
  final Billet billet;
  const BilletDetailPage({super.key, required this.billet});

  @override
  Widget build(BuildContext context) {
    final valide = billet.estValide == true;
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Billet #${billet.id}',
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // QR Code simulé
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: valide
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.qr_code_2, size: 140, color: Colors.black87),
              if (billet.qrCode != null)
                Text(billet.qrCode!,
                    style: const TextStyle(fontSize: 9, color: Colors.black54)),
            ])
                : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.cancel, size: 80, color: Colors.red),
              Text('BILLET UTILISE',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: valide
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              valide ? 'BILLET VALIDE' : 'BILLET UTILISE',
              style: TextStyle(
                  color: valide ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(children: [
              _ligne('Billet N°', '#${billet.id}'),
              _ligne('Type', (billet.typeBillet ?? 'STANDARD').toUpperCase()),
              _ligne('Date emission', dateFmt.format(billet.dateEmission.toLocal())),
              if (billet.dateValidation != null)
                _ligne('Date validation',
                    dateFmt.format(billet.dateValidation!.toLocal())),
              if (billet.siegeId != null) _ligne('Siege', '#${billet.siegeId}'),
              _ligne('QR Code', billet.qrCode ?? 'N/A'),
            ]),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('RETOUR'),
          ),
        ]),
      ),
    );
  }

  Widget _ligne(String label, String valeur) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label,
          style: const TextStyle(color: Colors.white54, fontSize: 13)),
      Flexible(
        child: Text(valeur,
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ),
    ]),
  );
}