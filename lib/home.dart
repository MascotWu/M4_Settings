import 'package:flutter/material.dart';
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
  var _textOfConnectButton = "";

  ViewModel vm = ViewModel.get();

  String _fakeSpeed = '';

  getFakeSpeed() async {
    await for (int fakeSpeed in vm.fakeSpeed) {
      setState(() {
        _fakeSpeed = FakeSpeed(fakeSpeed).toString();
      });
    }
  }

  double _volume = 0.0;

  getVolume() async {
    await for (double volume in vm.volume) {
      setState(() {
        _volume = volume;
      });
    }
  }

  String _protocol = '';

  getProtocol() async {
    await for (String protocol in vm.protocolStream.stream) {
      const map = {
        'jt808': 'JT808',
        'subiao': '苏标协议',
        'tianmai': '天迈协议',
        null: '未设置'
      };
      setState(() {
        _protocol = map[protocol];
      });
    }
  }

  @override
  void initState() {
    getFakeSpeed();
    getVolume();
    getProtocol();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vm.connectionStatus.listen(onConnectionStatusChanged);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text(_textOfConnectButton),
            onPressed: () {},
          )
        ],
      ),
      body: Column(children: <Widget>[
        ListTile(
          leading: const Icon(Icons.surround_sound),
          title: Text('信号源设置'),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new DataSourcePage()));
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
                    builder: (context) => new CameraSettingsPage()));
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
                    builder: (context) => new AlertSettingsPage()));
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
                    builder: (context) => new ProtocolPage()));
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
                new MaterialPageRoute(builder: (context) => new CameraPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.code),
          title: Text('软件版本'),
          subtitle: Text('0.3.5'),
          onTap: () {
            return showDialog<double>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('新增'),
                    content: Text(
                        '1. 首页显示当前音量\n2. 首页显示当前协议\n3. 首页显示当前假速度'),
                  );
                });
          },
        ),
      ]),
    );
  }

  void onConnectionStatusChanged(bool isConnected) {
    if (!isConnected) {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => ConnectionPage()));
    }
  }

  List<Map<String, dynamic>> speeds = [
    {'title': '无', 'value': -1},
    {'title': '20km/h', 'value': 20},
    {'title': '40km/h', 'value': 40},
    {'title': '60km/h', 'value': 60},
    {'title': '120km/h', 'value': 120},
  ];
}

class FakeSpeed {
  final int speed;

  FakeSpeed(this.speed);

  @override
  String toString() {
    return speed == null ? '无' : '$speed km/h';
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