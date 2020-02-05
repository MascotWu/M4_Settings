import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/common_variable.dart';
import '../models/view_model.dart';
import 'alert_settings.dart';
import 'protocol.dart';
import '../common/http_service.dart';

final httpTimeoutInterval = HttpService.timeoutInterval;

class ParamSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ParamSettingsState();
  }
}

class _ParamSettingsState extends State<ParamSettings> {
  int _volumeLevel = 3;
  String _protocol = '';
  String _volumeState = CommonVariable.getFailedRetry;

  getVolume() {
    setState(() {
      _volumeState = CommonVariable.getting;
    });
    HttpService.shared
        .getDeviceVolume()
        .timeout(httpTimeoutInterval)
        .then((value) {
      setState(() {
        var v = double.tryParse(value) ?? 0;
        _volumeLevel = Volume.fromValue(v).level;
        _volumeState = _volumeLevel.toString();
      });
    }).catchError((e) {
      setState(() {
        _volumeLevel = 0;
        _volumeState = CommonVariable.getFailedRetry;
      });
    });
  }

  getProtocol() {
    vm.protocol.onData((protocol) {
      const map = {
        'jt808': 'JT808',
        'subiao': '苏标协议',
        'tianmai': '天迈协议',
        'tm_client': '天迈直连协议',
        null: '未设置'
      };
      setState(() {
        _protocol = map[protocol];
      });
    });

    if (vm.protocol.isPaused) {
      vm.protocol.resume();
    }
  }

  var vm = ViewModel.get();

  _volumeChange(double value) {
    print("set volume level $value");
    if (value == null) {
      return;
    }

    final originalVolumeLevel = _volumeLevel;
    Volume volume = Volume.fromLevel(value.toInt());
    setState(() {
      _volumeState = CommonVariable.settingUp;
      _volumeLevel = volume.level;
    });
    HttpService.shared
        .setDeviceVolume(volume.value)
        .timeout(httpTimeoutInterval)
        .then((result) {
      print(result);
      setState(() {
        _volumeState = volume.level.toString();
      });
    }).catchError((e) {
      print(e);
      setState(() {
        _volumeLevel = originalVolumeLevel;
        _volumeState = CommonVariable.setFailedRetry;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getVolume();
    getProtocol();
  }

  @override
  void dispose() {
    super.dispose();
    vm.protocol.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("参数设置")),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('音量设置'),
                subtitle: Text('$_volumeState'),
                onTap: getVolume,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Slider(
                    value: _volumeLevel.toDouble(),
                    max: 3,
                    divisions: 3,
                    onChanged: (value) => _volumeChange(value)),
              ),
              Container(
                color: Colors.grey[350],
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              ),
              ListTile(
                title: Text('ADAS报警设置'),
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
                title: Text('DMS报警设置'),
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
                title: Text('传输协议设置'),
                subtitle: Text(_protocol),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              Scaffold(body: ProtocolPage())));
                },
              ),
            ],
          ),
        ));
  }
}

class Volume {
  /// There are four levels of volume, from level 0 to level 3. Level 0 represents
  /// mute while 3 represents max volume.
  final int level;

  /// [value] is the actual value to be set to the device. There are four values
  /// corresponding to each [level], which are 0.0, 0.2, 0.5 and 0.8.
  double get value {
    return _volumes[level];
  }

  static final _volumes = [0.0, 0.2, 0.5, 0.8];

  static int _levelOfValue(double value) {
    int tLevel = _volumes.indexOf(value);
    if (tLevel == -1) {
      tLevel = 0;
    }
    return tLevel;
  }

  Volume.fromLevel(this.level);

  Volume.fromValue(double value) : level = _levelOfValue(value);
}
