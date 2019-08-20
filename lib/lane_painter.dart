import 'dart:math';

import 'package:flutter/material.dart';

class OpticalParam {
  var cu = 640;
  var cv = 360;
  var fu = 1458;
  var fv = 1458;
  var height = 720;
  var width = 1280;
}

class LanePainter extends CustomPainter {
  LanePainter({this.point1, this.point2, this.point3, this.point4});

  OpticalParam opticalParam = OpticalParam();

  // to prevent creating Paint Object frequently
  final p = Paint();

  final sizeOfCross = 10;

  Offset point1;
  Offset point2;
  Offset point3;
  Offset point4;

  Offset vp;

  var yaw;
  var pitch;

  drawAnchor(Canvas canvas, Size size) {
    p.color = Colors.amber;
    p.style = PaintingStyle.fill;
    canvas.drawCircle(point1, 4, p);
    canvas.drawCircle(point2, 4, p);
    canvas.drawCircle(point3, 4, p);
    canvas.drawCircle(point4, 4, p);
  }

  drawLane(Canvas canvas, Size size) {
    drawAnchor(canvas, size);

    canvas.drawLine(
      point1,
      point2,
      p,
    );

    canvas.drawLine(
      point3,
      point4,
      p,
    );
  }

  drawCenterCross(Canvas canvas, Size size) {
    p.color = Colors.blueAccent;
    p.strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2 - sizeOfCross, size.height / 2),
      Offset(size.width / 2 + sizeOfCross, size.height / 2),
      p,
    );

    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - sizeOfCross),
      Offset(size.width / 2, size.height / 2 + sizeOfCross),
      p,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawCenterCross(canvas, size);
    drawLane(canvas, size);
    drawVanishPoint(canvas, size);
    drawYawAndPitch(canvas, size);
  }

  @override
  bool shouldRepaint(LanePainter oldDelegate) {
    return oldDelegate.point1 != point1 ||
        oldDelegate.point2 != point2 ||
        oldDelegate.point3 != point3 ||
        oldDelegate.point4 != point4;
  }

  drawVanishPoint(Canvas canvas, Size size) {
    var v1 = cpr(point1, point2, point3);
    var v2 = cpr(point1, point2, point4);

    vp = (point3.scale(v2, v2) - point4.scale(v1, v1)) / (v2 - v1);

    print('vp $vp');

    p.color = Colors.redAccent;
    p.strokeWidth = 1;
    canvas.drawLine(
      Offset(vp.dx - sizeOfCross, vp.dy),
      Offset(vp.dx + sizeOfCross, vp.dy),
      p,
    );

    canvas.drawLine(
      Offset(vp.dx, vp.dy - sizeOfCross),
      Offset(vp.dx, vp.dy + sizeOfCross),
      p,
    );

    var oc = {'x': opticalParam.cu, 'y': opticalParam.cv};

    pitch = atan2(
            vp.dy - oc['y'],
            sqrt(opticalParam.fv * opticalParam.fv +
                (vp.dx - oc['x']) * (vp.dx - oc['x']))) *
        180 /
        pi;

    yaw = atan2(opticalParam.cu - vp.dx, opticalParam.fu) * 180 / pi;
  }

  cpr(Offset a, Offset b, Offset c) {
    return (b.dx - a.dx) * (c.dy - a.dy) - (b.dy - a.dy) * (c.dx - a.dx);
  }

  void drawYawAndPitch(Canvas canvas, Size size) {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: "Yaw: $yaw\nPitch: $pitch",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
            )));
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, Offset(10, 10));
  }
}
