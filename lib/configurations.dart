import 'dart:convert';

import 'package:gbk2utf8/gbk2utf8.dart';

import 'convert.dart';

abstract class ConfigurationFile {
  var path;

  Map<String, dynamic> config = {};

  setConfig(List<int> content);

  generateFileContent();

  void handle(socketMessage) {
    if (socketMessage['type'] == "read_file_ok") {
      if (socketMessage['result']['path'] == path) {
        setConfig(base64Decode(socketMessage['result']['data']));
      }
    } else if (socketMessage['type'] == "read_file_error") {
      List<String> errorMessage = socketMessage['error'].split(':');
      if (errorMessage.length == 2 && errorMessage[0] == path)
        setConfig(null);
    }
  }
}

// 车辆配置文件
class MacrosConfigTextFile extends ConfigurationFile {
  @override
  final path = '/sdcard/run/macros_config.txt';

  @override
  generateFileContent() {
    return utf8.encode(gflagEncode(config));
  }

  @override
  setConfig(List<int> content) {
    config = gflagDecode(content == null ? "" : utf8.decode(content));
    config['enable_fcw'] ??= 1;
    config['headway_warning_level_1'] ??= -1.0;
  }

  get fcw => config['enable_fcw'] == 1;

  set fcw(bool enabled) {
    config['enable_fcw'] = enabled ? 1 : 0;
  }

  get hmw => config['headway_warning_level_1'].round() != -1;

  set hmw(bool enabled) =>
      config['headway_warning_level_1'] = enabled ? 1.0 : -1.0;
}

// 车道配置文件
class DetectFlagFile extends ConfigurationFile {
  @override
  String get path => '/sdcard/run/detect.flag';

  get tsr => config['enable_tsr'];

  set tsr(bool enabled) => config['enable_tsr'] = enabled;

  @override
  generateFileContent() {
    return utf8.encode(gflagEncode(config));
  }

  @override
  setConfig(List<int> content) {
    config = gflagDecode(content == null ? "" : utf8.decode(content));
    pcw ??= true;
    ldw ??= true;
    tsr ??= true;
  }

  // PCW 通过 enable_ped 控制,变量类型为 bool 型.
  get pcw => config['enable_ped'];

  set pcw(bool enabled) => config['enable_ped'] = enabled;

  // LDW 通过 ldw_speed_thresh 控制，设置为10000时关闭，设置为55时开启.
  get ldw =>
      config['ldw_speed_thresh'] == null ? null : config['ldw_speed_thresh'] ==
          55;

  set ldw(bool enabled) => config['ldw_speed_thresh'] = enabled ? 55 : 10000;
}

class CanInputJsonFile extends ConfigurationFile {
  @override
  get path => '/sdcard/run/can_input.json';

  @override
  generateFileContent() {
    return utf8.encode(JsonEncoder.withIndent('\t').convert(config));
  }

  @override
  setConfig(List<int> content) {
    config = jsonDecode(content == null ? '{}' : utf8.decode(content));
    config['main'] ??= {};
    config['main']['use_obd'] ??= false;
    config['main']['baudrate'] ??= '250k';
    config['main']['scenario'] ??= 0;
    config['main']['enable_e1'] ??= false;

    config['m4_analog'] ??= {};
    config['m4_analog']['aspeed'] ??= {};
    config['m4_analog']['aspeed']['ratio'] ??= 0;
    config['m4_analog']['aspeed']['enable'] ??= false;
    config['m4_analog']['aturnlamp'] ??= {};
    config['m4_analog']['aturnlamp']['enable'] ??= false;
    config['m4_analog']['aturnlamp']['polarity'] ??= 1;
  }
}

class DmsSetupFlagFile extends ConfigurationFile {

  get absence => config['alert_item_demobilized'];

  set absence(enabled) => config['alert_item_demobilized'] = enabled;

  get makePhoneCall => config['alert_item_phone'];

  set makePhoneCall(enabled) => config['alert_item_phone'] = enabled;

  get occlusion => config['alert_item_occlusion'];

  set occlusion(enabled) => config['alert_item_occlusion'] = enabled;

  get smoking => config['alert_item_smoking'];

  set smoking(enabled) => config['alert_item_smoking'] = enabled;

  get substitute => config['alert_item_driverchange'];

  set substitute(enabled) => config['alert_item_driverchange'] = enabled;

  get lookAround => config['alert_item_lookaround'];

  set lookAround(enabled) => config['alert_item_lookaround'] = enabled;

  get lookUp => config['alert_item_lookup'];

  set lookUp(enabled) => config['alert_item_lookup'] = enabled;

  get lookDown => config['alert_item_bow'];

  set lookDown(enabled) => config['alert_item_bow'] = enabled;

  @override
  get path => '/sdcard/run/dms_setup.flag';

  get fatigue => config['alert_item_eyeclose2'];

  set fatigue(bool enabled) => config['alert_item_eyeclose2'] = enabled;

  get yawn => config['alert_item_yawn'];

  set yawn(bool enabled) => config['alert_item_yawn'] = enabled;

  get tired => config['alert_item_eyeclose1'];

  set tired(bool enabled) {
    config['alert_item_eyeclose1'] = enabled;
  }

  @override
  generateFileContent() {
    return utf8.encode(gflagEncode(config));
  }

  @override
  setConfig(List<int> content) {
    config = gflagDecode(content == null ? "" : utf8.decode(content));
    config['alert_item_eyeclose1'] ??= false;
    config['alert_item_eyeclose2'] ??= false;
    config['alert_item_bow'] ??= false;
    config['alert_item_phone'] ??= false;
    config['alert_item_lookaround'] ??= false;
    config['alert_item_yawn'] ??= false;
    config['alert_item_smoking'] ??= false;
    config['alert_item_demobilized'] ??= false;
    config['alert_item_driverchange'] ??= false;
    config['alert_item_occlusion'] ??= false;
    config['alert_item_lookup'] ??= false;
    config['alert_item_eyeocclusion'] ??= false;
    config['alert_item_handsoff'] ??= false;
    config['alert_item_longtimedrive'] ??= false;
  }
}

class MProtocolJsonFile extends ConfigurationFile {
  @override
  get path => '/data/mprot/mprot.json';

  @override
  generateFileContent() {
    return utf8.encode(JsonEncoder.withIndent('\t').convert(config));
  }

  @override
  setConfig(List<int> content) {
    config = jsonDecode(content == null ? '{}' : utf8.decode(content));
  }
}

class MProtocolConfigJsonFile extends ConfigurationFile {
  @override
  get path => '/data/mprot/config/config.json';

  @override
  generateFileContent() {
    return gbk.encode(JsonEncoder.withIndent('\t').convert(config));
  }

  @override
  setConfig(List<int> content) {
    config = jsonDecode(content == null ? '{}' : gbk.decode(content));
  }
}
