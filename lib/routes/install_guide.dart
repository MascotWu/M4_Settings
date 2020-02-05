
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/http_service.dart';
import 'data_source.dart';
import 'camera.dart';
import 'camera_settings.dart';

class InstallGuide extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _InstallGuideState();
  }

}

class _InstallGuideState extends State<InstallGuide> {
  var _cameraState = "";

  cameraSettingAction() {
    var manager = ConfigManager.shared;
    setState(() {
      _cameraState = "获取数据中";
    });
    Future.wait([
      manager.getFile(manager.detectFile),
      manager.getFile(manager.carFile)
    ]).then((results) {
      print(results);
      setState(() {
        _cameraState = "";
      });

      manager.detectFile.setConfig(results[0]);
      manager.carFile.setConfig(results[1]);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => Scaffold(body: CameraSettingsPage())));
    }).catchError((error) {
      print("获取配置文件失败，请重试");
      print(error);
      setState(() {
        _cameraState = "获取数据失败，请重试点击";
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("安装向导"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('车辆状态信号源'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          Scaffold(body: DataSourcePage())));
            },
          ),
          ListTile(
            title: Text('ADAS安装参数'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          Scaffold(body: CameraSettingsPage())));
            },
          ),
          ListTile(
            title: Text('摄像头标定'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Scaffold(body: CameraPage())));
            },
          ),
        ],
      ),
    );
  }
}
