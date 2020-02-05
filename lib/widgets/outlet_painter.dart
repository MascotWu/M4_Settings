import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutletPainter extends CustomPainter {
  // to prevent creating Paint Object frequently
  final p = Paint();

  OutletPainter() {
    p.color = Colors.blueAccent;
    p.strokeWidth = 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, size.height / 4), Offset(size.width, size.height / 4), p);
    canvas.drawLine(Offset(0, size.height / 4 * 3), Offset(size.width, size.height / 4 * 3), p);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
