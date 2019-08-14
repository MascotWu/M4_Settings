import 'package:flutter/material.dart';

import 'view_model.dart';

class Jt808ConfigPage extends StatefulWidget {
  createState() => _Jt808ConfigState();
}

class _Jt808ConfigState extends State<Jt808ConfigPage> {
  ViewModel vm;

  TextEditingController ipController =
      new TextEditingController(text: '192.168.43.71');

  TextEditingController portController =
      new TextEditingController(text: '3411');

  TextEditingController deviceIdOfJT808Controller =
      new TextEditingController(text: '009381374186');

  TextEditingController associatedWithVideoController;

  TextEditingController ignoreSpeedLimitedController;

  @override
  Widget build(BuildContext context) {
    vm = ViewModel.get();

    return Scaffold(
      appBar: AppBar(
        title: Text('JT808协议'),
      ),
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
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '关联视频',
              ),
              controller: associatedWithVideoController,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '忽略速度限制',
              ),
              controller: ignoreSpeedLimitedController,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '车牌号',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '车牌颜色',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '终端ID',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '附件分辨率',
              ),
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

  void _setConfig() {
    vm.addOrUpdate(vm.mProtocolJsonFile, {'protocol': 'jt808'});
    vm.addOrUpdateServerIp(ipController.text);
    vm.addOrUpdateServerPort(portController.text);
    vm.addOrUpdateDeviceIdOfJT808(deviceIdOfJT808Controller.text);
  }
}
