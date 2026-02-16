import 'package:flutter/material.dart';

class SinergoLogo extends StatelessWidget {
  final double size;
  final Color color;

  const SinergoLogo({
    super.key,
    this.size = 100,
    this.color = const Color(0xFF6366F1), // Indigo Primary
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SinergoPainter(color: color),
      ),
    );
  }
}

class _SinergoPainter extends CustomPainter {
  final Color color;

  _SinergoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    // Gambar Huruf "S" Abstrak (Sinergi)
    final Path path = Path();
    // Titik atas ke tengah
    path.moveTo(w * 0.8, h * 0.2);
    path.quadraticBezierTo(
      w * 0.2,
      h * 0.2,
      cx,
      cy,
    );
    // Tengah ke bawah
    path.quadraticBezierTo(
      w * 0.8,
      h * 0.8,
      w * 0.2,
      h * 0.8,
    );
    canvas.drawPath(path, paint);

    // Gambar 3 Titik Koneksi (Simbol IoT/Network)
    // Titik Awal
    canvas.drawCircle(Offset(w * 0.8, h * 0.2), w * 0.12, dotPaint);
    // Titik Tengah (Fusion)
    canvas.drawCircle(Offset(cx, cy), w * 0.12, dotPaint);
    // Titik Akhir
    canvas.drawCircle(Offset(w * 0.2, h * 0.8), w * 0.12, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
