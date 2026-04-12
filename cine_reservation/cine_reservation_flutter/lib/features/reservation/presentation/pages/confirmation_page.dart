import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cine_reservation_client/cine_reservation_client.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/reservation_provider.dart';
import '../../../programmation/presentation/providers/avis_provider.dart';

class ConfirmationPage extends ConsumerStatefulWidget {
  final Reservation reservation;
  final Paiement paiement;
  final List<Billet> billets;
  final String filmTitre;
  final Seance? seance;
  final Evenement? evenement;
  final List<SiegeSelectionne> sieges;

  const ConfirmationPage({
    super.key,
    required this.reservation,
    required this.paiement,
    required this.billets,
    required this.filmTitre,
    this.seance,
    this.evenement,
    required this.sieges,
  });

  @override
  ConsumerState<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends ConsumerState<ConfirmationPage> {
  @override
  void initState() {
    super.initState();
    // Après confirmation de réservation, invalider peutNoterProvider
    // pour que la notation soit disponible en temps réel sans rechargement.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Incrémente le compteur global → tous les peutNoterProvider actifs
      // se rafraîchissent automatiquement.
      ref.read(peutNoterRefreshProvider.notifier).state++;

      // Invalider aussi les providers spécifiques au film si séance connue
      if (widget.seance?.filmId != null) {
        final filmId = widget.seance!.filmId;
        ref.invalidate(peutNoterProvider(filmId));
        ref.invalidate(monAvisProvider(filmId));
        ref.invalidate(statsFilmProvider(filmId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: Colors.green, size: 56),
            ),
            const SizedBox(height: 20),
            const Text('RÉSERVATION CONFIRMÉE !',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(widget.filmTitre,
                style:
                const TextStyle(color: AppColors.accent, fontSize: 15)),
            const SizedBox(height: 12),

            if (widget.sieges.isNotEmpty) ...[
              _buildSiegesResume(),
              const SizedBox(height: 20),
            ],

            if (widget.billets.isNotEmpty) ...[
              ...widget.billets.map((b) => _buildBilletCard(context, b)),
              const SizedBox(height: 20),
            ],

            _buildActionButtons(context),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _buildSiegesResume() {
    final Map<String, List<SiegeSelectionne>> siegesParTarif = {};
    for (final siege in widget.sieges) {
      siegesParTarif.putIfAbsent(siege.typeBillet, () => []).add(siege);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VOS SIÈGES',
              style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: siegesParTarif.entries.map((entry) {
              String label;
              Color color;
              switch (entry.key) {
                case 'vip':
                  label = 'VIP';
                  color = Colors.purple;
                  break;
                case 'enfant':
                  label = 'Enfant';
                  color = Colors.green;
                  break;
                case 'senior':
                  label = 'Senior';
                  color = Colors.orange;
                  break;
                case 'reduit':
                  label = 'Réduit';
                  color = Colors.blue;
                  break;
                default:
                  label = 'Normal';
                  color = AppColors.accent;
              }
              final sieges = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_seat, color: color, size: 14),
                        const SizedBox(width: 4),
                        Text(label,
                            style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: sieges
                          .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          s.siege.numero,
                          style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBilletCard(BuildContext context, Billet b) {
    final dateFmt = DateFormat('dd/MM/yyyy');
    final timeFmt = DateFormat('HH:mm');
    final dateSeance =
        widget.seance?.dateHeure ?? widget.reservation.dateReservation;

    final siege = widget.sieges.isNotEmpty
        ? widget.sieges.firstWhere(
          (s) => s.siege.id == b.siegeId,
      orElse: () => widget.sieges.first,
    )
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: const Color(0xFF1A1410),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('CinéEvent',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 1)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            b.estValide == true ? 'VALIDE' : 'UTILISÉ',
                            style: TextStyle(
                              color: b.estValide == true
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Text(widget.filmTitre,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 16),
                      Row(children: [
                        _infoChip(Icons.calendar_today_outlined,
                            dateFmt.format(dateSeance.toLocal())),
                        const SizedBox(width: 12),
                        _infoChip(Icons.access_time,
                            timeFmt.format(dateSeance.toLocal())),
                      ]),
                      const SizedBox(height: 10),
                      if (widget.seance != null)
                        _infoChip(Icons.movie_outlined,
                            widget.seance!.typeProjection ?? '2D'),
                      const SizedBox(height: 10),
                      if (siege != null)
                        _infoChip(
                            Icons.event_seat, 'Siège ${siege.siege.numero}'),
                      const SizedBox(height: 16),
                      Row(children: [
                        const Text('Réf: ',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 11)),
                        Text('#${b.id ?? widget.reservation.id}',
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      ]),
                    ],
                  ),
                ),
              ),
              _buildDentele(),
              Container(
                width: 110,
                color: const Color(0xFFF5E6C8),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _buildQRSimule(b.qrCode ?? '${b.id}'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      b.qrCode?.substring(0, 12) ?? 'QR-${b.id}',
                      style: const TextStyle(
                          color: Color(0xFF4A3728),
                          fontSize: 8,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text('ADMIT ONE',
                        style: TextStyle(
                            color: Color(0xFF4A3728),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.accent, size: 13),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ]);
  }

  Widget _buildDentele() {
    return SizedBox(
        width: 16, child: CustomPaint(painter: _DentelePainter()));
  }

  Widget _buildQRSimule(String data) {
    return CustomPaint(painter: _QRPainter(data));
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _telechargerPDF(context),
          icon: const Icon(Icons.download, size: 20),
          label: const Text('TÉLÉCHARGER LE BILLET PDF',
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => context.go('/mes-billets'),
          icon: const Icon(Icons.confirmation_number_outlined, size: 18),
          label: const Text('VOIR MES BILLETS',
              style: TextStyle(fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accent,
            side: const BorderSide(color: AppColors.accent),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.home_outlined, size: 18),
          label: const Text("RETOUR À L'ACCUEIL"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white54,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ]);
  }

  Future<void> _telechargerPDF(BuildContext context) async {
    try {
      final pdf = await _genererPDF();
      await Printing.sharePdf(
        bytes: pdf,
        filename: 'billet_cineevent_${widget.reservation.id}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur génération PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<Uint8List> _genererPDF() async {
    final pdf = pw.Document();
    final dateFmt = DateFormat('dd/MM/yyyy');
    final timeFmt = DateFormat('HH:mm');
    final dateSeance =
        widget.seance?.dateHeure ?? widget.reservation.dateReservation;

    final accentColor = PdfColor.fromHex('#8B7355');
    final darkBg = PdfColor.fromHex('#1A1410');
    final beigeColor = PdfColor.fromHex('#F5E6C8');

    for (var i = 0; i < widget.billets.length; i++) {
      final billet = widget.billets[i];
      final siege = i < widget.sieges.length ? widget.sieges[i] : null;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(40),
          build: (ctx) => pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius:
              const pw.BorderRadius.all(pw.Radius.circular(12)),
              border: pw.Border.all(color: accentColor, width: 2),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                      color: darkBg,
                      borderRadius: const pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(10),
                        bottomLeft: pw.Radius.circular(10),
                      ),
                    ),
                    padding: const pw.EdgeInsets.all(30),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment:
                          pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: pw.BoxDecoration(
                                color: accentColor,
                                borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(6)),
                              ),
                              child: pw.Text('CinéEvent',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ),
                            pw.Text('BILLET NUMÉRIQUE',
                                style: const pw.TextStyle(
                                    color: PdfColors.grey, fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(height: 24),
                        pw.Text(widget.filmTitre,
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 24,
                            )),
                        pw.SizedBox(height: 20),
                        pw.Row(children: [
                          _pdfInfoBox(ctx, 'DATE',
                              dateFmt.format(dateSeance.toLocal()),
                              accentColor),
                          pw.SizedBox(width: 16),
                          _pdfInfoBox(ctx, 'HEURE',
                              timeFmt.format(dateSeance.toLocal()),
                              accentColor),
                          if (widget.seance != null) ...[
                            pw.SizedBox(width: 16),
                            _pdfInfoBox(
                                ctx,
                                'FORMAT',
                                widget.seance!.typeProjection ?? '2D',
                                accentColor),
                          ],
                        ]),
                        pw.SizedBox(height: 16),
                        if (siege != null)
                          _pdfInfoBox(
                              ctx, 'SIÈGE', siege.siege.numero, accentColor),
                        pw.SizedBox(height: 16),
                        pw.Divider(color: PdfColors.grey800),
                        pw.SizedBox(height: 12),
                        pw.Row(
                          mainAxisAlignment:
                          pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                              crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('RÉFÉRENCE',
                                    style: const pw.TextStyle(
                                        color: PdfColors.grey, fontSize: 9)),
                                pw.Text(
                                    '#${billet.id ?? widget.reservation.id}',
                                    style: pw.TextStyle(
                                        color: accentColor,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                            pw.Column(
                              crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('MONTANT',
                                    style: const pw.TextStyle(
                                        color: PdfColors.grey, fontSize: 9)),
                                pw.Text(
                                    '${widget.paiement.montant.toStringAsFixed(2)} MAD',
                                    style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                            pw.Column(
                              crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('PAIEMENT',
                                    style: const pw.TextStyle(
                                        color: PdfColors.grey, fontSize: 9)),
                                pw.Text(
                                    (widget.paiement.methode ?? 'carte')
                                        .toUpperCase(),
                                    style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                pw.Container(
                  width: 160,
                  decoration: pw.BoxDecoration(
                    color: beigeColor,
                    borderRadius: const pw.BorderRadius.only(
                      topRight: pw.Radius.circular(10),
                      bottomRight: pw.Radius.circular(10),
                    ),
                  ),
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: billet.qrCode ??
                            'CINEEVENT-${widget.reservation.id}-${billet.id}',
                        width: 100,
                        height: 100,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        siege != null ? 'Siège ${siege.siege.numero}' : '',
                        style: pw.TextStyle(
                            color: PdfColor.fromHex('#4A3728'),
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text('ADMIT ONE',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#4A3728'),
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return pdf.save();
  }

  pw.Widget _pdfInfoBox(
      pw.Context ctx, String label, String value, PdfColor accent) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(color: accent, fontSize: 9)),
        pw.SizedBox(height: 2),
        pw.Text(value,
            style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 13)),
      ],
    );
  }
}

class _DentelePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLeft = Paint()..color = const Color(0xFF1A1410);
    final paintRight = Paint()..color = const Color(0xFFF5E6C8);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width / 2, size.height), paintLeft);
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height),
        paintRight);

    final paint = Paint()..color = const Color(0xFF0D0A08);
    const r = 6.0;
    double y = r;
    while (y < size.height) {
      canvas.drawCircle(Offset(size.width / 2, y), r, paint);
      y += r * 3;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _QRPainter extends CustomPainter {
  final String data;
  _QRPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1410);
    final cellSize = size.width / 10;
    final hash = data.hashCode.abs();

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if ((hash >> (i * 10 + j)) & 1 == 1 ||
            i < 3 && j < 3 ||
            i < 3 && j > 6 ||
            i > 6 && j < 3) {
          canvas.drawRect(
            Rect.fromLTWH(j * cellSize + 1, i * cellSize + 1,
                cellSize - 2, cellSize - 2),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}