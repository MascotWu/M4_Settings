import 'package:flutter/material.dart';

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
    coordinate.carWidth = double.parse(carWidthController.text);
    coordinate.cameraRightDist = double.parse(cameraRightDistController.text);
    coordinate.cameraLeftDist = double.parse(cameraLeftDistController.text);

    var glassWidth = coordinate.cameraLeftDist + coordinate.cameraRightDist;
    var glassMargin = (coordinate.carWidth - glassWidth) * 0.5;
    var leftDist = coordinate.cameraLeftDist + glassMargin;
    var rightDist = coordinate.cameraRightDist + glassMargin;

    var configurations = {
      "camera_height": cameraHeightController.text,
      "left_dist_to_camera": leftDist.toString(),
      "right_dist_to_camera": rightDist.toString(),
      "front_dist_to_camera": cameraFrontDistController.text
    };
    vm.addOrUpdate(vm.detectFlagFile, configurations);
    vm.addOrUpdate(vm.macroConfigFile, configurations);

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
                  labelText: '摄像头离玻璃右边缘',
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
                  labelText: '摄像头离玻璃左边缘',
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
                  labelText: '摄像头离车头',
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
                  labelText: '车前轮轴到车头',
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
}
