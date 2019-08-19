import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';
import 'view_model.dart';

class ConnectionPage extends StatefulWidget {
  createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  ViewModel vm = ViewModel.get();
  var connectionButtonText = '连接';

  _ConnectionPageState() {
    print('_ConnectionPageState 构造函数');
  }

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    print('initState');
    subscription = vm.connectionStatus.listen(onConnectionStatusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Text('请将手机连接到目标设备的热点上，然后点击"连接"按钮'),
          FlatButton(
            child: Text(connectionButtonText),
            onPressed: () {
              vm.waitingForDeviceToConnect();
              vm.tellDeviceTheIpOfPhone();

              setState(() {
                connectionButtonText = '正在连接';
              });
            },
          )
        ]));
  }

  onConnectionStatusChanged(bool isConnected) {
    print({'onConnectionStatusChanged': isConnected});

    if (isConnected) {
      subscription.cancel();
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => HomePage(title: 'M4配置工具')));
    } else {
      Fluttertoast.showToast(
        msg: "连接失败，请确定手机的WiFi连接上设备的热点上",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );

      setState(() {
        connectionButtonText = '连接';
      });
    }
  }
}
