import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'picker_dialog.dart';
import 'view_model.dart';

class Jt808ConfigPage extends StatefulWidget {
  createState() => _Jt808ConfigState();
}

class _Jt808ConfigState extends State<Jt808ConfigPage> {
  ViewModel vm;

  TextEditingController ipController =
  new TextEditingController();

  TextEditingController portController =
  new TextEditingController();

  TextEditingController deviceIdOfJT808Controller =
  new TextEditingController();

  TextEditingController terminalIdController =
  new TextEditingController();

  bool _associatedWithVideo = false;

  TextEditingController ignoreSpeedLimitedController;

  TextEditingController plateNumberController =
  new TextEditingController();

  bool _ignoreSpeedLimitation;

  var colors = [
    {'title': '蓝色', 'value': 1},
    {'title': '黄色', 'value': 2},
    {'title': '黑色', 'value': 3},
    {'title': '白色', 'value': 4},
    {'title': '其他', 'value': 9},
  ];

  var resolutions = [
    {'title': 'CIF(352×288)', 'value': "CIF"},
    {'title': 'HD1(704×288)', 'value': "HD1"},
    {'title': 'D1(704×576)', 'value': "D1"},
    {'title': 'VGA(640×480)', 'value': "VGA"},
    {'title': '720P(1280×720)', 'value': "720P"},
    {'title': '1080P(1920×1080)', 'value': "1080P"},
  ];

  int _color;
  String _resolution;

  _Jt808ConfigState() {
    vm = ViewModel.get();

    _ignoreSpeedLimitation =
        vm.mProtocolConfigJsonFile.config['ignore_spdth'] ?? false;

    vm.mProtocolConfigJsonFile.config['reg_param'] ??= {};
    vm.mProtocolConfigJsonFile.config['server'] ??= {};
    vm.mProtocolConfigJsonFile.config['resolution'] ??= {};

    ipController.text = vm.mProtocolConfigJsonFile.config['server']['ipaddr'];
    portController.text = vm.mProtocolConfigJsonFile.config['server']['port'];

    vm.mProtocolConfigJsonFile.config['server']['heartbeat_period'] ??= 30;

    vm.mProtocolConfigJsonFile.config['reg_param']['province_id'] ??= 0;
    vm.mProtocolConfigJsonFile.config['reg_param']['city_id'] ??= 0;
    vm.mProtocolConfigJsonFile.config['reg_param']['vendor'] ??= 'MNEYE';
    vm.mProtocolConfigJsonFile.config['reg_param']['product'] ??=
    "MINIEYE_ADAS/DSM";
    var random = Random(DateTime
        .now()
        .millisecondsSinceEpoch);

    vm.mProtocolConfigJsonFile.config['reg_param']['dev_id'] ??=
        random.nextInt(pow(36, 3)).toRadixString(36).toUpperCase() +
            random.nextInt(pow(36, 4)).toRadixString(36).toUpperCase();

    terminalIdController.text =
    vm.mProtocolConfigJsonFile.config['reg_param']['dev_id'];

    deviceIdOfJT808Controller.text =
    vm.mProtocolConfigJsonFile.config['reg_param']['reg_id'];

    _color = vm.mProtocolConfigJsonFile.config['reg_param']['plate_color'];
    plateNumberController.text =
    vm.mProtocolConfigJsonFile.config['reg_param']['car_num'];

    _associatedWithVideo = vm.mProtocolConfigJsonFile.config['reg_param']
    ['associated_video'] ?? false;
    _color = vm.mProtocolConfigJsonFile.config['reg_param']['plate_color'];

    _resolution = vm.mProtocolConfigJsonFile.config['resolution']['adas_video'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JT808协议'), actions: <Widget>[
        // action button
        FlatButton(
          child: Text(
            '保存',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: _setConfig,
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '服务器地址',
              ),
              controller: ipController,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '服务器端口号',
              ),
              controller: portController,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '设备id',
              ),
              controller: deviceIdOfJT808Controller,
            ),
          ),
          SwitchListTile(
            title: const Text('关联视频'),
            value: _associatedWithVideo,
            onChanged: (bool associated) {
              setState(() {
                _associatedWithVideo = associated;
              });
            },
            secondary: const Icon(Icons.ondemand_video),
          ),
          SwitchListTile(
            title: const Text('忽略速度限制'),
            value: _ignoreSpeedLimitation,
            onChanged: (bool ignore) {
              setState(() {
                _ignoreSpeedLimitation = ignore;
              });
            },
            secondary: const Icon(Icons.block),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '车牌号',
              ),
              controller: plateNumberController,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text('车牌颜色'),
            onTap: () {
              return showDialog<int>(
                  context: context,
                  builder: (BuildContext context) {
                    return Picker(
                      title: '请选择车牌颜色',
                      options: colors,
                    );
                  }).then((color) {
                print({'color': color});
                if (color != null) {
                  _color = color;
                }
              });
            },
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '终端ID',
              ),
              controller: terminalIdController,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: Text('附件分辨率'),
            onTap: () {
              return showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return Picker(
                      title: '请选择附件分辨率',
                      options: resolutions,
                    );
                  }).then((resolution) {
                print({'resolution': resolution});
                if (resolution != null) {
                  _resolution = resolution;
                }
              });
            },
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _setConfig() {
    if (_associatedWithVideo && _resolution == null) {
      Fluttertoast.showToast(
        msg: "请选择附件分辨率",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );
      return;
    }

    if (_color == null || plateNumberController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "请填写车牌号并选择车牌颜色",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );
      return;
    }

    if (ipController.text.isEmpty || portController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "请填写ip地址以及端口号",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );
      return;
    }

    if (terminalIdController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "请填写终端id",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );
      return;
    }

    if (vm.mProtocolJsonFile.config['protocol'] != 'jt808') {
      vm.resetMProtocolConfigJsonFile('jt808');
      vm.addOrUpdate(vm.mProtocolJsonFile, {'protocol': 'jt808'});
      vm.push(vm.mProtocolJsonFile);
    }

    vm.addOrUpdatePlateColor(_color);
    if (_resolution != null) vm.addOrUpdateResolutionForJt808(_resolution);
    vm.addOrUpdateAssociatedWithVideoOfJT808(_associatedWithVideo);
    vm.addOrUpdateIgnoreSpeedLimited(_ignoreSpeedLimitation);
    vm.addOrUpdateServerIp(ipController.text);
    vm.addOrUpdateServerPort(portController.text);
    vm.addOrUpdateDeviceIdOfJT808(deviceIdOfJT808Controller.text);
    vm.addOrUpdatePlateNumber(plateNumberController.text);
    vm.addOrUpdateTerminalId(terminalIdController.text);

    Navigator.pop(context);
  }
}
