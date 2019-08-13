import 'package:flutter/material.dart';
import 'package:flutter_app/picker_dialog.dart';

import 'view_model.dart';

class DataSourcePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DataSourceState();
  }
}

class DataSourceState extends State<DataSourcePage> {
  @override
  Widget build(BuildContext context) {
    ViewModel vm = ViewModel.get();
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
                      return Picker(title: '请选择信号源', options: [
                        {'title': "CAN信号", 'value': 1},
                        {'title': "模拟信号", 'value': 2},
                        {'title': "GPS信号", 'value': 3},
                      ]);
                    });
              },
            ),
            ListTile(
              title: Text("波特率"),
              onTap: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return Picker(title: '请选择波特率', options: [
                        {'title': "500k"},
                        {'title': "250k"}
                      ]);
                    }).then((baudRate) {
                  if (baudRate != null) vm.addOrUpdateBaudRate(baudRate);
                });
              },
            ),
          ],
        ));
  }
}
