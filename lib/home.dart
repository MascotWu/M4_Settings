import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data_source.dart';
import 'package:flutter_app/protocol.dart';
import 'package:flutter_app/slider_dialog.dart';

import 'alert_settings.dart';
import 'camera.dart';
import 'camera_settings.dart';
import 'connection.dart';
import 'picker_dialog.dart';
import 'view_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ViewModel vm = ViewModel.get();

  String _fakeSpeed = '未设置';

  String _log = '';

  double _volume = 0.0;

  getVolume() {
    vm.volume.onData((volume) {
      setState(() {
        _volume = volume;
      });
    });

    if (vm.volume.isPaused)
      vm.volume.resume();
  }

  String _protocol = '';

  getProtocol() {
    vm.protocol.onData((protocol) {
      const map = {
        'jt808': 'JT808',
        'subiao': '苏标协议',
        'tianmai': '天迈协议',
        null: '未设置'
      };
      setState(() {
        _protocol = map[protocol];
      });
    });

    if (vm.protocol.isPaused)
      vm.protocol.resume();
  }

  StreamSubscription connectionSubscription;

  @override
  void initState() {
    getVolume();
    getProtocol();

    connectionSubscription ??= vm.connectionStatus.listen((isConnected) {
      if (!isConnected)
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => ConnectionPage()));
    });

    if (connectionSubscription.isPaused) {
      connectionSubscription.resume();
    }

    vm.logSubject.stream.listen((log) {
      setState(() {
        _log += log += '\n\n';
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
        SingleChildScrollView(
          child: Column(children: <Widget>[
            ListTile(
              leading: const Icon(Icons.surround_sound),
              title: Text('信号源设置'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            Scaffold(body: DataSourcePage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: Text('摄像头设置'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            Scaffold(body: CameraSettingsPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: Text('报警设置'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            Scaffold(body: AlertSettingsPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: Text('协议设置'),
              subtitle: Text(_protocol),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => Scaffold(body: ProtocolPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: Text('音量设置'),
              subtitle: Text('$_volume'),
              onTap: () {
                return showDialog<double>(
                    context: context,
                    builder: (BuildContext context) {
                      return SliderDialog(
                        value: Volume
                            .fromValue(_volume)
                            .level
                            .roundToDouble(),
                        max: 3,
                        divisions: 3,
                        onChange: (double level) {
                          if (level != null) {
                            setState(() {
                              _volume = vm.volume = Volume
                                  .fromLevel(level.round())
                                  .value;
                            });
                          }
                        },
                      );
                    });
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: Text('假速度设置'),
              subtitle: Text(_fakeSpeed),
              onTap: () {
                return showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return Picker(
                        title: '请选择速度',
                        options: speeds,
                      );
                    }).then((speed) {
                  if (speed == null)
                    return;

                  setState(() {
                    _fakeSpeed = FakeSpeed(speed).toString();
                  });

                  if (speed == -1)
                    vm.deleteSpeed();
                  else
                    vm.addOrUpdateSpeed(speed);

                  vm.stopAdasService();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_enhance),
              title: Text('摄像头调校'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context) => Scaffold(body: CameraPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text('软件版本'),
              subtitle: Text('0.4.1'),
              onTap: () {
                return showDialog<double>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('更新日志'),
                        content: Text(
                            '1. 修复ldw不生效的问题\n'),
                      );
                    });
              },
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: InkWell(
                child: Text(_log),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _log));

                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                          content: Text('已复制到剪贴板'),
                          action: SnackBarAction(
                              label: 'OK', onPressed: () {})));
                },
              ),
            ),
          ]),
        ));
  }

  void onConnectionStatusChanged(bool isConnected) {

  }

  List<Map<String, dynamic>> speeds = [
    {'title': '无', 'value': -1},
    {'title': '20 km/h', 'value': 20},
    {'title': '40 km/h', 'value': 40},
    {'title': '60 km/h', 'value': 60},
  ];

  @override
  void dispose() {
    super.dispose();

    vm.fakeSpeed.pause();
    vm.protocol.pause();
    vm.volume.pause();
    connectionSubscription.pause();
  }
}

class FakeSpeed {
  final int speed;

  FakeSpeed(this.speed);

  @override
  String toString() {
    return speed == null || speed < 0 ? '无' : '$speed km/h';
  }
}

class Volume {
  /// There are four levels of volume, from level 0 to level 4. Level 0 represents
  /// mute while 3 represents max volume.
  final int level;

  /// [value] is the actual value to be set to the device. There are four values
  /// corresponding to each [level], which are 0.0, 0.2, 0.5 and 0.8.
  final double value;

  Volume.fromLevel(this.level)
      :value=[0.0, 0.2, 0.5, 0.8][level];

  Volume.fromValue(this.value)
      :level=[0.0, 0.2, 0.5, 0.8].indexOf(value);
}