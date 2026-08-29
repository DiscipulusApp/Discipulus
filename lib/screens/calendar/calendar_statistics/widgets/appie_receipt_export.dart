import 'dart:io';
import 'dart:ui' as ui;

import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/calendar/calendar_statistics/widgets/appie_payroll_card.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Serrated / Zigzag edge clipper for both top and bottom of receipt paper
class SerratedEdgeClipper extends CustomClipper<Path> {
  final double triangleWidth;
  final double triangleHeight;
  final bool clipTop;
  final bool clipBottom;

  const SerratedEdgeClipper({
    this.triangleWidth = 12.0,
    this.triangleHeight = 6.0,
    this.clipTop = true,
    this.clipBottom = true,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    // Top edge
    if (clipTop) {
      path.moveTo(0, triangleHeight);
      double x = 0;
      bool goDown = true;
      while (x < size.width) {
        x += triangleWidth / 2;
        final y = goDown ? 0.0 : triangleHeight;
        path.lineTo(x, y);
        goDown = !goDown;
      }
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
    }

    // Right edge
    path.lineTo(size.width, size.height - (clipBottom ? triangleHeight : 0));

    // Bottom edge
    if (clipBottom) {
      double x = size.width;
      bool goDown = true;
      while (x > 0) {
        x -= triangleWidth / 2;
        final y = goDown ? size.height : size.height - triangleHeight;
        path.lineTo(x, y);
        goDown = !goDown;
      }
    } else {
      path.lineTo(0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Discipulus logo vector painter 
/// 
/// This is all extracted from the SVG in the root repo, 
/// so if it looks like a bit of random string of numbers, 
/// that's because it is. It's the path data for the Discipulus logo.
class DiscipulusLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  DiscipulusLogoPainter({
    this.primaryColor = const Color(0xFF7447D1),
    this.secondaryColor = const Color(0xFF9370DB),
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24.0, size.height / 24.0);

    final paint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(1.67225, 17.5142)
      ..cubicTo(1.42775, 17.3442, 1.27966, 17.1122, 1.228, 16.818)
      ..cubicTo(1.17633, 16.5238, 1.22716, 16.2461, 1.3805, 15.9847)
      ..lineTo(5.1615, 9.92874)
      ..cubicTo(5.36866, 9.60558, 5.65866, 9.42949, 6.0315, 9.40049)
      ..cubicTo(6.40433, 9.37149, 6.72133, 9.49991, 6.9825, 9.78574)
      ..lineTo(8.8745, 11.9917)
      ..lineTo(11.8162, 7.19349)
      ..cubicTo(12.0276, 6.83699, 12.3457, 6.65674, 12.7705, 6.65274)
      ..cubicTo(13.1952, 6.64874, 13.5215, 6.81866, 13.7495, 7.16249)
      ..lineTo(14.7685, 8.70649)
      ..cubicTo(14.9638, 9.00983, 15.025, 9.30258, 14.952, 9.58474)
      ..cubicTo(14.879, 9.86708, 14.7302, 10.0868, 14.5055, 10.244)
      ..cubicTo(14.2808, 10.4013, 14.0283, 10.4784, 13.748, 10.4752)
      ..cubicTo(13.4678, 10.4722, 13.2142, 10.335, 12.987, 10.0635)
      ..lineTo(12.8537, 9.87324)
      ..lineTo(10.006, 14.5027)
      ..cubicTo(9.79867, 14.8259, 9.50542, 15.0052, 9.12625, 15.0405)
      ..cubicTo(8.74708, 15.0758, 8.42692, 14.9442, 8.16575, 14.6457)
      ..lineTo(6.268, 12.4397)
      ..lineTo(3.3075, 17.2032)
      ..cubicTo(3.13766, 17.4851, 2.89, 17.6582, 2.5645, 17.7225)
      ..cubicTo(2.23883, 17.7868, 1.94141, 17.7174, 1.67225, 17.5142)
      ..close()
      ..moveTo(17.288, 10.2282)
      ..cubicTo(17.0435, 10.0789, 16.8726, 9.86233, 16.7752, 9.57849)
      ..cubicTo(16.6779, 9.29466, 16.7329, 8.99316, 16.9402, 8.67399)
      ..lineTo(20.6982, 2.66674)
      ..cubicTo(20.8682, 2.39758, 21.1148, 2.22566, 21.438, 2.15099)
      ..cubicTo(21.7612, 2.07633, 22.0554, 2.14266, 22.3207, 2.34999)
      ..cubicTo(22.5652, 2.51999, 22.7155, 2.75108, 22.7715, 3.04324)
      ..cubicTo(22.8275, 3.33541, 22.7788, 3.61208, 22.6255, 3.87324)
      ..lineTo(18.8482, 9.86149)
      ..cubicTo(18.6411, 10.1807, 18.3904, 10.3589, 18.0962, 10.3962)
      ..cubicTo(17.8021, 10.4336, 17.5327, 10.3776, 17.288, 10.2282)
      ..close();

    canvas.drawPath(path1, paint1);

    final paint2 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final path2 = Path()
      ..moveTo(16.099, 20.6885)
      ..cubicTo(14.825, 20.6885, 13.7416, 20.2421, 12.8487, 19.3492)
      ..cubicTo(11.9557, 18.4562, 11.5092, 17.3728, 11.5092, 16.099)
      ..cubicTo(11.5092, 14.825, 11.9557, 13.7406, 12.8487, 12.8457)
      ..cubicTo(13.7416, 11.9507, 14.825, 11.5033, 16.099, 11.5033)
      ..cubicTo(17.3728, 11.5033, 18.4562, 11.9507, 19.3492, 12.8457)
      ..cubicTo(20.2421, 13.7406, 20.6885, 14.825, 20.6885, 16.099)
      ..cubicTo(20.6885, 16.5203, 20.6332, 16.9302, 20.5225, 17.3285)
      ..cubicTo(20.4118, 17.7268, 20.2478, 18.099, 20.0305, 18.445)
      ..lineTo(22.3647, 20.7675)
      ..cubicTo(22.5926, 20.9913, 22.7097, 21.2565, 22.716, 21.563)
      ..cubicTo(22.7223, 21.8695, 22.6116, 22.1368, 22.3837, 22.3648)
      ..cubicTo(22.1557, 22.5926, 21.8853, 22.7065, 21.5725, 22.7065)
      ..cubicTo(21.2597, 22.7065, 20.9893, 22.5926, 20.7615, 22.3648)
      ..lineTo(18.42, 20.0365)
      ..cubicTo(18.0867, 20.2538, 17.7218, 20.4168, 17.3255, 20.5255)
      ..cubicTo(16.9292, 20.6342, 16.5203, 20.6885, 16.099, 20.6885)
      ..close()
      ..moveTo(16.099, 18.4135)
      ..cubicTo(16.7472, 18.4135, 17.295, 18.1898, 17.7425, 17.7425)
      ..cubicTo(18.1898, 17.295, 18.4135, 16.7472, 18.4135, 16.099)
      ..cubicTo(18.4135, 15.4508, 18.1898, 14.902, 17.7425, 14.4525)
      ..cubicTo(17.295, 14.003, 16.7472, 13.7782, 16.099, 13.7782)
      ..cubicTo(15.4508, 13.7782, 14.902, 14.003, 14.4525, 14.4525)
      ..cubicTo(14.003, 14.902, 13.7782, 15.4508, 13.7782, 16.099)
      ..cubicTo(13.7782, 16.7472, 14.003, 17.295, 14.4525, 17.7425)
      ..cubicTo(14.902, 18.1898, 15.4508, 18.4135, 16.099, 18.4135)
      ..close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Receipt barcode
class BarcodeWidget extends StatelessWidget {
  const BarcodeWidget({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final barWidths = [
      3.0, 1.0, 2.0, 4.0, 1.0, 3.0, 2.0, 1.0, 4.0, 2.0, 1.0, 3.0, 1.0, 2.0,
      4.0, 2.0, 1.0, 3.0, 2.0, 4.0, 1.0, 2.0, 3.0, 1.0, 4.0, 2.0, 1.0, 3.0,
      2.0, 1.0, 4.0, 2.0, 3.0, 1.0, 2.0, 4.0, 1.0, 3.0, 2.0, 1.0, 3.0, 2.0
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < barWidths.length; i++) ...[
                Container(
                  width: barWidths[i],
                  color: Colors.black87,
                ),
                if (i < barWidths.length - 1)
                  SizedBox(width: (i % 3 == 0) ? 3.0 : 1.5),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            letterSpacing: 4,
            fontSize: 11,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Dashed horizontal line that spans 100% of the available width
class ReceiptDashedLine extends StatelessWidget {
  const ReceiptDashedLine({
    super.key,
    this.height = 1.2,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.color = Colors.black38,
    this.verticalPadding = 6.0,
  });

  final double height;
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

/// Double line (like =======) that spans 100% of the available width
class ReceiptDoubleLine extends StatelessWidget {
  const ReceiptDoubleLine({
    super.key,
    this.color = Colors.black54,
    this.verticalPadding = 6.0,
  });

  final Color color;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1.5, color: color),
          const SizedBox(height: 2),
          Container(height: 1.5, color: color),
        ],
      ),
    );
  }
}

class AppieReceiptCard extends StatelessWidget {
  const AppieReceiptCard({
    super.key,
    required this.payrolls,
    required this.grandTotalHours,
    required this.grandTotalEarnings,
    required this.profile,
    this.sourceName,
    this.isAnonymous = false,
    this.useDatesInsteadOfClasses = false,
    this.showFrikandelbroodjes = true,
  });

  final List<SchoolyearPayroll> payrolls;
  final double grandTotalHours;
  final double grandTotalEarnings;
  final Profile profile;
  final String? sourceName;
  final bool isAnonymous;
  final bool useDatesInsteadOfClasses;
  final bool showFrikandelbroodjes;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'nl_NL', symbol: '€', decimalDigits: 2);
    final numberFormatter = NumberFormat.decimalPattern('nl_NL');
    final totalFrikandelbroodjes = (grandTotalEarnings / 1.35).floor();

    final studentName = isAnonymous
        ? "MEDEWERKER #48291"
        : (profile.name.isNotEmpty ? profile.name.toUpperCase() : "LEERLING");

    final now = DateTime.now();
    final dateStr = DateFormat('dd-MM-yyyy HH:mm').format(now);

    return ClipPath(
      clipper: const SerratedEdgeClipper(
        triangleWidth: 14.0,
        triangleHeight: 7.0,
        clipTop: true,
        clipBottom: true,
      ),
      child: Container(
        width: 340,
        color: const Color(0xFFFAF9F6), // Warm off-white receipt paper
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                // I think leaving this in is a bit too much
                // CustomPaint(
                //   size: const Size(25, 25),
                //   painter: DiscipulusLogoPainter(
                //     primaryColor: const Color(0xFF7447D1),
                //     secondaryColor: const Color(0xFF9370DB),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A0E2), // Official Albert Heijn Blue
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "AH",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "ALBERT HEIJN B.V.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const Text(
              "VIRTUELE SALARISSPECIFICATIE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            if (sourceName != null && sourceName!.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                "BRON: ${sourceName!.toUpperCase()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ],
            const SizedBox(height: 6),

            // Metadata
            const ReceiptDashedLine(),
            _receiptRow("MEDEWERKER", studentName),
            _receiptRow(
                "FILIAAL",
                isAnonymous
                    ? "MIDDELBARE SCHOOL"
                    : Uri.parse(profile.account.value?.endPoint ?? "")
                        .host
                        .split(".")
                        .first
                        .toUpperCase()),
            if (sourceName != null && sourceName!.isNotEmpty)
              _receiptRow("AFDELING", sourceName!.toUpperCase()),
            _receiptRow("DATUM", dateStr),
            _receiptRow("FUNCTIE", "SCHOLIER / VAKKENVULLER"),
            const ReceiptDashedLine(),
            const SizedBox(height: 4),

            // Itemized schoolyears
            for (final p in payrolls) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      useDatesInsteadOfClasses
                          ? "${p.schoolyear.begin.year} - ${p.schoolyear.einde.year}"
                          : (p.schoolyear.groep.omschrijving?.toUpperCase() ??
                              "${p.schoolyear.begin.year} - ${p.schoolyear.einde.year}"),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${p.totalHours.round()} uur @ ~${currencyFormatter.format(p.averageHourlyWage)}/u",
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(p.totalEarnings),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 4),
            const ReceiptDoubleLine(),

            _receiptRow(
              "TOTAAL GEWERKT",
              "${grandTotalHours.round()} UUR",
              isBold: true,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "NETTO SALARIS",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  currencyFormatter.format(grandTotalEarnings),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xFF008000), // Receipt green / dark
                  ),
                ),
              ],
            ),

            if (showFrikandelbroodjes) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  children: [
                    const Text("🥐", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Koopkracht: ${numberFormatter.format(totalFrikandelbroodjes)} frikandelbroodjes",
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 10),
            const ReceiptDashedLine(),
            const SizedBox(height: 4),

            const BarcodeWidget(code: "8 710400 019284"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(14, 14),
                  painter: DiscipulusLogoPainter(
                    primaryColor: Colors.black54,
                    secondaryColor: Colors.black38,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "DISCIPULUS APP • discipulus.harrydekat.dev",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Onofficiële parodie berekend met Discipulus • Niet verbonden met AH",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 7.5,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black87 : Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class AppieReceiptExportDialog extends StatefulWidget {
  const AppieReceiptExportDialog({
    super.key,
    required this.payrolls,
    required this.grandTotalHours,
    required this.grandTotalEarnings,
    required this.profile,
    this.sourceName,
  });

  final List<SchoolyearPayroll> payrolls;
  final double grandTotalHours;
  final double grandTotalEarnings;
  final Profile profile;
  final String? sourceName;

  static Future<void> show(
    BuildContext context, {
    required List<SchoolyearPayroll> payrolls,
    required double grandTotalHours,
    required double grandTotalEarnings,
    required Profile profile,
    String? sourceName,
  }) {
    return showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => AppieReceiptExportDialog(
        payrolls: payrolls,
        grandTotalHours: grandTotalHours,
        grandTotalEarnings: grandTotalEarnings,
        profile: profile,
        sourceName: sourceName,
      ),
    );
  }

  @override
  State<AppieReceiptExportDialog> createState() =>
      _AppieReceiptExportDialogState();
}

class _AppieReceiptExportDialogState extends State<AppieReceiptExportDialog> {
  final GlobalKey _receiptKey = GlobalKey();
  bool _isSharing = false;

  bool _isAnonymous = false;
  bool _useDatesInsteadOfClasses = false;
  bool _showFrikandelbroodjes = true;

  Future<void> _shareReceipt() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      final boundary = _receiptKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Capture at 3x pixel ratio for crystal-clear thermal ticket image
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/appie_salarisstrook.png');
      await file.writeAsBytes(pngBytes);

      final currencyFormatter = NumberFormat.currency(
          locale: 'nl_NL', symbol: '€', decimalDigits: 2);
      final earningsStr =
          currencyFormatter.format(widget.grandTotalEarnings);
      final sourceText = widget.sourceName != null && widget.sourceName!.isNotEmpty
          ? ' voor ${widget.sourceName}'
          : ' voor school';

      await SharePlus.instance.share(ShareParams(
        files:
        [XFile(file.path)],
        text:
            'Mijn virtuele Albert Heijn salaris$sourceText is $earningsStr! 🛒💰 Berekend met Discipulus',
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delen mislukt: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog.fullscreen(
      backgroundColor: theme.colorScheme.surfaceContainer,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainer,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceContainer,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Albert Heijn Salarisstrook"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilledButton.icon(
                icon: _isSharing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.share_rounded),
                label: const Text("Deel loonstrook"),
                onPressed: _isSharing ? null : _shareReceipt,
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Center(
                  child: RepaintBoundary(
                    key: _receiptKey,
                    child: AppieReceiptCard(
                      payrolls: widget.payrolls,
                      grandTotalHours: widget.grandTotalHours,
                      grandTotalEarnings: widget.grandTotalEarnings,
                      profile: widget.profile,
                      sourceName: widget.sourceName,
                      isAnonymous: _isAnonymous,
                      useDatesInsteadOfClasses: _useDatesInsteadOfClasses,
                      showFrikandelbroodjes: _showFrikandelbroodjes,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        "Opties & Weergave",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    CustomCard(
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          SwitchListTile(
                            secondary: const Icon(Icons.visibility_off_outlined),
                            title: const Text("Anoniem maken"),
                            subtitle: const Text(
                                "Verbergt je naam en school op het bonnetje"),
                            value: _isAnonymous,
                            onChanged: (val) =>
                                setState(() => _isAnonymous = val),
                          ),
                          const Divider(height: 1, indent: 56),
                          SwitchListTile(
                            secondary:
                                const Icon(Icons.calendar_month_outlined),
                            title: const Text("Jaartallen i.p.v. klasnamen"),
                            subtitle: const Text(
                                "Toont schooljaren (bv. 2023 - 2024) in plaats van klascodes"),
                            value: _useDatesInsteadOfClasses,
                            onChanged: (val) => setState(
                                () => _useDatesInsteadOfClasses = val),
                          ),
                          const Divider(height: 1, indent: 56),
                          SwitchListTile(
                            secondary: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Text("🥐", style: TextStyle(fontSize: 20)),
                            ),
                            title: const Text("Frikandelbroodjes-koopkracht"),
                            subtitle: const Text(
                                "Toont de frikandelbroodjes-koopkracht op het bonnetje"),
                            value: _showFrikandelbroodjes,
                            onChanged: (val) => setState(
                                () => _showFrikandelbroodjes = val),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
