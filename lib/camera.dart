import 'package:flutter/material.dart';

import 'lane_painter.dart';
import 'view_model.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  ViewModel vm;

  Image _adasImage;
  Image _dmsImage;

  _CameraPageState() {
    vm = ViewModel.get();
  }

  Offset offset1 = Offset(140, 120);
  Offset offset2 = Offset(100, 180);
  Offset offset3 = Offset(200, 120);
  Offset offset4 = Offset(240, 180);

  int pointSelected;

  LanePainter curvePainter;

  @override
  Widget build(BuildContext context) {
    curvePainter = LanePainter(
        point1: offset1, point2: offset2, point3: offset3, point4: offset4);
    return Scaffold(
      appBar: AppBar(title: Text('摄像头调校'), actions: <Widget>[
        // action button
        FlatButton(
          child: Text(
            '保存',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: _setConfig,
        ),
      ]),
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          ListTile(title: Text('ADAS摄像头'),
              trailing: FlatButton(
                  child: Icon(Icons.camera_alt, color: Colors.blue),
              onPressed: () {
                vm.takePictureOfAdas().listen((picture) {
                  setState(() {
                    _adasImage = Image.memory(picture);
                  });
                });
              })),
          Container(
              padding: EdgeInsets.all(8.0),
              height: 250,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: _adasImage ?? Text(''),
                  ),
                  Center(
                    child: CustomPaint(
                      painter: curvePainter,
                      child: Center(
                        child: GestureDetector(
                          onPanStart: (detail) {
                            var offsets = [
                              (offset1 - detail.localPosition)
                                  .distanceSquared
                                  .round(),
                              (offset2 - detail.localPosition)
                                  .distanceSquared
                                  .round(),
                              (offset3 - detail.localPosition)
                                  .distanceSquared
                                  .round(),
                              (offset4 - detail.localPosition)
                                  .distanceSquared
                                  .round()
                            ];

                            var b = [
                              (offset1 - detail.localPosition)
                                  .distanceSquared
                                  .round(),
                              (offset2 - detail.localPosition)
                                  .distanceSquared
                                  .round(),
                              (offset3 - detail.localPosition)
                                  .distanceSquared
                                  .round(),
                              (offset4 - detail.localPosition)
                                  .distanceSquared
                                  .round()
                            ];
                            b.sort();
                            var r = b[0];
                            pointSelected = -1;
                            if (r < 1000)
                              for (var i = 0; i < 4; i++) {
                                if (r == offsets[i]) {
                                  pointSelected = i + 1;
                                }
                              }
                          },
                          onPanUpdate: (detail) {
                            if (pointSelected != null)
                              setState(() {
                                if (pointSelected == 1) {
                                  offset1 +=
                                      Offset(detail.delta.dx, detail.delta.dy);
                                } else if (pointSelected == 2) {
                                  offset2 +=
                                      Offset(detail.delta.dx, detail.delta.dy);
                                } else if (pointSelected == 3) {
                                  offset3 +=
                                      Offset(detail.delta.dx, detail.delta.dy);
                                } else if (pointSelected == 4) {
                                  offset4 +=
                                      Offset(detail.delta.dx, detail.delta.dy);
                                }
                              });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          ListTile(title: Text("DMS摄像头拍照"),
              trailing: FlatButton(
                  child: Icon(Icons.camera_alt, color: Colors.blue,),
                  onPressed: () {
                    vm.takePictureOfDms().listen((picture) {
                      setState(() {
                        _dmsImage = Image.memory(picture);
                      });
                    });
                  })),
          Container(
              padding: EdgeInsets.all(8.0),
              height: 250,
              alignment: Alignment.center,
              child:
              _dmsImage ?? Text(''))
        ],
      )),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _setConfig() {
    vm.addOrUpdate(vm.macroConfigFile, {
      'camera_pitch': curvePainter.pitch,
      'camera_yaw': curvePainter.yaw,
      'camera_roll': 0.0,
      'camera_fov_w': curvePainter.opticalParam.fu,
      'camera_fov_h': curvePainter.opticalParam.fv,
      'camera_cu': curvePainter.opticalParam.cu,
      'camera_cv': curvePainter.opticalParam.cv,
      'roi_width': curvePainter.opticalParam.width,
      'roi_height': curvePainter.opticalParam.height,
    });

    vm.addOrUpdate(vm.detectFlagFile, {
      'pitch': curvePainter.pitch,
      'yaw': curvePainter.yaw,
      'roll': 0.0,
      'fu': curvePainter.opticalParam.fu,
      'fv': curvePainter.opticalParam.fv,
      'cu': curvePainter.opticalParam.cu,
      'cv': curvePainter.opticalParam.cv,
      'image_width': curvePainter.opticalParam.width,
      'image_height': curvePainter.opticalParam.height,
    });

    Navigator.pop(context);
  }
}
