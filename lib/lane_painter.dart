import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/view_model.dart';

class OpticalParam {
  double cu = 640;
  double cv = 360;
  double fu = 1458;
  double fv = 1458;
  double height = 720;
  double width = 1280;
}

class LanePainter extends CustomPainter {
  LanePainter({this.point1, this.point2, this.point3, this.point4});

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
    OpticalParam opticalParam = ViewModel
        .get()
        .opticalParam;
    Offset center = Offset(opticalParam.cu, opticalParam.cv);
    canvas.drawLine(
      Offset(center.dx - sizeOfCross, center.dy),
      Offset(center.dx + sizeOfCross, center.dy),
      p,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - sizeOfCross),
      Offset(center.dx, center.dy + sizeOfCross),
      p,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    calculateFactorOnce(size);
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

    OpticalParam opticalParam = ViewModel
        .get()
        .opticalParam;
    var oc = {'x': opticalParam.cu, 'y': opticalParam.cv};

    pitch = (atan2(
                vp.dy - oc['y'],
                sqrt(opticalParam.fv * opticalParam.fv +
                    (vp.dx - oc['x']) * (vp.dx - oc['x']))) *
            180 /
            pi)
        .toStringAsFixed(1);

    yaw = (atan2(opticalParam.cu - vp.dx, opticalParam.fu) * 180 / pi)
        .toStringAsFixed(1);

    ViewModel
        .get()
        .pitch = pitch;
    ViewModel
        .get()
        .yaw = yaw;
  }

  cpr(Offset a, Offset b, Offset c) {
    return (b.dx - a.dx) * (c.dy - a.dy) - (b.dy - a.dy) * (c.dx - a.dx);
  }

  void drawYawAndPitch(Canvas canvas, Size size) {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: "偏航角: $yaw\n俯仰角: $pitch",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
            )));
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, vp + Offset(10, 10));
  }


  calculateFactorOnce(Size size) {
    if (ViewModel
        .get()
        .hasBeenCalculated) return;
    ViewModel
        .get()
        .hasBeenCalculated = true;
    OpticalParam opticalParam = ViewModel
        .get()
        .opticalParam;

    var fovFactor = opticalParam.fu / opticalParam.cu;

    opticalParam.width = size.width;
    opticalParam.height = size.height;
    opticalParam.cu = opticalParam.cu / 4;
    opticalParam.cv = opticalParam.cv / 4;
    opticalParam.fu = fovFactor * opticalParam.cu;
    opticalParam.fv = fovFactor * opticalParam.cu;
  }
}
