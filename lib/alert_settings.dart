import 'package:flutter/material.dart';
import 'package:flutter_app/view_model.dart';

class AlertSettingsPage extends StatefulWidget {
  createState() => new AlertSettingsState();
}

class AlertSettingsState extends State<AlertSettingsPage> {
  ViewModel vm;

  AlertSettingsState() {
    vm = ViewModel.get();

    _alertItemSmoking =
    vm.dmsSetupFlagFile.config['alert_item_smoking'];

    _alertItemDemobilized =
    vm.dmsSetupFlagFile.config['alert_item_demobilized'];

    _alertItemDriverchange =
    vm.dmsSetupFlagFile.config['alert_item_driverchange'];

    _alertItemOcclusion =
    vm.dmsSetupFlagFile.config['alert_item_occlusion'];

    _alertItemLookup =
    vm.dmsSetupFlagFile.config['alert_item_lookup'];

    _alertItemEyeocclusion =
    vm.dmsSetupFlagFile.config['alert_item_eyeocclusion'];

    _alertItemHandsoff =
    vm.dmsSetupFlagFile.config['alert_item_handsoff'];

    _alertItemLongtimedrive =
    vm.dmsSetupFlagFile.config['alert_item_longtimedrive'];
  }

  bool _alertItemSmoking;

  bool _alertItemDemobilized;

  bool _alertItemDriverchange;

  bool _alertItemOcclusion;

  bool _alertItemLookup;

  bool _alertItemEyeocclusion;

  bool _alertItemHandsoff;

  bool _alertItemLongtimedrive;

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
              value: _alertItemSmoking,
              onChanged: (bool value) {
                setState(() {
                  _alertItemSmoking = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_smoking': value});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('离岗'),
              value: _alertItemDemobilized,
              onChanged: (bool value) {
                setState(() {
                  _alertItemDemobilized = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_demobilized': value});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('驾驶员变更'),
              value: _alertItemDriverchange,
              onChanged: (bool value) {
                setState(() {
                  _alertItemDriverchange = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_driverchange': value});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('遮挡'),
              value: _alertItemOcclusion,
              onChanged: (bool value) {
                setState(() {
                  _alertItemOcclusion = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_occlusion': value});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('抬头'),
              value: _alertItemLookup,
              onChanged: (bool value) {
                setState(() {
                  _alertItemLookup = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_lookup': value});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('墨镜遮挡'),
              value: _alertItemEyeocclusion,
              onChanged: (bool value) {
                setState(() {
                  _alertItemEyeocclusion = value;
                });

                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_eyeocclusion': value});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('双手脱离方向盘'),
              value: _alertItemHandsoff,
              onChanged: (bool value) {
                setState(() {
                  _alertItemHandsoff = value;
                });
                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_handsoff': value});
              },
              secondary: const Icon(Icons.warning),
            ),
            SwitchListTile(
              title: const Text('长时间驾驶'),
              value: _alertItemLongtimedrive,
              onChanged: (bool value) {
                setState(() {
                  _alertItemLongtimedrive = value;
                });

                vm.addOrUpdate(vm.dmsSetupFlagFile,
                    {'alert_item_longtimedrive': value});
              },
              secondary: const Icon(Icons.warning),
            ),
          ],
        )));
  }
}
