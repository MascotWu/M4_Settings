import 'package:flutter/material.dart';
import 'package:flutter_app/data_source.dart';
import 'package:flutter_app/protocol.dart';
import 'package:flutter_app/slider_dialog.dart';

import 'alert_settings.dart';
import 'camera.dart';
import 'camera_settings.dart';
import 'connection.dart';
import 'picker_dialog.dart';
import 'view_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _textOfConnectButton = "";

  ViewModel vm = ViewModel.get();

  double _volume;

  @override
  Widget build(BuildContext context) {
    vm.isConnectedWithDevice().listen(onConnectionStatusChanged);
    _volume = vm.volume ?? 0.7;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text(_textOfConnectButton),
            onPressed: () {},
          )
        ],
      ),
      body: Column(children: <Widget>[
        ListTile(
            leading: FlutterLogo(),
            title: Text('车型'),
            onTap: () {
              return showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Picker(title: '请选择车型', options: cars);
                  });
            }),
        ListTile(
          leading: FlutterLogo(),
          title: Text('信号源'),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new DataSourcePage()));
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('摄像头设置'),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new CameraSettingsPage()));
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('报警'),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new AlertSettingsPage()));
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('协议'),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ProtocolPage()));
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('音量'),
          onTap: () {
            setState(() {
              _volume = vm.volume;
            });
            return showDialog<double>(
                context: context,
                builder: (BuildContext context) {
                  return SliderDialog(
                    value: _volume,
                    max: 0.8,
                    divisions: 3,
                    onChange: (volume) {
                      print({'volume': volume});
                      if (volume != null) {
                        vm.setVolume(volume);
                        setState(() {
                          _volume = volume;
                        });
                      }
                    },
                  );
                });
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('假速度'),
          onTap: () {
            return showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return Picker(
                    title: '请选择速度',
                    options: speeds,
                  );
                }).then((speed) {
              print({'speed': speed});

              if (speed == -1)
                vm.deleteSpeed();
              else if (speed != null) {
                vm.addOrUpdateSpeed(speed);
              }
            });
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('摄像头调校'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new CameraPage()));
          },
        ),
      ]),
    );
  }

  void onConnectionStatusChanged(bool isConnected) {
    print("is connected $isConnected");
    if (!isConnected) {
      Navigator.pop(context);
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => ConnectionPage()));
    }
  }

  List<Map<String, dynamic>> speeds = [
    {'title': '无', 'value': -1},
    {'title': '20km/h', 'value': 20},
    {'title': '40km/h', 'value': 40},
    {'title': '60km/h', 'value': 60},
    {'title': '120km/h', 'value': 120},
  ];

  List<Map<String, dynamic>> cars = [
    {'title': '讴歌', 'value': 10},
    {'title': '亚历山大∙丹尼斯', 'value': 10},
    {'title': '阿尔法·罗密欧', 'value': 10},
    {'title': '奥迪', 'value': 10},
    {'title': '北京汽车', 'value': 10},
    {'title': '宾利', 'value': 10},
    {'title': '英国汽车公司', 'value': 10},
    {'title': '宝马', 'value': 10},
    {'title': '别克', 'value': 10},
    {'title': '比亚迪', 'value': 10},
    {'title': '集瑞联合', 'value': 10},
    {'title': '凯迪拉克', 'value': 10},
    {'title': '长安', 'value': 10},
    {'title': '奇瑞', 'value': 10},
    {'title': '雪佛兰', 'value': 10},
    {'title': '克莱斯勒', 'value': 10},
    {'title': '雪铁龙', 'value': 10},
    {'title': '达西亚', 'value': 10},
    {'title': '大宇', 'value': 10},
    {'title': '达夫', 'value': 10},
    {'title': '大发', 'value': 10},
    {'title': '道奇', 'value': 10},
    {'title': '东风', 'value': 10},
    {'title': '中国第一汽车集团公司', 'value': 10},
    {'title': '法拉利', 'value': 10},
    {'title': '菲亚特', 'value': 10},
    {'title': '福特', 'value': 10},
    {'title': '福田戴姆勒', 'value': 10},
    {'title': '福莱纳', 'value': 10},
    {'title': '广汽', 'value': 10},
    {'title': '吉列格', 'value': 10},
    {'title': '吉姆西', 'value': 10},
    {'title': '金旅', 'value': 10},
    {'title': '长城', 'value': 10},
    {'title': '哈弗', 'value': 10},
    {'title': '金龙-海格', 'value': 10},
    {'title': '日野', 'value': 10},
    {'title': '霍顿', 'value': 10},
    {'title': '本田', 'value': 10},
    {'title': '现代', 'value': 10},
    {'title': '现代卡车', 'value': 10},
    {'title': '英菲尼迪', 'value': 10},
    {'title': '国际', 'value': 10},
    {'title': '五十铃', 'value': 10},
    {'title': '依维柯', 'value': 10},
    {'title': '捷豹', 'value': 10},
    {'title': '吉普', 'value': 10},
    {'title': '肯沃斯', 'value': 10},
    {'title': '起亚', 'value': 10},
    {'title': '金龙联合汽车', 'value': 10},
    {'title': '蓝旗亚', 'value': 10},
    {'title': '路虎', 'value': 10},
    {'title': '雷克萨斯', 'value': 10},
    {'title': '林肯', 'value': 10},
    {'title': '曼恩', 'value': 10},
    {'title': '马自达', 'value': 10},
    {'title': '梅赛德斯-奔驰', 'value': 10},
    {'title': '梅赛德斯-奔驰(卡车/巴士)', 'value': 10},
    {'title': '名爵', 'value': 10},
    {'title': '迷你', 'value': 10},
    {'title': '三菱', 'value': 10},
    {'title': '日产', 'value': 10},
    {'title': '日产卡车', 'value': 10},
    {'title': '欧宝', 'value': 10},
    {'title': '彼得比尔特', 'value': 10},
    {'title': '标致', 'value': 10},
    {'title': '庞蒂克', 'value': 10},
    {'title': '保时捷', 'value': 10},
    {'title': '普雷沃斯特', 'value': 10},
    {'title': '宝腾', 'value': 10},
    {'title': '雷诺', 'value': 10},
    {'title': '荣威', 'value': 10},
    {'title': '萨博', 'value': 10},
    {'title': '斯堪尼亚', 'value': 10},
    {'title': '赛恩', 'value': 10},
    {'title': '西亚特', 'value': 10},
    {'title': '上汽通用五菱', 'value': 10},
    {'title': '陕西', 'value': 10},
    {'title': '斯柯达', 'value': 10},
    {'title': '索拉瑞斯', 'value': 10},
    {'title': '双龙', 'value': 10},
    {'title': '斯巴鲁', 'value': 10},
    {'title': '铃木', 'value': 10},
    {'title': '塔塔', 'value': 10},
    {'title': '特斯拉', 'value': 10},
    {'title': '丰田', 'value': 10},
    {'title': '范胡尔', 'value': 10},
    {'title': '大众', 'value': 10},
    {'title': '沃尔沃', 'value': 10},
    {'title': '沃尔沃 巴士/卡车', 'value': 10},
    {'title': '西星', 'value': 10},
    {'title': '温尼巴格', 'value': 10},
    {'title': '青年汽车', 'value': 10},
    {'title': '宇通', 'value': 10},
  ];
}
