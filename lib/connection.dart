import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';
import 'view_model.dart';

class ConnectionPage extends StatefulWidget {
  createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  ViewModel vm = ViewModel.get();
  var connectionButtonText = '连接';

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription = vm.connectionStatus.listen(onConnectionStatusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 180),
              child: Center(
                child: Text(
                  '请将手机连接到目标设备的热点上\n然后点击"连接"按钮',
                  style: TextStyle(color: Colors.black54, height: 1.3),
                ),
              )),
          FlatButton(
            child: Text(connectionButtonText),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 78),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              vm.tellDeviceTheIpOfPhone();

              setState(() {
                connectionButtonText = '正在连接';
              });
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              '取消登录',
              style: TextStyle(color: Colors.black26, height: 1.3),
            ),
          ),
        ]));
  }

  onConnectionStatusChanged(bool isConnected) {
    if (isConnected) {
      Navigator.pushReplacement(
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
