import 'package:flutter/material.dart';
import 'package:flutter_app/view_model.dart';

class AlertSettingsPage extends StatefulWidget {
  createState() => new AlertSettingsState();
}

class AlertSettingsState extends State<AlertSettingsPage> {
  ViewModel vm;

  AlertSettingsState() {
    vm = ViewModel.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("报警"),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('FCW报警'),
              value: vm.fcw,
              onChanged: (bool value) {
                setState(() {
                  vm.fcw = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('HMW报警'),
              value: vm.hmw,
              onChanged: (bool value) {
                setState(() {
                  vm.hmw = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('LDW报警'),
              value: vm.ldw,
              onChanged: (bool value) {
                setState(() {
                  vm.ldw = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('超速预警(TSR)'),
              value: vm.tsr,
              onChanged: (bool value) {
                setState(() {
                  vm.tsr = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('行人预警'),
              value: vm.pcw,
              onChanged: (bool value) {
                setState(() {
                  vm.pcw = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('轻度闭眼'),
              value: vm.tired,
              onChanged: (bool value) {
                setState(() {
                  vm.tired = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('重度闭眼'),
              value: vm.fatigue,
              onChanged: (bool value) {
                setState(() {
                  vm.fatigue = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('低头'),
              value: vm.lookDown,
              onChanged: (bool value) {
                setState(() {
                  vm.lookDown = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('打电话'),
              value: vm.makePhoneCall,
              onChanged: (bool value) {
                setState(() {
                  vm.makePhoneCall = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('左顾右盼'),
              value: vm.lookAround,
              onChanged: (bool value) {
                setState(() {
                  vm.lookAround = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('打哈欠'),
              value: vm.yawn,
              onChanged: (bool value) {
                setState(() {
                  vm.yawn = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('吸烟'),
              value: vm.smoking,
              onChanged: (bool value) {
                setState(() {
                  vm.smoking = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('离岗'),
              value: vm.absence,
              onChanged: (bool value) {
                setState(() {
                  vm.absence = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('驾驶员变更'),
              value: vm.substitute,
              onChanged: (bool value) {
                setState(() {
                  vm.substitute = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('遮挡'),
              value: vm.occlusion,
              onChanged: (bool value) {
                setState(() {
                  vm.occlusion = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('抬头'),
              value: vm.lookUp,
              onChanged: (bool value) {
                setState(() {
                  vm.lookUp = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('墨镜遮挡'),
              value: vm.wearingSunglasses,
              onChanged: (bool value) {
                setState(() {
                  vm.wearingSunglasses = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('双手脱离方向盘'),
              value: vm.handsOff,
              onChanged: (bool value) {
                setState(() {
                  vm.handsOff = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('长时间驾驶'),
              value: vm.longtimeDriving,
              onChanged: (bool value) {
                setState(() {
                  vm.longtimeDriving = value;
                });
              },
              secondary: const Icon(Icons.warning),
            ),
          ],
        )));
  }
}
