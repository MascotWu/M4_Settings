import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/http_service.dart';
import 'package:flutter_app/widgets/picker_dialog.dart';
import '../models/view_model.dart';

class FakeSpeed {
  int speed;
  static final int maxSpeed = 60;
  static final int grade = 3;

  FakeSpeed(this.speed);

  bool isOn(){
    return speed == null || speed <= 0 ? false : true;
  }

  @override
  String toString() {
    return isOn() ? '速度为$speed km/h' : '';
  }
}



class DataSourcePage extends StatefulWidget {
  createState() => DataSourceState();
}

class DataSourceState extends State<DataSourcePage> {

  final httpTimeoutInterval = HttpService.timeoutInterval;

  List<Map<String, dynamic>> speeds = [
    {'title': '无', 'value': -1},
    {'title': '20 km/h', 'value': 20},
    {'title': '40 km/h', 'value': 40},
    {'title': '60 km/h', 'value': 60},
  ];

  var _speed = FakeSpeed(0);

  getCanFile() {

    var manager = ConfigManager.shared;
    manager.getFile(manager.canFile).then((data) {
      manager.canFile.setConfig(data);
      setState(() {
        var speed = manager.canFile.fakeSpeed ?? 0;
        _speed.speed = speed;
      });
    }).catchError((error) {
      print(error);
    });
  }

  setFakeSpeed(int speed) {
    var manager = ConfigManager.shared;
    var origSpeed = manager.canFile.fakeSpeed;
    if (speed <= 0) {
      manager.canFile.deleteSpeed();
    } else {
      manager.canFile.setFakeSpeed(speed);
    }
    setState(() {
      _speed.speed = speed;
    });
    HttpService.shared
        .writeToFile(manager.canFile.path, jsonEncode(manager.canFile.config))
        .timeout(httpTimeoutInterval)
        .then((result) {
      setState(() {
        print(result == MResult.OK);
        if (result == MResult.OK) {
          reStartAdasService();
        } else {
          _speed.speed = origSpeed;
          if (origSpeed == null) {
            manager.canFile.deleteSpeed();
          } else {
            manager.canFile.setFakeSpeed(origSpeed);
          }
        }
      });
    }).catchError((error) {
      print("set fake speed error");
      print(error);
      setState(() {
        _speed.speed = origSpeed;
      });
    });
  }

  reStartAdasService() {
    Future.wait([
      ServiceManager.shared.stopService(ServiceType.adas),
      delayStartService(ServiceType.adas)
    ]).then((results) {
      print(results[0]);
      print(results[1]);
      print("重启ADAS成功");
    }).catchError((e) {
      print(e);
      print("重启ADAS失败");
    });
  }

  Future<bool> delayStartService(ServiceType type) async {
    await Future.delayed(Duration(seconds: 5));
    return ServiceManager.shared.startService(type);
  }

  Widget _buildBody(){
    ViewModel vm = ViewModel.get();

    List<Widget> widgets = <Widget>[
      ListTile(
        title: Text("速度信号源"),
        trailing: Icon(Icons.navigate_next),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      Scaffold(body: SpeedDataSourcePage())));
        },
      ),
      ListTile(
        title: Text("信号源波特率设置"),
        onTap: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return Picker(title: '请选择波特率', options: [
                  {'title': "500k"},
                  {'title': "250k"}
                ]);
              }).then((baudRate) {
            if (baudRate != null) {
              vm.addOrUpdateBaudRate(baudRate);
            }
          });
        },
      ),
      Container(
        color: Colors.grey[350],
        height: 1,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      ),
      SwitchListTile(
          title: Text('设置假速度(测试用)'),
          subtitle: Text(_speed.toString()),
          value: _speed.isOn(),
          onChanged: (value){
            if (value) {
              setFakeSpeed(20);
            } else {
              setFakeSpeed(0);
            }
          }),
    ];

    if (_speed.isOn()) {
       widgets.add(Padding(
         padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
         child: Slider(
             value: _speed.speed.toDouble(),
             max: FakeSpeed.maxSpeed.toDouble(),
             divisions: FakeSpeed.grade,
             onChanged: (value) {
               setFakeSpeed(value.toInt());
             }),
       ));
    }

    return Column(children: widgets);
  }

  @override
  void initState() {
    super.initState();
    getCanFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("车辆状态信号源"),
        ),
        body: _buildBody()
    );
  }
}

class SpeedDataSourcePage extends StatefulWidget {
  createState() => _SpeedDataSource();
}

class _SpeedDataSource extends State<SpeedDataSourcePage> {
  ViewModel vm;

  _SpeedDataSource() {
    vm = ViewModel.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("速度信号源选择"),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.memory),
              title: Text("CAN信号"),
              onTap: () {
                showDialog<Map>(
                    context: context,
                    builder: (BuildContext context) {
                      return Picker(
                          title: '请选择车型', options: createCarOptions());
                    }).then((result) {
                  if (result != null) {
                    vm.addOrUpdate(vm.canInputJsonFile, result);
                    vm.addOrUpdate(vm.canInputJsonFile, analogDisable);
                    Navigator.pop(context);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.tap_and_play),
              title: Text("模拟信号"),
              onTap: () {
                vm.addOrUpdate(vm.canInputJsonFile, analogConfig);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.gps_fixed),
              title: Text("GPS信号"),
              onTap: () {
                vm.addOrUpdate(vm.canInputJsonFile, gpsConfig);
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  createCarOptions() {
    print(cars.keys);
    List<Map<String, dynamic>> options = [];
    var keys = cars.keys.toList();
    for (var i = 0; i < keys.length; i++)
      options.add({'title': keys[i], 'value': cars[keys[i]]});
    return options;
  }

  var gpsConfig = {
    'speed': {
      "can_id": "0x20000000",
      "byte_order": 0,
      "start_bit": 8,
      "size": 16,
      "min": 0,
      "max": 512,
      "factor": 1,
      "offset": 0
    },
    "m4_analog": {
      "aspeed": {"ratio": 0, "enable": false},
      "aturnlamp": {"enable": false, "polarity": 1}
    }
  };

  var analogDisable = {"m4_analog": {
    "aspeed": {"ratio": 0, "enable": false},
    "aturnlamp": {"enable": false, "polarity": 1}
  }};

  var analogConfig = {
    'speed': {
      "can_id": "0x783",
      "byte_order": 0,
      "start_bit": 8,
      "size": 16,
      "min": 0,
      "max": 512,
      "factor": 1,
      "offset": 0
    },
    'left_turn': {
      "can_id": "0x20000000",
      "byte_order": 0,
      "start_bit": 0,
      "size": 1,
      "min": 0,
      "max": 1,
      "factor": 1,
      "offset": 0
    },
    'right_turn': {
      "can_id": "0x20000000",
      "byte_order": 0,
      "start_bit": 1,
      "size": 1,
      "min": 0,
      "max": 1,
      "factor": 1,
      "offset": 0
    },
    "m4_analog": {
      "aspeed": {"ratio": 0, "enable": true},
      "aturnlamp": {"enable": false, "polarity": 1}
    }
  };

  var cars = {
    "黄海 | 纯电动 | 2019": {
      "speed": {
        "max": 1142.721115519835,
        "min": 0,
        "size": 15,
        "can_id": "0x18ef01ef",
        "factor": 0.03487308091796371,
        "offset": 0,
        "start_bit": 35,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18fef217",
        "factor": 1,
        "offset": 0,
        "start_bit": 18,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18fef217",
        "factor": 1,
        "offset": 0,
        "start_bit": 19,
        "byte_order": 0
      }
    },
    "黄海 | 6109 | 2019": {
      "speed": {
        "max": 1142.721115519835,
        "min": 0,
        "size": 15,
        "can_id": "0x18ef01ef",
        "factor": 0.03487308091796371,
        "offset": 0,
        "start_bit": 35,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18fef217",
        "factor": 1,
        "offset": 0,
        "start_bit": 18,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18fef217",
        "factor": 1,
        "offset": 0,
        "start_bit": 19,
        "byte_order": 0
      }
    },
    "比亚迪 | K7 | 2016": {
      "speed": {
        "max": 65535,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEF100",
        "factor": 0.0039,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 10,
        "byte_order": 0
      }
    },
    "比亚迪 | K7g | 2019": {
      "speed": {
        "max": 65535,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEF100",
        "factor": 0.0039,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 10,
        "byte_order": 0
      }
    },
    "比亚迪 | K8 | 2016": {
      "speed": {
        "max": 512,
        "min": -20,
        "size": 16,
        "can_id": "0x18FEF100",
        "factor": 0.003906,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0,
        "is_unsigned": false
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 10,
        "byte_order": 0
      }
    },
    "比亚迪 | C8 | 2016": {
      "speed": {
        "max": 65535,
        "min": 0,
        "size": 16,
        "can_id": "0x18F31100",
        "factor": 0.06875,
        "offset": 0,
        "start_bit": 24,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 10,
        "byte_order": 0
      }
    },
    "比亚迪 | K7 | 2019": {
      "speed": {
        "max": 65535,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEF100",
        "factor": 0.0039,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 10,
        "byte_order": 0
      }
    },
    "比亚迪 | k8 | 2015": {
      "speed": {
        "max": 65535,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEBF0B",
        "factor": 0.00390625,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 1
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 10,
        "byte_order": 0
      }
    },
    "比亚迪 | K8 | 2019": {
      "speed": {
        "max": 65535,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEBF0B",
        "factor": 0.00390625,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 1
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "start_bit": 10,
        "byte_order": 0
      }
    },
    "比亚迪 | K9 | 2013": {
      "speed": {
        "max": 5047.44472284689,
        "min": 0,
        "size": 16,
        "can_id": "0x456",
        "factor": 0.07701789433054947,
        "offset": 0,
        "start_bit": 24,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x12E",
        "factor": 1,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x12E",
        "factor": 1,
        "offset": 0,
        "start_bit": 17,
        "byte_order": 0
      }
    },
    "南京金龙 | NJL0968NV7 | 2019": {
      "speed": {
        "max": 256,
        "min": 0,
        "size": 16,
        "can_id": "0x18F101D0 ",
        "factor": 0.003906,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F40117 ",
        "factor": 1,
        "offset": 0,
        "start_bit": 15,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F40117",
        "factor": 1,
        "offset": 0,
        "start_bit": 14,
        "byte_order": 0
      }
    },
    "南京金龙 | NJL0968NK7 | 2019": {
      "speed": {
        "max": 256,
        "min": 0,
        "size": 16,
        "can_id": "0x18F101D0 ",
        "factor": 0.003906,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F40117 ",
        "factor": 1,
        "offset": 0,
        "start_bit": 15,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F40117",
        "factor": 1,
        "offset": 0,
        "start_bit": 14,
        "byte_order": 0
      }
    },
    "宇通 | ZK6125BEVG75 | 2018": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FF0824",
        "factor": 1.0008,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | 6201 | 2019": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEF121",
        "factor": 0.00390625,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 1
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | e10 | 2018": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FF0824",
        "factor": 1.0008,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | 6125 | 2019": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEF121",
        "factor": 0.00390625,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 1
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | E8 | 2017": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FEF121",
        "factor": 0.9972,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | 6805 | 2016": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FF0824",
        "factor": 1.0008,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | e8 | 2018": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FEF121",
        "factor": 0.9972,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | ZK6805 | 2015": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FF0824",
        "factor": 1.0008,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | 6805 | 2015": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FF0824",
        "factor": 1.0008,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "宇通 | 6850 | 2016": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 8,
        "can_id": "0x18FF0824",
        "factor": 1.0008,
        "offset": 0,
        "start_bit": 16,
        "byte_order": 0
      },
      "left_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 32,
        "byte_order": 0
      },
      "right_turn": {
        "max": 512,
        "min": 0,
        "size": 1,
        "can_id": "0x18A70017",
        "factor": 1,
        "offset": 0,
        "start_bit": 34,
        "byte_order": 0
      }
    },
    "开沃 | NJL6859EV7 | 2019": {
      "speed": {
        "max": 256,
        "min": 0,
        "size": 16,
        "can_id": "0x18F101D0 ",
        "factor": 0.003906,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F40117 ",
        "factor": 1,
        "offset": 0,
        "start_bit": 15,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F40117",
        "factor": 1,
        "offset": 0,
        "start_bit": 14,
        "byte_order": 0
      }
    },
    "速达 | 速达 | 2019": {
      "speed": {
        "max": 220,
        "min": 0,
        "size": 16,
        "can_id": "0x441",
        "factor": 0.01,
        "offset": 0,
        "start_bit": 0,
        "byte_order": 1
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x422",
        "factor": 1,
        "offset": 0,
        "start_bit": 2,
        "byte_order": 1
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x422",
        "factor": 1,
        "offset": 0,
        "start_bit": 3,
        "byte_order": 1
      }
    },
    "中通 | LCK6120EVG3A1 | 2019": {
      "speed": {
        "max": 255,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEF117",
        "factor": 0.00390625,
        "offset": 0,
        "start_bit": 8,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F00117",
        "factor": 1,
        "offset": 0,
        "start_bit": 27,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F00117",
        "factor": 1,
        "offset": 0,
        "start_bit": 26,
        "byte_order": 0
      }
    },
    "中兴 | GTZ6859BEVB2 | 2019": {
      "speed": {
        "max": 512,
        "min": 0,
        "size": 16,
        "can_id": "0x18F15217 ",
        "factor": 0.1,
        "offset": 0,
        "start_bit": 24,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F15317 ",
        "factor": 1,
        "offset": 0,
        "start_bit": 6,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18F15317 ",
        "factor": 1,
        "offset": 0,
        "start_bit": 4,
        "byte_order": 0
      }
    },
    "中车 | v08 | 2019": {
      "speed": {
        "max": 1296.586191214897,
        "min": 0,
        "size": 16,
        "can_id": "0xc03a1a7",
        "factor": 0.01978433519309841,
        "offset": 0,
        "start_bit": 48,
        "byte_order": 0
      },
      "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0xc19a7a1",
        "factor": 1,
        "offset": 0,
        "start_bit": 15,
        "byte_order": 0
      },
      "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0xc19a7a1",
        "factor": 1,
        "offset": 0,
        "start_bit": 12,
        "byte_order": 0
      }
    }
  };
}
