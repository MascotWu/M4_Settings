import 'package:flutter/material.dart';

import 'view_model.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class Coordinate {
  var carWidth;
  var cameraLeftDist;
  var cameraRightDist;
}

class _CameraPageState extends State<CameraPage> {
  ViewModel vm;

  _CameraPageState() {
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

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
        tooltip: 'Increment',
        child: Icon(Icons.done),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      resizeToAvoidBottomPadding: false,
    );
  }
}
