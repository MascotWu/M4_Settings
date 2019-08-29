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

  Offset offset1 = Offset(140, 100);
  Offset offset2 = Offset(100, 160);
  Offset offset3 = Offset(180, 100);
  Offset offset4 = Offset(220, 160);

  int pointSelected;

  LanePainter curvePainter;

  double _height = 720 / 4;
  double _width = 1280 / 4;

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
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: _height,
                    width: _width,
                    alignment: Alignment.topCenter,
                    child: _adasImage ?? Text(''),
                  ),
                  Container(
                    height: _height,
                    width: _width,
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
                            if (r < 8000)
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
              height: 150,
              alignment: Alignment.center,
              child:
              _dmsImage ?? Text(''))
        ],
      )),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _setConfig() {
    OpticalParam opticalParam = ViewModel
        .get()
        .opticalParam;
    vm.addOrUpdate(vm.macroConfigFile, {
      'camera_pitch': curvePainter.pitch,
      'camera_yaw': curvePainter.yaw,
      'camera_roll': 0.0,
      'camera_fov_w': opticalParam.fu,
      'camera_fov_h': opticalParam.fv,
      'camera_cu': opticalParam.cu,
      'camera_cv': opticalParam.cv,
      'roi_width': opticalParam.width,
      'roi_height': opticalParam.height,
    });

    vm.addOrUpdate(vm.detectFlagFile, {
      'pitch': curvePainter.pitch,
      'yaw': curvePainter.yaw,
      'roll': 0.0,
      'fu': opticalParam.fu,
      'fv': opticalParam.fv,
      'cu': opticalParam.cu,
      'cv': opticalParam.cv,
      'image_width': opticalParam.width,
      'image_height': opticalParam.height,
    });

    Navigator.pop(context);
  }
}
