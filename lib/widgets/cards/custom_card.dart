import 'package:flutter/material.dart';

class FolderShapePainter extends CustomPainter {
  final String title;
  final Color color;
  final TextStyle? textStyle;

  FolderShapePainter({
    required this.title,
    this.color = const Color.fromARGB(255, 234, 207, 172),
    this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Responsive scaling
    final double cornerRadius = size.width * 0.03;
    final double tabWidth = size.width * 0.55;
    final double tabHeight = 25;

    // Curve control distances (proportional)
    final double curve1 = size.width * 0.02;
    final double curve2 = size.width * 0.04;
    final double curve3 = size.width * 0.06;
    final double curve4 = size.width * 0.1;

    // Start from bottom-left
    path.moveTo(0, size.height - cornerRadius);
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

    // === Bottom Wavy Edge ===
    final double waveHeight = 8; // amplitude of the wave
    final double waveLength = size.width / 6; // number of waves (6 here)

    for (double x = cornerRadius;
        x < size.width - cornerRadius;
        x += waveLength) {
      path.quadraticBezierTo(
        x + waveLength / 4,
        size.height - waveHeight,
        x + waveLength / 2,
        size.height,
      );
      path.quadraticBezierTo(
        x + 3 * waveLength / 4,
        size.height + waveHeight,
        x + waveLength,
        size.height,
      );
    }

    // Bottom-right corner curve
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - cornerRadius);

    // Right edge
    path.lineTo(size.width, cornerRadius);
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);

    // Tab coordinates
    final double tabLeft = (size.width - tabWidth) / 2;
    final double tabRight = tabLeft + tabWidth;

    // Top-right to bulge
    path.lineTo(tabRight, 0);

    // Right bulge
    path.quadraticBezierTo(
        tabRight - curve1, 0, tabRight - curve2, -tabHeight * 0.5);
    path.quadraticBezierTo(
        tabRight - curve3, -tabHeight, tabRight - curve4, -tabHeight);

    // Top of bulge
    path.lineTo(tabLeft + curve4, -tabHeight);

    // Left bulge (mirror)
    path.quadraticBezierTo(
        tabLeft + curve3, -tabHeight, tabLeft + curve2, -tabHeight * 0.5);
    path.quadraticBezierTo(tabLeft + curve1, 0, tabLeft, 0);

    // Left edge
    path.lineTo(0, 0);

    path.close();

    // Shadow + fill
    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 4, true);
    canvas.drawPath(path, paint);

    // === Draw Title in Bulge ===
    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: textStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Center the text in the bulge
    final double textX = (size.width - textPainter.width) / 2;
    final double textY = -tabHeight / 1.4 - textPainter.height / 2;

    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant FolderShapePainter oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.color != color ||
        oldDelegate.textStyle != textStyle;
  }
}
