import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'view_model.dart';

class CameraSettingsPage extends StatefulWidget {
  createState() => _CameraSettingsPageState();
}

class Coordinate {
  var carWidth;
  var cameraLeftDist;
  var cameraRightDist;
}

class _CameraSettingsPageState extends State<CameraSettingsPage> {
  ViewModel vm;

  _CameraSettingsPageState() {
    vm = ViewModel.get();
  }

  void _setConfig() {
    Coordinate coordinate = new Coordinate();

    if (double.tryParse(carWidthController.text) == null ||
        double.tryParse(cameraRightDistController.text) == null ||
        double.tryParse(cameraLeftDistController.text) == null ||
        double.tryParse(cameraHeightController.text) == null ||
        double.tryParse(cameraFrontDistController.text) == null ||
        double.tryParse(frontWheelFrontDistController.text) == null) {
      Fluttertoast.showToast(
        msg: "所有数据必须是整数或者小数",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );
    }

    coordinate.carWidth = double.parse(carWidthController.text);
    coordinate.cameraRightDist = double.parse(cameraRightDistController.text);
    coordinate.cameraLeftDist = double.parse(cameraLeftDistController.text);
    var cameraFrontDist = double.parse(cameraFrontDistController.text);
    var frontWheelFrontDist = double.parse(frontWheelFrontDistController.text);

    var glassWidth = coordinate.cameraLeftDist + coordinate.cameraRightDist;
    var glassMargin = (coordinate.carWidth - glassWidth) * 0.5;
    var leftDist = coordinate.cameraLeftDist + glassMargin;
    var rightDist = coordinate.cameraRightDist + glassMargin;

    vm.addOrUpdate(vm.detectFlagFile, {
      "camera_height": cameraHeightController.text,
      "left_vehicle_edge_dist": leftDist.toString(),
      "right_vehicle_edge_dist": rightDist.toString(),
      "front_vehicle_edge_dist": cameraFrontDist,
      "front_wheel_camera_dist": cameraFrontDist - frontWheelFrontDist
    });

    vm.addOrUpdate(vm.macroConfigFile, {
      "camera_height": cameraHeightController.text,
      "left_dist_to_camera": leftDist.toString(),
      "right_dist_to_camera": rightDist.toString(),
      "front_dist_to_camera": cameraFrontDistController.text
    });

    Navigator.pop(context);
  }

  final carWidthController = TextEditingController(text: '2.2');
  final cameraHeightController = TextEditingController(text: '1.5');
  final cameraRightDistController = TextEditingController(text: '0.8');
  final cameraLeftDistController = TextEditingController(text: '0.8');
  final cameraFrontDistController = TextEditingController(text: '0.1');
  final frontWheelFrontDistController = TextEditingController(text: '1.5');

  @override
  void dispose() {
    carWidthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('摄像头设置'), actions: <Widget>[
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
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '车宽',
                ),
                controller: carWidthController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '摄像头高度',
                ),
                controller: cameraHeightController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '摄像头离玻璃右边缘 ①',
                ),
                controller: cameraRightDistController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '摄像头离玻璃左边缘 ②',
                ),
                controller: cameraLeftDistController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '摄像头离车头 ③',
                ),
                controller: cameraFrontDistController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '车前轮轴到车头 ④',
                ),
                controller: frontWheelFrontDistController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: Image.asset('assets/c-car-pos-front.png'),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: Image.asset('assets/c-car-pos-side.png'),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: Image.asset('assets/c-truck-pos-front.png'),
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              alignment: Alignment.center,
              child: Image.asset('assets/c-truck-pos-side.png'),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  double onError(String source) {}
}
