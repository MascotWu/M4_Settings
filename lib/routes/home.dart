import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/common_variable.dart';
import 'package:flutter_app/common/http_service.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/camera_position_model.dart';
import 'package:flutter_app/models/view_model.dart';
import 'package:flutter_app/routes/camera.dart';
import 'package:flutter_app/routes/camera_settings.dart';
import 'package:flutter_app/routes/data_source.dart';
import 'package:flutter_app/routes/package_manager.dart';
import 'package:flutter_app/routes/param_settings.dart';

final httpTimeoutInterval = HttpService.timeoutInterval;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ViewModel vm = ViewModel.get();

  String _c4Version = CommonVariable.getting;

  String _deviceType = "点击重新获取";
  String _deviceId = "点击重新获取";

  String _cameraPositionState = "";
  String _cameraSetState = "";


  StreamSubscription connectionSubscription;

  @override
  void initState() {
    super.initState();

    connectionSubscription ??= vm.connectionStatus.listen((isConnected) {
      if (!isConnected)
        Navigator.pushReplacementNamed(context, AppRoute.name.connect);
    });

    if (connectionSubscription.isPaused) {
      connectionSubscription.resume();
    }

    refreshC4Version();
    getDeviceType();
    getDeviceId();
    getServiceStatus(ServiceType.adas);
    getServiceStatus(ServiceType.dms);
    getCameraPosition();
  }

  bool _isNewVersion(String first, String second) {
    final ver1 = first.split(".");
    final ver2 = second.split(".");
    int maxLen = ver1.length;
    if (maxLen < ver2.length) {
      maxLen = ver2.length;
    }
    for (int i = 0; i < maxLen; i++) {
      int n1 = i < ver1.length ? int.parse(ver1[i]) : 0;
      int n2 = i < ver2.length ? int.parse(ver2[i]) : 0;
      if (n1 > n2) {
        return true;
      }
    }
    return false;
  }

  refreshC4Version() {
    setState(() {
      _c4Version = CommonVariable.getting;
    });
    HttpService.shared
        .getC4Version()
        .timeout(httpTimeoutInterval)
        .then((version) {
      final minRequiredC4Ver = "1.5.24";
      bool needUpdate = _isNewVersion(minRequiredC4Ver, version);
      var msg = version;
      if (needUpdate) {
        msg += "  (请升级M4版本)";
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("M4更新提示"),
                content: Text("M4版本过低，请将设备更新到$minRequiredC4Ver以上"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("确定"),
                    onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                  ),
                ],
              );
            });
      }
      setState(() {
        _c4Version = msg;
      });
    }).catchError((e) {
      print(e);
      setState(() {
        _c4Version = CommonVariable.getFailedRetry;
      });
    });
  }

  getDeviceId() {
    setState(() {
      _deviceId = CommonVariable.getting;
    });
    HttpService.shared
        .getDeviceId()
        .timeout(httpTimeoutInterval)
        .then((version) {
      setState(() {
        _deviceId = version;
      });
    }).catchError((e) {
      setState(() {
        _deviceId = CommonVariable.getFailedRetry;
      });
    });
  }

  getDeviceType() {
    setState(() {
      _deviceType = CommonVariable.getting;
    });
    HttpService.shared
        .getDeviceType()
        .timeout(httpTimeoutInterval)
        .then((version) {
      setState(() {
        _deviceType = version;
      });
    }).catchError((e) {
      setState(() {
        _deviceType = CommonVariable.getFailedRetry;
      });
    });
  }

  getServiceStatus(ServiceType type) {
    ServiceModel serviceData = ServiceManager.shared.dmsData;
    if (type == ServiceType.adas) {
      serviceData = ServiceManager.shared.adasData;
    }
    setState(() {
      serviceData.status = CommonVariable.getting;
    });
    ServiceManager.shared
        .getServiceStatus(type)
        .timeout(httpTimeoutInterval)
        .then((status) {
      print("get service status: " +
          ServiceManager.shared.nameOfService(type) +
          " " +
          status);
      setState(() {
        serviceData.isRunning = status == ServiceStatus.running;
        serviceData.status = CommonVariable.getSuccess;
      });
    }).catchError((error) {
      setState(() {
        serviceData.status = CommonVariable.getFailed;
      });
    });
  }

  setService(ServiceType type, bool isStart) {
    ServiceModel serviceData = ServiceManager.shared.dmsData;
    var method = isStart
        ? ServiceManager.shared.startService
        : ServiceManager.shared.stopService;
    if (type == ServiceType.adas) {
      serviceData = ServiceManager.shared.adasData;
    }
    setState(() {
      serviceData.status = CommonVariable.settingUp;
    });
    method(type).timeout(httpTimeoutInterval).then((success) {
      setState(() {
        serviceData.isRunning = isStart ? success : !success;
        serviceData.status =
            success ? CommonVariable.setSuccess : CommonVariable.setFailedRetry;
      });
    }).catchError((e) {
      setState(() {
        serviceData.isRunning = !isStart;
        serviceData.status = CommonVariable.setFailedRetry;
      });
    });
  }

  getCameraOriginalPosition() {
    if (_cameraPositionState == CommonVariable.getting) {
      return;
    }
    setState(() {
      _cameraPositionState = CommonVariable.getting;
    });
    var position = CameraOriginalPosition();
    HttpService.shared
        .getValueKey(position.toJson().keys.toList())
        .timeout(HttpService.timeoutInterval)
        .then((value) {
      print(value);
      CameraOriginalPosition position = value.success
          ? CameraOriginalPosition.fromJson(json.decode(value.result))
          : CameraOriginalPosition();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Scaffold(body: CameraSettingsPage(position))));
      setState(() {
        _cameraPositionState = _cameraSetState;
      });
    }).catchError((e) {
      setState(() {
        _cameraPositionState = CommonVariable.getFailed;
      });
    });
  }

  getCameraPosition() {
    if (_cameraSetState == CommonVariable.getting) {
      return;
    }
    HttpService.shared
        .getCameraPosition()
        .timeout(HttpService.timeoutInterval)
        .then((value) {
      print(value);
        setState(() {
          var position = value.success ? CameraPosition.fromJson(jsonDecode(value.result)) : CameraPosition();
          _cameraSetState = position.carWidth == null ? "未设置" : "已设置";
          if (_cameraPositionState.isEmpty) {
            _cameraPositionState = _cameraSetState;
          }
        });
    }).catchError((e) {
      setState(() {
        _cameraSetState = CommonVariable.getFailed;
      });
    });
  }

  bool _isFoldList = true;

  Widget _buildBody() {
    var children = <Widget>[
      ListTile(
          title: Text('安装向导'),
          subtitle: Text("车辆状态信号源、ADAS安装参数、摄像头标定"),
          trailing: RotatedBox(
            quarterTurns: _isFoldList ? 0 : 1,
            child: Icon(Icons.navigate_next),
          ),
          onTap: () {
            setState(() {
              _isFoldList = !_isFoldList;
            });
          })
    ];
    var padding = EdgeInsets.fromLTRB(40, 0, 15, 0);
    if (!_isFoldList) {
      children.addAll(<Widget>[
        ListTile(
          contentPadding: padding,
          title: Text('车辆状态信号源'),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => Scaffold(body: DataSourcePage())));
          },
        ),
        ListTile(
          contentPadding: padding,
          title: Text('ADAS安装参数'),
          subtitle: Text(_cameraPositionState),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            getCameraOriginalPosition();
          },
        ),
        ListTile(
          contentPadding: padding,
          title: Text('摄像头标定'),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => Scaffold(body: CameraPage())));
          },
        ),
      ]);
    }

    var installWidget = Column(children: children);

    return SingleChildScrollView(
      child: Column(children: <Widget>[
        ListTile(
          title: Text('当前设备：' + _deviceId),
          onTap: getDeviceId,
        ),
        ListTile(
          title: Text('设备型号：' + _deviceType),
          onTap: getDeviceType,
        ),
        ListTile(
          title: Text('通讯软件(C4)版本：' + _c4Version),
          onTap: refreshC4Version,
        ),
        Container(
          color: Colors.grey[350],
          height: 1,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
        SwitchListTile(
          title: const Text('ADAS状态'),
          value: ServiceManager.shared.adasData.isRunning,
          subtitle: Text(ServiceManager.shared.adasData.status),
          onChanged: (bool value) {
            setService(ServiceType.adas, value);
          },
        ),
        SwitchListTile(
          title: const Text('DMS状态'),
          value: ServiceManager.shared.dmsData.isRunning,
          subtitle: Text(ServiceManager.shared.dmsData.status),
          onChanged: (bool value) {
            setService(ServiceType.dms, value);
          },
        ),
        Container(
          color: Colors.grey[350],
          height: 1,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
        installWidget,
        ListTile(
          title: Text('参数设置'),
          subtitle: Text("音量、ADAS、DMS参数、协议配置"),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => Scaffold(body: ParamSettings())));
          },
        ),
        ListTile(
          title: Text('软件包管理'),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        Scaffold(body: PackageManagerPage())));
          },
        ),
        SizedBox(
          height: 40,
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  void onConnectionStatusChanged(bool isConnected) {}

  @override
  void dispose() {
    super.dispose();

    connectionSubscription.pause();
  }
}
