import 'package:flutter/material.dart';

import '../widgets/picker_dialog.dart';
import '../models/view_model.dart';

class Jt808ConfigPage extends StatefulWidget {
  createState() => _Jt808ConfigState();
}

class _Jt808ConfigState extends State<Jt808ConfigPage> {
  ViewModel vm;

  TextEditingController _ipController =
  new TextEditingController();

  TextEditingController _portController =
  new TextEditingController();

  TextEditingController _deviceIdOfJT808Controller =
  new TextEditingController();

  TextEditingController _terminalIdController =
  new TextEditingController();

  bool _associatedWithVideo = false;

  TextEditingController ignoreSpeedLimitedController;

  TextEditingController _plateNumberController =
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

  get _colorName =>
      colors.firstWhere((color) => color['value'] == _color)['title'];

  String _resolution;

  _Jt808ConfigState() {
    vm = ViewModel.get();

    _ipController.text = vm.ip;

    _portController.text = vm.port.toString();

    _deviceIdOfJT808Controller.text = vm.deviceIdOfJT808;

    _associatedWithVideo = vm.associatedWithVideo;

    _ignoreSpeedLimitation = vm.ignoreSpeedLimitation;

    _plateNumberController.text = vm.plateNumber;

    _color = vm.plateColor;

    _terminalIdController.text = vm.terminalId;

    _resolution = vm.resolution;
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '服务器地址',
              ),
              controller: _ipController,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '服务器端口号',
              ),
              controller: _portController,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '设备id',
              ),
              controller: _deviceIdOfJT808Controller,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '车牌号',
              ),
              controller: _plateNumberController,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '终端ID',
              ),
              controller: _terminalIdController,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: SwitchListTile(
              title: const Text('关联视频'),
              value: _associatedWithVideo,
              onChanged: (bool associated) {
                setState(() {
                  _associatedWithVideo = associated;
                });
              },
              secondary: const Icon(Icons.ondemand_video),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: SwitchListTile(
              title: const Text('忽略速度限制'),
              value: _ignoreSpeedLimitation,
              onChanged: (bool ignore) {
                setState(() {
                  _ignoreSpeedLimitation = ignore;
                });
              },
              secondary: const Icon(Icons.block),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text('车牌颜色'),
            subtitle: Text(_colorName),
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
                  setState(() {
                    _color = color;
                  });
                }
              });
            }
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
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
                if (resolution != null)
                  _resolution = resolution;
              });
            }),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  showMessage(message) {
    Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text(message),
            action: SnackBarAction(
                label: 'OK', onPressed: () {})));
  }

  void _setConfig() {
    if (_associatedWithVideo && _resolution == null) {
      showMessage("请选择附件分辨率");
      return;
    }

    if (_color == null || _plateNumberController.text.isEmpty) {
      showMessage("请填写车牌号并选择车牌颜色");
      return;
    }

    if (_ipController.text.isEmpty || _portController.text.isEmpty) {
      showMessage("请填写ip地址以及端口号");
      return;
    }

    if (int.tryParse(_portController.text) == null) {
      showMessage("端口号不合法");
      return;
    }

    if (_terminalIdController.text.isEmpty) {
      showMessage("请填写终端id");
      return;
    }

    if (vm.mProtocolJsonFile.config['protocol'] != 'jt808') {
      vm.addOrUpdate(vm.mProtocolJsonFile, {'protocol': 'jt808'});
      vm.protocolStream.add('jt808');
      vm.push(vm.mProtocolJsonFile);
    }

    vm.plateColor = _color;
    if (_resolution != null) vm.resolution = _resolution;
    vm.associatedWithVideo = _associatedWithVideo;
    vm.ignoreSpeedLimitation = _ignoreSpeedLimitation;
    vm.ip = _ipController.text;
    vm.port = int.parse(_portController.text);
    vm.deviceIdOfJT808 = _deviceIdOfJT808Controller.text;
    vm.plateNumber = _plateNumberController.text;
    vm.terminalId = _terminalIdController.text;

    vm.push(vm.mProtocolConfigJsonFile);

    Navigator.pop(context);
  }
}
