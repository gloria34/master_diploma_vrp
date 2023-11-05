import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:master_diploma_vrp/model/point.dart';

class CoordinatePainter extends CustomPainter {
  final List<Point> points;
  final int zoomX;
  final int zoomY;

  CoordinatePainter(
      {super.repaint,
      required this.points,
      required this.zoomX,
      required this.zoomY});

  @override
  void paint(Canvas canvas, Size size) {
    final List<Offset> offsets = [];
    for (Point point in points) {
      double dx = point.x * zoomX;
      double dy = size.height - (point.y * zoomY);
      // Draw x-axis
      canvas.drawLine(
          Offset(0, size.height), Offset(size.width, size.height), Paint());
      // Draw y-axis
      canvas.drawLine(const Offset(0, 0), Offset(0, size.height), Paint());
      offsets.add(Offset(dx, dy));
      // Draw legend
      final textSpan = TextSpan(
        text: "#${point.number} (${point.x}; ${point.y})",
        style: const TextStyle(fontSize: 16.0),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textX = dx - textPainter.width / 2;
      final textY = dy - textPainter.height - 5;
      textPainter.paint(canvas, Offset(textX, textY));
    }
    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    final depotPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (var point in offsets) {
      // Draw points
      canvas.drawPoints(PointMode.points, [point],
          offsets.indexOf(point) == 0 ? depotPaint : paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
