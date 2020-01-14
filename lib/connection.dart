import 'dart:async';

import 'package:flutter/material.dart';

import 'home.dart';
import 'view_model.dart';

class ConnectionPage extends StatefulWidget {
  createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  ViewModel vm = ViewModel.get();
  var connectionButtonText = '连接';

  StreamSubscription connectionSubscription;

  @override
  void initState() {
    super.initState();

    connectionSubscription =
        vm.connectionStatus.listen(onConnectionStatusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 180),
              child: Center(
                child: Text(
                  '请将手机Wi-Fi连接至"M4_xxxxxxxxxxxxxxxx"\nWi-Fi默认密码为：minieye666\n\n然后点击"连接"按钮',
                  style: TextStyle(color: Colors.black54, height: 1.3),
                  textAlign: TextAlign.center,
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
                connectionButtonText = '正在连接...';
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
            ]);
  }

  onConnectionStatusChanged(bool isConnected) {
    if (isConnected) {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  Scaffold(body: HomePage(title: 'ADAS配置工具'))));
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('连接失败!'), action: SnackBarAction(
            label: 'OK', onPressed: () {},)));

      setState(() {
        connectionButtonText = '连接';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    connectionSubscription.cancel();
  }
}
