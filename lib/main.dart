
import 'package:flutter/material.dart';

import 'connection.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M4安装工具',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConnectionPage(),
    );
  }
}
