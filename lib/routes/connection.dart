import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/main.dart';
import '../models/view_model.dart';

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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    connectionSubscription =
        vm.connectionStatus.listen(onConnectionStatusChanged);
  }

  _openWifiSetting() async {
    AndroidIntent intent = AndroidIntent(action: 'android.settings.SETTINGS');
    await intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Text(
              "Wi-Fi连接设备",
              style: TextStyle(color: Colors.black87, fontSize: 19),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(28, 20, 15, 20),
            child: Text(
              '1、请将手机连接至以下Wi-Fi：\n\n名称：M4_xxxxxxxxxxxxxxxx"\n密码：minieye666\n\n2、点击"连接"按钮,即可进入设备',
              style: TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 40),
            child: RaisedButton(
              child: Text(connectionButtonText),
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 78),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                vm.tellDeviceTheIpOfPhone();

                setState(() {
                  connectionButtonText = '正在连接...';
                });
              },
            ),
          )
        ]);
  }

  onConnectionStatusChanged(bool isConnected) {
    if (isConnected) {
      Navigator.pushReplacementNamed(
          context,
          AppRoute.name.home);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('连接失败!'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          )));

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
