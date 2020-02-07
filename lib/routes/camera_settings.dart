import 'package:flutter/material.dart';
import 'package:flutter_app/common/common_variable.dart';
import 'package:flutter_app/common/http_service.dart';
import 'package:flutter_app/models/camera_position_model.dart';

class CameraSettingsPage extends StatefulWidget {

  final CameraOriginalPosition cameraPosition;
  CameraSettingsPage(this.cameraPosition);
  createState() => _CameraSettingsPageState();
}

class _CameraSettingsPageState extends State<CameraSettingsPage> {


  var _originalPosition = CameraOriginalPosition();
  var _position = CameraPosition();

  var _statusMessage = "";

  void _setConfig() {

    if (double.tryParse(carWidthController.text) == null ||
        double.tryParse(cameraRightDistController.text) == null ||
        double.tryParse(cameraLeftDistController.text) == null ||
        double.tryParse(cameraHeightController.text) == null ||
        double.tryParse(cameraFrontDistController.text) == null ||
        double.tryParse(frontWheelFrontDistController.text) == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('所有数据必须是整数或者小数'),
          action: SnackBarAction(label: 'OK', onPressed: () {})));
      return;
    }

    var carWidth = double.parse(carWidthController.text);
    var cameraRightDist = double.parse(cameraRightDistController.text);
    var cameraLeftDist = double.parse(cameraLeftDistController.text);
    var cameraFrontDist = double.parse(cameraFrontDistController.text);
    var frontWheelFrontDist = double.parse(frontWheelFrontDistController.text);

    var glassWidth = cameraLeftDist + cameraRightDist;
    var glassMargin = (carWidth - glassWidth) * 0.5;
    var leftDist = cameraLeftDist + glassMargin;
    var rightDist = cameraRightDist + glassMargin;

    _originalPosition.carWidth = carWidth;
    _originalPosition.cameraFrontDist = cameraFrontDist;
    _originalPosition.frontWheelFrontDist = frontWheelFrontDist;
    _originalPosition.cameraRightGlassDist = cameraRightDist;
    _originalPosition.cameraLeftGlassDist = cameraLeftDist;
    _originalPosition.cameraRightDist = rightDist;
    _originalPosition.cameraLeftDist = leftDist;
    _originalPosition.cameraHeight = double.parse(cameraHeightController.text);

    _position = CameraPosition.fromJson(_originalPosition.toJson());

    print(_originalPosition.toJson());
    print(_position.toJson());

    setCameraPosition(_position, _originalPosition);
  }

  setCameraOriginalPosition(CameraOriginalPosition position) {
    HttpService.shared
        .setValueKey(position.toJson())
        .timeout(HttpService.timeoutInterval)
        .then((value) {
      setState(() {
        _statusMessage = CommonVariable.setSuccess;
      });
    }).catchError((e) {
      print(e);
      setState(() {
        _statusMessage = CommonVariable.setFailedRetry;
      });
    });
  }

  setCameraPosition(CameraPosition position, CameraOriginalPosition original) {
    setState(() {
      _statusMessage = CommonVariable.settingUp;
    });

    Future.wait([
      HttpService.shared
          .setCameraPosition(position.toJson())
          .timeout(HttpService.timeoutInterval),
      HttpService.shared
          .setValueKey(original.toJson())
          .timeout(HttpService.timeoutInterval)
    ]).then((result) {
      result.forEach((String item) {
        if (item != MResult.OK) {
          setState(() {
            _statusMessage = CommonVariable.setFailedRetry;
          });
          return;
        }
      });
      setState(() {
        _statusMessage = CommonVariable.setSuccess;
      });

      Future.delayed(Duration(seconds: 3)).then((value) {
        Navigator.pop(context);
      });
    }).catchError((e) {
      setState(() {
        _statusMessage = CommonVariable.setFailedRetry;
      });
    });
  }

  final carWidthController = TextEditingController();
  final cameraHeightController = TextEditingController();
  final cameraRightDistController = TextEditingController();
  final cameraLeftDistController = TextEditingController();
  final cameraFrontDistController = TextEditingController();
  final frontWheelFrontDistController = TextEditingController();

//  final carWidthController = TextEditingController(text: '2.2');
//  final cameraHeightController = TextEditingController(text: '1.5');
//  final cameraRightDistController = TextEditingController(text: '0.8');
//  final cameraLeftDistController = TextEditingController(text: '0.8');
//  final cameraFrontDistController = TextEditingController(text: '0.1');
//  final frontWheelFrontDistController = TextEditingController(text: '1.5');

  @override
  void initState() {
    super.initState();
    var position = widget.cameraPosition;
    if (position.carWidth == null) {
      _statusMessage = "暂未设置";
    }
    carWidthController.text = position.carWidth != null
        ? position.carWidth.toString()
        : null;
    cameraHeightController.text = position.cameraHeight != null
        ? position.cameraHeight.toString()
        : null;
    cameraRightDistController.text =
    position.cameraRightGlassDist != null
        ? position.cameraRightGlassDist.toString()
        : null;
    cameraLeftDistController.text =
    position.cameraLeftGlassDist != null
        ? position.cameraLeftGlassDist.toString()
        : null;
    cameraFrontDistController.text =
    position.cameraFrontDist != null
        ? position.cameraFrontDist.toString()
        : null;
    frontWheelFrontDistController.text =
    position.frontWheelFrontDist != null
        ? position.frontWheelFrontDist.toString()
        : null;

  }

  @override
  void dispose() {
    carWidthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ADAS安装参数'), actions: <Widget>[
        // action button
        FlatButton(
          child: Text(
            '保存',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: _setConfig,
        ),
      ]),
      body: Column(children: <Widget>[
        Center(
          child: Text(_statusMessage),
        ),
        Expanded(
          child: SingleChildScrollView(
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
                  child: Image.asset('assets/c-truck-pos-front.png'),
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
                  child: Image.asset('assets/c-truck-pos-side.png'),
                ),
              ],
            ),
          ),
        ),
      ]),
      resizeToAvoidBottomPadding: false,
    );
  }

}
