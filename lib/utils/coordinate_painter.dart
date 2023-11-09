import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:master_diploma_vrp/model/answer.dart';
import 'package:master_diploma_vrp/model/best_route.dart';
import 'package:master_diploma_vrp/model/edge.dart';
import 'package:master_diploma_vrp/model/point.dart';
import 'dart:math' as math;

class CoordinatePainter extends CustomPainter {
  final List<Point> points;
  final int zoomX;
  final int zoomY;
  final Answer? answer;

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
    for (Point point in points) {
      double dx = point.x * zoomX;
      double dy = size.height - (point.y * zoomY);
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
    for (BestRoute route in answer!.bestRoutes) {
      final paint = Paint()
        ..color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0)
        ..strokeWidth = 4;
      for (Edge edge in route.route.visitedEdges) {
        final p1 = Offset(edge.startLocation.x * zoomX,
            size.height - (edge.startLocation.y * zoomY));
        final p2 = Offset(edge.endLocation.x * zoomX,
            size.height - (edge.endLocation.y * zoomY));
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
