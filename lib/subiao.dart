import 'package:flutter/material.dart';

import 'picker_dialog.dart';
import 'view_model.dart';

class SuBiaoConfigPage extends StatefulWidget {
  createState() => _SuBiaoConfigState();
}

class _SuBiaoConfigState extends State<SuBiaoConfigPage> {
  ViewModel vm;

  bool _associatedWithVideo = false;

  bool _useRtData = false;

  var resolutions = [
    {'title': 'CIF(352×288)', 'value': "CIF"},
    {'title': 'HD1(704×288)', 'value': "HD1"},
    {'title': 'D1(704×576)', 'value': "D1"},
    {'title': 'VGA(640×480)', 'value': "VGA"},
    {'title': '720P(1280×720)', 'value': "720P"},
    {'title': '1080P(1920×1080)', 'value': "1080P"},
  ];

  String _resolution;

  _SuBiaoConfigState() {
    vm = ViewModel.get();

    if (vm.mProtocolConfigJsonFile.config['protocol'] != null) {
      _useRtData =
          vm.mProtocolConfigJsonFile.config['protocol']['use_rtdata'] ?? false;
    }

    if (vm.mProtocolConfigJsonFile.config['protocol'] != null)
      _associatedWithVideo = vm.mProtocolConfigJsonFile.config['protocol']
              ['associated_video'] ??
          false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JT808协议'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('关联视频'),
            value: _associatedWithVideo,
            onChanged: (bool associated) {
              setState(() {
                _associatedWithVideo = associated;
              });
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
          SwitchListTile(
            title: const Text('使用部标机信号'),
            value: _useRtData,
            onChanged: (bool ignore) {
              setState(() {
                _useRtData = ignore;
              });
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
          ListTile(
            leading: FlutterLogo(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _setConfig,
        tooltip: 'Increment',
        child: Icon(Icons.done),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _setConfig() {
    if (vm.mProtocolJsonFile.config['protocol'] != 'subiao') {
      vm.resetMProtocolConfigJsonFile('subiao');
      vm.addOrUpdate(vm.mProtocolJsonFile, {'protocol': 'subiao'});
      vm.push(vm.mProtocolJsonFile);
    }

    if (_resolution != null) vm.addOrUpdateResolutionForSuBiao(_resolution);
    vm.addOrUpdateAssociatedWithVideoOfSuBiao(_associatedWithVideo);
    vm.addOrUpdateUseRtData(_useRtData);

    Navigator.pop(context);
  }
}
