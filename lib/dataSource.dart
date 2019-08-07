import 'package:flutter/material.dart';

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
              onTap: () {},
            ),
            ListTile(
              title: Text("波特率"),
              onTap: () {},
            ),
          ],
        ));
  }
}
