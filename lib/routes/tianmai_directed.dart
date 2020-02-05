import 'package:flutter/material.dart';

import '../widgets/picker_dialog.dart';
import '../models/view_model.dart';

class TianMaiDirectConfigPage extends StatefulWidget {
  createState() => _TianMaiDirectedConfigState();
}

class _TianMaiDirectedConfigState extends State<TianMaiDirectConfigPage> {
  ViewModel vm;

  TextEditingController _ipController = new TextEditingController();

  TextEditingController _portController = new TextEditingController();

  TextEditingController _carNumberController = new TextEditingController();

  String _resolution;

  var resolutions = [
    {'title': 'CIF(352×288)', 'value': "CIF"},
    {'title': 'HD1(704×288)', 'value': "HD1"},
    {'title': 'D1(704×576)', 'value': "D1"},
    {'title': 'VGA(640×480)', 'value': "VGA"},
    {'title': '720P(1280×720)', 'value': "720P"},
    {'title': '1080P(1920×1080)', 'value': "1080P"},
  ];

  _TianMaiDirectedConfigState() {
    vm = ViewModel.get();

    _ipController.text = vm.ip;

    _portController.text = vm.port.toString();

    _carNumberController.text = vm.carNumber.toString();

    _resolution = vm.resolution;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('天迈直连协议'), actions: <Widget>[
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
                labelText: '车辆编号',
              ),
              controller: _carNumberController,
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
                    if (resolution != null) _resolution = resolution;
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
        SnackBar(content: Text(message), action: SnackBarAction(label: 'OK', onPressed: () {})));
  }

  void _setConfig() {
    if (_ipController.text.isEmpty || _portController.text.isEmpty) {
      showMessage("请填写ip地址以及端口号");
      return;
    }

    if (int.tryParse(_portController.text) == null) {
      showMessage("端口号不合法");
      return;
    }

    if (int.tryParse(_carNumberController.text) == null) {
      showMessage("车辆编号不合法");
      return;
    }

    if (vm.mProtocolJsonFile.config['protocol'] != 'tm_client') {
      vm.addOrUpdate(vm.mProtocolJsonFile, {'protocol': 'tm_client'});
      vm.protocolStream.add('tm_client');
      vm.push(vm.mProtocolJsonFile);
    }

    if (_resolution != null) vm.resolution = _resolution;
    vm.ip = _ipController.text;
    vm.port = int.parse(_portController.text);
    vm.carNumber = int.parse(_carNumberController.text);

    vm.push(vm.mProtocolConfigJsonFile);

    Navigator.pop(context);
  }
}
