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

class _CameraPageState extends State<CameraPage> {
  ViewModel vm;

  Image _adasImage;
  Image _dmsImage;

  _CameraPageState() {
    vm = ViewModel.get();
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: FlatButton(
              child: Text("拍照ADAS"),
              onPressed: () {
                vm.takePictureOfAdas().listen((picture) {
                  setState(() {
                    _adasImage = Image.memory(picture);
                  });
                });
              },
            ),
          ),
          _adasImage ?? Text(''),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: FlatButton(
              child: Text("拍照DMS"),
              onPressed: () {
                vm.takePictureOfDms().listen((picture) {
                  setState(() {
                    _dmsImage = Image.memory(picture);
                  });
                });
              },
            ),
          ),
          _dmsImage ?? Text('')
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
