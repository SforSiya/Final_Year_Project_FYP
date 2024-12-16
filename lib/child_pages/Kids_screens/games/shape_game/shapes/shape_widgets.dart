import 'package:flutter/material.dart';
import 'dart:math';

// Functions to draw shapes
Widget drawRectangle() {
  return Container(
    width: 100,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

Widget drawCircle() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.amber,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)],
    ),
  );
}

Widget drawSquare() {
  return Container(
    width: 100,
    height: 100,
    color: Colors.blueAccent,
  );
}

Widget drawTriangle() {
  return CustomPaint(
    size: Size(100, 100),
    painter: TrianglePainter(),
  );
}

Widget drawPentagon() {
  return CustomPaint(
    size: Size(100, 100),
    painter: PentagonPainter(),
  );
}

Widget drawQuadrilateral() {
  return CustomPaint(
    size: Size(100, 100),
    painter: QuadrilateralPainter(),
  );
}

// Custom painter for triangle
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.greenAccent;
    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for pentagon
class PentagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.pinkAccent;
    Path path = Path();
    double angle = (pi * 2) / 5;
    double radius = size.width / 2;
    for (int i = 0; i < 5; i++) {
      double x = radius + radius * cos(i * angle);
      double y = radius + radius * sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for quadrilateral
class QuadrilateralPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.purpleAccent;
    Path path = Path()
      ..moveTo(size.width / 4, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 3 / 4, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
