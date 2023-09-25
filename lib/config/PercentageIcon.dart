import 'dart:math' as math;
import 'package:flutter/material.dart';

class PercentageIcon extends StatelessWidget {
  final double percentage;
  final Color color;
  final double size;
  final TextStyle textStyle;

  PercentageIcon({
    required this.percentage,
    this.color = Colors.blue,
    this.size = 100,
    this.textStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _PercentageIconPainter(
        percentage: percentage,
        color: color,
        textStyle: textStyle,
      ),
    );
  }
}

class _PercentageIconPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final TextStyle textStyle;

  _PercentageIconPainter({
    required this.percentage,
    required this.color,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius / 5;
    canvas.drawCircle(center, radius, paint);
    final textPainter = TextPainter(
      text: TextSpan(text: '${percentage.toInt()}%', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final textCenter = Offset(
        center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);
    textPainter.paint(canvas, textCenter);
  }

  @override
  bool shouldRepaint(_PercentageIconPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.color != color ||
        oldDelegate.textStyle != textStyle;
  }
}
