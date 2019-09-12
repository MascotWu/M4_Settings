import 'dart:convert';
import 'dart:math';

import 'package:gbk2utf8/gbk2utf8.dart';

import 'convert.dart';

abstract class ConfigurationFile {
  var path;

  Map<String, dynamic> config = {};

  setConfig(List<int> content);

  generateFileContent();

  bool handle(socketMessage) {
    if (socketMessage['type'] == "read_file_ok") {
      if (socketMessage['result']['path'] == path) {
        setConfig(base64Decode(socketMessage['result']['data']));
        return true;
      }
    } else if (socketMessage['type'] == "read_file_error") {
      List<String> errorMessage = socketMessage['error'].split(':');
      if (errorMessage.length == 2 && errorMessage[0] == path) {
        setConfig(null);
        return true;
      }
    }

    return false;
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

  get fcw => config['enable_fcw'] == 1 && config['enable_fcw_warning'] == 1;

  set fcw(bool enabled) {
    config['enable_fcw'] = enabled ? 1 : 0;
    config['enable_fcw_warning'] = enabled ? 1 : 0;
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

  get ldw =>
      config['enable_lane'] == true;

  set ldw(bool enabled) {
    config['enable_lane'] = enabled;
    config['ldw_speed_start'] = 55;
    config['ldw_speed_exit'] = 50;
  }
}

class CanInputJsonFile extends ConfigurationFile {
  @override
  get path => '/sdcard/run/can_input.json';

  int get fakeSpeed => config['main']['fake_speed'];

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

  @override
  get path => '/sdcard/run/dms_setup.flag';

  get absence => config['alert_item_demobilized_enable'];

  set absence(enabled) => config['alert_item_demobilized_enable'] = enabled;

  get handsOff => config['alert_item_handsoff_enable'];

  set handsOff(enabled) => config['alert_item_handsoff_enable'] = enabled;

  get makePhoneCall => config['alert_item_phone_enable'];

  set makePhoneCall(enabled) => config['alert_item_phone_enable'] = enabled;

  get occlusion => config['alert_item_occlusion_enable'];

  set occlusion(enabled) => config['alert_item_occlusion_enable'] = enabled;

  get smoking => config['alert_item_smoking_enable'];

  set smoking(enabled) => config['alert_item_smoking_enable'] = enabled;

  get substitute => config['alert_item_driverchange_enable'];

  set substitute(enabled) => config['alert_item_driverchange_enable'] = enabled;

  get lookAround => config['alert_item_lookaround_enable'];

  set lookAround(enabled) => config['alert_item_lookaround_enable'] = enabled;

  get lookUp => config['alert_item_lookup_enable'];

  set lookUp(enabled) => config['alert_item_lookup_enable'] = enabled;

  get lookDown => config['alert_item_bow_enable'];

  set lookDown(enabled) => config['alert_item_bow_enable'] = enabled;

  get longtimeDriving => config['alert_item_longtimedrive_enable'];

  set longtimeDriving(enabled) =>
      config['alert_item_longtimedrive_enable'] = enabled;

  get fatigue => config['alert_item_eyeclose2_enable'];

  set fatigue(enabled) => config['alert_item_eyeclose2_enable'] = enabled;

  get wearingSunglasses => config['alert_item_eyeocclusion_enable'];

  set wearingSunglasses(enabled) =>
      config['alert_item_eyeocclusion_enable'] = enabled;

  get yawn => config['alert_item_yawn_enable'];

  set yawn(enabled) => config['alert_item_yawn_enable'] = enabled;

  get tired => config['alert_item_eyeclose1_enable'];

  set tired(enabled) => config['alert_item_eyeclose1_enable'] = enabled;

  @override
  generateFileContent() {
    return utf8.encode(gflagEncode(config));
  }

  @override
  setConfig(List<int> content) {
    config = gflagDecode(content == null ? "" : utf8.decode(content));
    tired ??= true;
    fatigue ??= true;
    lookDown ??= true;
    makePhoneCall ??= true;
    lookAround ??= true;
    yawn ??= true;
    smoking ??= true;
    absence ??= true;
    substitute ??= true;
    occlusion ??= true;
    lookUp ??= true;
    wearingSunglasses ??= true;
    handsOff ??= true;
    longtimeDriving ??= true;
  }
}

class MProtocolJsonFile extends ConfigurationFile {
  @override
  get path => '/data/mprot/mprot.json';

  String get protocol => config['protocol'];

  @override
  generateFileContent() {
    return utf8.encode(JsonEncoder.withIndent('\t').convert(config));
  }

  @override
  setConfig(List<int> content) {
    config = jsonDecode(content == null ? '{}' : utf8.decode(content));
    print("当前协议: ${config['protocol']}");
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
    config['server'] ??= {};
    config['server']['ipaddr'] ??= '';
    config['server']['port'] ??= 0;
    config['server']['heartbeat_period'] ??= 30;

    config['reg_param'] ??= {};
    config['reg_param']['associated_video'] ??= false;
    config['reg_param']['car_num'] ??= '';
    config['reg_param']['city_id'] ??= 0;
    config['reg_param']['product'] ??= "MINIEYE_ADAS/DSM";
    config['reg_param']['province_id'] ??= 0;
    config['reg_param']['plate_color'] ??= 2;
    config['reg_param']['vendor'] ??= "MNEYE";

    var random = Random(DateTime
        .now()
        .millisecondsSinceEpoch);

    config['reg_param']['dev_id'] ??=
        random.nextInt(pow(36, 3)).toRadixString(36).toUpperCase() +
            random.nextInt(pow(36, 4)).toRadixString(36).toUpperCase();

    config['resolution'] ??= {};
    config['resolution']['adas_video'] ??= "720P";
    config['resolution']['adas_image'] ??= "720P";
    config['resolution']['dms_video'] ??= "720P";
    config['resolution']['dms_image'] ??= "720P";

    config["ignore_spdth"] ??= true;
  }

  String get ip => config['server']['ipaddr'] ??= '';

  set ip(ip) => config['server']['ipaddr'] = ip;

  int get port => config['server']['port'];

  set port(port) => config['server']['port'] = port;

  String get resolution => config['resolution']['adas_video'];

  set resolution(resolution) {
    config['resolution']['adas_video'] = resolution;
    config['resolution']['adas_image'] = resolution;
    config['resolution']['dms_video'] = resolution;
    config['resolution']['dms_image'] = resolution;
  }

  int get plateColor => config['reg_param']['plate_color'];

  set plateColor(color) => config['reg_param']['plate_color'] = color;

  String get plateNumber => config['reg_param']['car_num'];

  set plateNumber(number) => config['reg_param']['car_num'] = number;

  String get terminalId => config['reg_param']['dev_id'];

  set terminalId(id) => config['reg_param']['dev_id'] = id;

  String get deviceIdOfJT808 => config['reg_param']['reg_id'];

  set deviceIdOfJT808(id) => config['reg_param']['reg_id'] = id;

  bool get associatedWithVideo => config['reg_param']['associated_video'];

  set associatedWithVideo(enabled) =>
      config['reg_param']['associated_video'] = enabled;

  bool get ignoreSpeedLimitation => config["ignore_spdth"];

  set ignoreSpeedLimitation(enabled) => config["ignore_spdth"] = enabled;
}
