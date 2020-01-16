import 'package:flutter/material.dart';

import 'lane_painter.dart';
import 'outlet_painter.dart';
import 'view_model.dart';
import 'http_service.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  ViewModel vm;

  Image _adasImage = Image.asset('assets/placeholder.jpg');
  Image _dmsImage = Image.asset('assets/placeholder.jpg');

  String _tipString = "";

  _CameraPageState() {
    vm = ViewModel.get();
  }

  Offset offset1 = Offset(140, 100);
  Offset offset2 = Offset(100, 160);
  Offset offset3 = Offset(180, 100);
  Offset offset4 = Offset(220, 160);

  int pointSelected;

  LanePainter curvePainter;
  OutletPainter outletPainter = OutletPainter();

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
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(_tipString),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 10),
                child: RaisedButton(
                    child: Text('ADAS摄像头拍照'),
                    onPressed: () {
                      setState(() {
                        _tipString = "正在获取ADAS照片";
                      });
                      HttpService.shared
                          .getAdasPicture()
                          .timeout(Duration(seconds: 3))
                          .then((picture) {
                        setState(() {
                          _tipString = "";
                          _adasImage = Image.memory(picture);
                        });
                      }).catchError((error) {
                        _tipString = "获取ADAS照片失败，请更新程序或者断电重启后再试";
                      });
//                  vm.takePictureOfAdas().listen((picture) {
//                    setState(() {
//                      _adasImage = Image.memory(picture);
//                    });
//                  });
                    }),
              ),
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
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25, bottom: 10),
            child: RaisedButton(
                child: Text('DMS摄像头拍照'),
                onPressed: () {
                  setState(() {
                    _tipString = "正在获取DMS照片";
                  });
                  HttpService.shared
                      .getDmsPicture()
                      .timeout(Duration(seconds: 3))
                      .then((picture) {
                    setState(() {
                      _tipString = "";
                      _dmsImage = Image.memory(picture);
                    });
                  }).catchError((error) {
                    _tipString = "获取DMS照片失败，请更新程序或者断电重启后再试";
                  });

//                    vm.takePictureOfDms().listen((picture) {
//                      setState(() {
//                        _dmsImage = Image.memory(picture);
//                      });
//                    });
                }),
          ),
          Stack(
            children: <Widget>[
              Container(
                height: _height,
                width: _width,
                alignment: Alignment.topCenter,
                child: _dmsImage ?? Text(''),
              ),
              Container(
                height: _height,
                width: _width,
                child: CustomPaint(
                  painter: outletPainter,
                  child: Center(),
                ),
              ),
            ],
          )
        ],
      )),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _setConfig() {
    OpticalParam opticalParam = ViewModel.get().originalOpticalParam;
    vm.addOrUpdate(vm.carConfigFile, {
      'camera_pitch': ViewModel.get().pitch,
      'camera_yaw': ViewModel.get().yaw,
      'camera_roll': 0.0,
      'camera_fov_w': opticalParam.fu,
      'camera_fov_h': opticalParam.fv,
      'camera_cu': opticalParam.cu,
      'camera_cv': opticalParam.cv,
      'roi_width': opticalParam.width.round(),
      'roi_height': opticalParam.height.round(),
    });

    vm.addOrUpdate(vm.laneConfigFile, {
      'pitch': ViewModel.get().pitch,
      'yaw': ViewModel.get().yaw,
      'roll': 0.0,
      'fu': opticalParam.fu,
      'fv': opticalParam.fv,
      'cu': opticalParam.cu,
      'cv': opticalParam.cv,
      'image_width': opticalParam.width.round(),
      'image_height': opticalParam.height.round(),
    });

    Navigator.pop(context);
  }
}
