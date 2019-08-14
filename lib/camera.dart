import 'package:flutter/material.dart';

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
        title: Text('拍照'),
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
