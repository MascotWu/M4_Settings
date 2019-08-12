import 'package:flutter/material.dart';
import 'package:flutter_app/dataSource.dart';
import 'package:flutter_app/protocol.dart';

import 'MainViewModel.dart';
import 'alert.dart';
import 'camera.dart';
import 'pickerDialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _volume;
  double _speed = 0;
  var _textOfConnectButton = "";

  var vm = new MainViewModel();

  @override
  Widget build(BuildContext context) {
    vm.establishConnection();
    vm.isConnectedWithDevice().listen(onConnectionStatusChanged);

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
                  barrierDismissible: false, // user must tap button!
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
          title: Text('摄像头'),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new CameraPage(
                          title: '摄像头',
                        )));
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('报警'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new AlertPage()));
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
            return showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: <Widget>[
                      Slider(
                        value: 0.3,
                        onChanged: (volume) {},
                      )
                    ],
                  );
                });
          },
        ),
        ListTile(
          leading: FlutterLogo(),
          title: Text('假速度'),
          onTap: () {
            return showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: <Widget>[
                      Slider(
                        value: 0.618,
                        onChanged: (speed) {
                          setState(() {
                            _speed = speed;
                          });
                        },
                      )
                    ],
                  );
                });
          },
        ),
      ]),
    );
  }

  void onConnectionStatusChanged(bool isConnected) {
    _textOfConnectButton = isConnected ? '已连接' : '连接';
  }

  List<String> cars = [
    '讴歌',
    '亚历山大∙丹尼斯',
    '阿尔法·罗密欧',
    '奥迪',
    '北京汽车',
    '宾利',
    '英国汽车公司',
    '宝马',
    '别克',
    '比亚迪',
    '集瑞联合',
    '凯迪拉克',
    '长安',
    '奇瑞',
    '雪佛兰',
    '克莱斯勒',
    '雪铁龙',
    '达西亚',
    '大宇',
    '达夫',
    '大发',
    '道奇',
    '东风',
    '中国第一汽车集团公司',
    '法拉利',
    '菲亚特',
    '福特',
    '福田戴姆勒',
    '福莱纳',
    '广汽',
    '吉列格',
    '吉姆西',
    '金旅',
    '长城',
    '哈弗',
    '金龙-海格',
    '日野',
    '霍顿',
    '本田',
    '现代',
    '现代卡车',
    '英菲尼迪',
    '国际',
    '五十铃',
    '依维柯',
    '捷豹',
    '吉普',
    '肯沃斯',
    '起亚',
    '金龙联合汽车',
    '蓝旗亚',
    '路虎',
    '雷克萨斯',
    '林肯',
    '曼恩',
    '马自达',
    '梅赛德斯-奔驰',
    '梅赛德斯-奔驰(卡车/巴士)',
    '名爵',
    '迷你',
    '三菱',
    '日产',
    '日产卡车',
    '欧宝',
    '彼得比尔特',
    '标致',
    '庞蒂克',
    '保时捷',
    '普雷沃斯特',
    '宝腾',
    '雷诺',
    '荣威',
    '萨博',
    '斯堪尼亚',
    '赛恩',
    '西亚特',
    '上汽通用五菱',
    '陕西',
    '斯柯达',
    '索拉瑞斯',
    '双龙',
    '斯巴鲁',
    '铃木',
    '塔塔',
    '特斯拉',
    '丰田',
    '范胡尔',
    '大众',
    '沃尔沃',
    '沃尔沃 巴士/卡车',
    '西星',
    '温尼巴格',
    '青年汽车',
    '宇通',
  ];
}
