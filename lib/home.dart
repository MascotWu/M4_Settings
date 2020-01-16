import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data_source.dart';
import 'package:flutter_app/http_service.dart';
import 'package:flutter_app/package_manager.dart';
import 'package:flutter_app/protocol.dart';
import 'package:flutter_app/slider_dialog.dart';
import 'package:http/http.dart' as http;

import 'alert_settings.dart';
import 'camera.dart';
import 'camera_settings.dart';
import 'connection.dart';
import 'picker_dialog.dart';
import 'view_model.dart';

import 'configurations.dart';

final httpTimeoutInterval = Duration(seconds: 5);

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

  int _volumeLevel = 4;

  String _c4Version = "获取中……";

  String _deviceType = "点击重新获取";

  getVolume() {
    vm.volume.onData((volume) {
      setState(() {
        _volumeLevel = Volume.fromValue(volume).level;
      });
    });

    if (vm.volume.isPaused) vm.volume.resume();
  }

  String _protocol = '';

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

    if (vm.protocol.isPaused) vm.protocol.resume();
  }

  StreamSubscription connectionSubscription;

  @override
  void initState() {
    super.initState();

    getVolume();
    getProtocol();

    connectionSubscription ??= vm.connectionStatus.listen((isConnected) {
      if (!isConnected)
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) => Scaffold(body: ConnectionPage())));
    });

    if (connectionSubscription.isPaused) {
      connectionSubscription.resume();
    }

    refreshC4Version();
    getDeviceType();
    getServiceStatus(ServiceType.adas);
    getServiceStatus(ServiceType.dms);
    getCanFile();
  }

  getCanFile() {
    var manager = ConfigManager.shared;
    manager.getFile(manager.canFile).then((json) {
      manager.canFile.handleJson(json);
      setState(() {
        var speed = manager.canFile.fakeSpeed ?? -1;
        _fakeSpeed = FakeSpeed(speed).toString();
      });
    }).catchError((error) {
      print(error);
      _fakeSpeed = "获取数据失败";
    });
  }

  setFakeSpeed(int speed) {
    var manager = ConfigManager.shared;
    var origSpeed = manager.canFile.fakeSpeed;
    if (speed == -1) {
      manager.canFile.deleteSpeed();
    } else {
      manager.canFile.setFakeSpeed(speed);
    }
    setState(() {
      _fakeSpeed = "正在设置";
    });
    final tSpeed = FakeSpeed(speed).toString();
    HttpService.shared.writeToFile(manager.canFile.path, jsonEncode(manager.canFile.config))
        .timeout(httpTimeoutInterval).then((result){
          print(result);
      setState(() {
        if (result == MResult.OK) {
          _fakeSpeed = tSpeed;
          reStartAdasService();
        } else {
          _fakeSpeed = "设置失败";
          if (origSpeed == null ) {
            manager.canFile.deleteSpeed();
          } else {
            manager.canFile.setFakeSpeed(origSpeed);
          }
        }
      });
    }).catchError((error){
      setState(() {
        _fakeSpeed = "设置失败";
      });
    });

  }

  reStartAdasService(){
    ServiceManager.shared.stopService(ServiceType.adas).then((result){
      ServiceManager.shared.startService(ServiceType.adas).then((result1){
      });
    }).catchError((){
    });
  }


  refreshState(){

  }

  refreshC4Version() async {
    setState(() {
      _c4Version = "获取中……";
    });
    HttpService.shared
        .getC4Version()
        .timeout(Duration(seconds: 3))
        .then((version) {
      setState(() {
        _c4Version = version;
      });
    }).catchError((e) {
      setState(() {
        _c4Version = "获取失败，请点击重试";
      });
    });
  }

  getDeviceType() {
    setState(() {
      _deviceType = "获取中……";
    });
    HttpService.shared
        .getDeviceType()
        .timeout(Duration(seconds: 3))
        .then((version) {
      setState(() {
        _deviceType = version;
      });
    }).catchError((e) {
      setState(() {
        _deviceType = "获取失败，请点击重试";
      });
    });
  }

  getServiceStatus(ServiceType type) {
    ServiceModel serviceData = ServiceManager.shared.dmsData;
    if (type == ServiceType.adas) {
      serviceData = ServiceManager.shared.adasData;
    }
    setState(() {
      serviceData.status = "正在获取运行状态";
    });
    ServiceManager.shared
        .getServiceStatus(type)
        .timeout(httpTimeoutInterval)
        .then((status) {
      print("get service status: " +
          ServiceManager.shared.nameOfService(type) +
          status);
      setState(() {
        serviceData.isRunning = status == ServiceStatus.running;
        serviceData.status = "获取运行状态成功";
      });
    }).catchError((error) {
      setState(() {
        serviceData.status = "获取运行状态失败";
      });
    });
  }

  setService(ServiceType type, bool isStart) {
    ServiceModel serviceData = ServiceManager.shared.dmsData;
    if (type == ServiceType.adas) {
      serviceData = ServiceManager.shared.adasData;
    }
    setState(() {
      serviceData.status = "正在设置...";
    });
    if (isStart == true) {
      ServiceManager.shared
          .startService(ServiceType.adas)
          .timeout(httpTimeoutInterval)
          .then((success) {
        setState(() {
          if (success == true) {
            serviceData.isRunning = true;
            serviceData.status = "设置成功";
          } else {
            serviceData.isRunning = false;
            serviceData.status = "设置失败";
          }
        });
      }).catchError((error) {
        setState(() {
          serviceData.status = "设置失败";
        });
      });
    } else {
      ServiceManager.shared
          .stopService(ServiceType.adas)
          .timeout(httpTimeoutInterval)
          .then((success) {
        setState(() {
          if (success == true) {
            serviceData.isRunning = false;
            serviceData.status = "设置成功";
          } else {
            serviceData.isRunning = false;
            serviceData.status = "设置失败";
          }
        });
      }).catchError((error) {
        setState(() {
          serviceData.status = "设置失败";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
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
              subtitle: Text('$_volumeLevel'),
              onTap: () {
                return showDialog<double>(
                    context: context,
                    builder: (BuildContext context) {
                      return SliderDialog(
                        value: _volumeLevel.toDouble(),
                        max: 3,
                        divisions: 3,
                        onChange: (double level) {
                          if (level != null) {
                            setState(() {
                              _volumeLevel = level.round();
                              vm.volume = Volume.fromLevel(level.round()).value;
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
                  if (speed == null) return;
                    setFakeSpeed(speed);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.inbox),
              title: Text('设备软件包管理'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            Scaffold(body: PackageManagerPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_enhance),
              title: Text('摄像头调校'),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => Scaffold(body: CameraPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text('设备型号'),
              subtitle: Text(_deviceType),
              onTap: getDeviceType,
            ),
            SwitchListTile(
              title: const Text('ADAS算法运行状态'),
              value: ServiceManager.shared.adasData.isRunning,
              subtitle: Text(ServiceManager.shared.adasData.status),
              onChanged: (bool value) {
                setService(ServiceType.adas, value);
              },
              secondary: const Icon(Icons.code),
            ),
            SwitchListTile(
              title: const Text('DMS算法运行状态'),
              value: ServiceManager.shared.dmsData.isRunning,
              subtitle: Text(ServiceManager.shared.dmsData.status),
              onChanged: (bool value) {
                setService(ServiceType.dms, value);
              },
              secondary: const Icon(Icons.code),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text('C4软件包版本'),
              subtitle: Text(_c4Version),
              onTap: refreshC4Version,
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text('应用版本'),
              subtitle: Text('0.6.0'),
              onTap: () {
                return showDialog<double>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('更新日志'),
                        content: Text('1. 删除天迈协议和天迈直连协议'),
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

                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('已复制到剪贴板'),
                      action: SnackBarAction(label: 'OK', onPressed: () {})));
                },
              ),
            ),
          ]),
        ));
  }

  void onConnectionStatusChanged(bool isConnected) {}

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

  Volume.fromLevel(this.level) : value = [0.0, 0.2, 0.5, 0.8][level];

  Volume.fromValue(this.value) : level = [0.0, 0.2, 0.5, 0.8].indexOf(value);
}
