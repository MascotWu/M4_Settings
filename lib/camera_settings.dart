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

    vm.getCameraConfig();
  }

  void _setConfig() {
    Coordinate coords = new Coordinate();
    coords.carWidth = double.parse(carWidthController.text);
    coords.cameraRightDist = double.parse(cameraRightDistController.text);
    coords.cameraLeftDist = double.parse(cameraLeftDistController.text);

    var glassWidth = coords.cameraLeftDist + coords.cameraRightDist;
    var glassMargin = (coords.carWidth - glassWidth) * 0.5;
    var leftDist = coords.cameraLeftDist + glassMargin;
    var rightDist = coords.cameraRightDist + glassMargin;

    var configurations = {
      "camera_height": cameraHeightController.text,
      "left_dist_to_camera": leftDist.toString(),
      "right_dist_to_camera": rightDist.toString(),
      "front_dist_to_camera": cameraFrontDistController.text
    };
    vm.addOrUpdate(vm.detectFlagFile, configurations);
    vm.addOrUpdate(vm.macroConfigFile, configurations);
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
      appBar: AppBar(
        title: Text('摄像头设置'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
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
            padding: EdgeInsets.all(8.0),
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
            padding: EdgeInsets.all(8.0),
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
            padding: EdgeInsets.all(8.0),
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
            padding: EdgeInsets.all(8.0),
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
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '车前轮轴到车头',
              ),
              controller: frontWheelFrontDistController,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setConfig,
        child: Icon(Icons.done),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
