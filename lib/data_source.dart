import 'package:flutter/material.dart';
import 'package:flutter_app/picker_dialog.dart';

import 'view_model.dart';

class DataSourcePage extends StatefulWidget {
  createState() => DataSourceState();
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
              leading: const Icon(Icons.timer),
              title: Text("速度信号源选择"),
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
              leading: const Icon(Icons.shutter_speed),
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
                  if (baudRate != null) vm.addOrUpdateBaudRate(baudRate);
                });
              },
            ),
          ],
        ));
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
