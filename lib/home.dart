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

  double _volume;

  @override
  void initState() {
    _volume = vm.volume ?? 0.0;
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
          onTap: () {
            return showDialog<double>(
                context: context,
                builder: (BuildContext context) {
                  return SliderDialog(
                    value: _volume,
                    max: 0.8,
                    onChange: (volume) {
                      print({'volume': volume});
                      if (volume != null) {
                        vm.setVolume(volume);
                        vm.volume = volume;
                        setState(() {
                          _volume = volume;
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
          onTap: () {
            return showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return Picker(
                    title: '请选择速度',
                    options: speeds,
                  );
                }).then((speed) {
              if (speed == -1)
                vm.deleteSpeed();
              else if (speed != null) {
                vm.addOrUpdateSpeed(speed);
              }
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