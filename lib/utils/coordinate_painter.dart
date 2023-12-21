import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:master_diploma_vrp/model/point_variant.dart';
import 'dart:math' as math;

import 'package:master_diploma_vrp/aco/tour.dart';

class CoordinatePainter extends CustomPainter {
  final List<PointVariant> points;
  final int zoomX;
  final int zoomY;
  List<Tour>? answer;

  CoordinatePainter(
      {super.repaint,
      required this.points,
      required this.zoomX,
      required this.zoomY,
      required this.answer});

  @override
  void paint(Canvas canvas, Size size) {
    _drawAxis(canvas, size);
    final List<Offset> offsets = [];
    for (PointVariant point in points) {
      double dx = point.position[0] * zoomX;
      double dy = size.height - (point.position[1] * zoomY);
      offsets.add(Offset(dx, dy));
      // Draw legend
      final textSpan = TextSpan(
        text: "#${point.number} (${point.position[0]}; ${point.position[1]})",
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
    if (answer != null) {
      _drawLines(canvas, size);
    }
    _drawPoints(canvas, offsets);
  }

  void _drawAxis(Canvas canvas, Size size) {
    // Draw x-axis
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), Paint());
    // Draw y-axis
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), Paint());
  }

  void _drawPoints(Canvas canvas, List<Offset> offsets) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    final depotPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0;
    for (var point in offsets) {
      canvas.drawPoints(PointMode.points, [point],
          offsets.indexOf(point) == 0 ? depotPaint : paint);
    }
  }

  void _drawLines(Canvas canvas, Size size) {
    if (answer?.isNotEmpty == true) {
      for (List<int> route in answer!.first.route) {
        final paint = Paint()
          ..color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0)
          ..strokeWidth = 4;
        if (route.length > 1) {
          for (int i = 0; i < route.length - 1; i++) {
            final p1 = Offset(points[route[i]].position[0] * zoomX,
                size.height - (points[route[i]].position[1] * zoomY));
            final p2 = Offset(points[route[i + 1]].position[0] * zoomX,
                size.height - (points[route[i + 1]].position[1] * zoomY));
            canvas.drawLine(p1, p2, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
