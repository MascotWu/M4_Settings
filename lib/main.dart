
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADAS安装工具',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        home: Scaffold(
          body: HomePage(title: 'ADAS配置工具'),
        )
    );
  }
}
