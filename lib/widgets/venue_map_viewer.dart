import 'package:flutter/material.dart';

/// Denah venue yang bisa digeser dan diperbesar (InteractiveViewer).
class VenueMapViewer extends StatefulWidget {
  const VenueMapViewer({super.key});

  @override
  State<VenueMapViewer> createState() => _VenueMapViewerState();
}

class _VenueMapViewerState extends State<VenueMapViewer> {
  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Cubit untuk zoom, geser untuk berpindah',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: 'Reset zoom',
                icon: const Icon(Icons.center_focus_strong),
                onPressed: () => _controller.value = Matrix4.identity(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRect(
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 0.8,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(80),
              child: Center(
                child: FittedBox(
                  child: SizedBox(
                    width: 400,
                    height: 300,
                    child: CustomPaint(painter: _VenuePainter(cs)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VenuePainter extends CustomPainter {
  final ColorScheme cs;
  _VenuePainter(this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = cs.outline;

    void room(Rect r, Color c, String label, {double fontSize = 12}) {
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(8));
      fill.color = c;
      canvas.drawRRect(rr, fill);
      canvas.drawRRect(rr, stroke);
      _text(canvas, label, r.center, cs.onSurface, fontSize, r.width - 8);
    }

    // Lantai gedung
    room(const Rect.fromLTWH(5, 5, 390, 290), cs.surfaceContainerHighest, '');

    // Area atas
    room(const Rect.fromLTWH(20, 20, 90, 40), cs.tertiaryContainer, 'Registrasi');
    room(const Rect.fromLTWH(130, 20, 140, 40), cs.primaryContainer, 'PANGGUNG');
    room(const Rect.fromLTWH(290, 20, 90, 40), cs.tertiaryContainer, 'Booth Sponsor');

    // Area kursi
    room(const Rect.fromLTWH(30, 80, 160, 110), cs.secondaryContainer, 'Kursi Blok A');
    room(const Rect.fromLTWH(210, 80, 160, 110), cs.secondaryContainer, 'Kursi Blok B');

    // Pintu masuk
    _text(canvas, '▲ Pintu Masuk', const Offset(200, 203), cs.primary, 11, 120);

    // Ruang di bawah
    room(const Rect.fromLTWH(20, 220, 110, 65), cs.primaryContainer, 'Ruang\nWorkshop 1');
    room(const Rect.fromLTWH(145, 220, 110, 65), cs.primaryContainer, 'Ruang\nWorkshop 2');
    room(const Rect.fromLTWH(270, 220, 110, 65), cs.primaryContainer, 'IoT Lab');
  }

  void _text(Canvas canvas, String text, Offset center, Color color,
      double fontSize, double maxWidth) {
    if (text.isEmpty) return;
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _VenuePainter oldDelegate) =>
      oldDelegate.cs != cs;
}