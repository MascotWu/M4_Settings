import 'package:flutter/material.dart';
import 'package:flutter_app/pickerDialog.dart';

class DataSourcePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DataSourceState();
  }
}

class DataSourceState extends State<DataSourcePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("信号源"),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              title: Text("速度"),
              onTap: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return Picker(
                          title: '请选择信号源', options: ["CAN信号", "模拟信号", "GPS信号"]);
                    });
              },
            ),
            ListTile(
              title: Text("波特率"),
              onTap: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return Picker(title: '请选择波特率', options: ["500k", "250k"]);
                    });
              },
            ),
          ],
        ));
  }
}
