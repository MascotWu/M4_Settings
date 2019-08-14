import 'dart:convert';

import 'convert.dart';

abstract class ConfigurationFile {
  var path;

  Map<String, dynamic> config = {};

  setConfig(String content);

  generateFileContent();
}

class MacrosConfigTextFile extends ConfigurationFile {
  @override
  final path = '/sdcard/run/macros_config.txt';

  @override
  generateFileContent() {
    return gflagEncode(config);
  }

  @override
  setConfig(String content) {
    return config = gflagDecode(content);
  }
}

class DetectFlagFile extends ConfigurationFile {
  @override
  String get path => '/sdcard/run/detect.flag';

  @override
  generateFileContent() {
    return gflagEncode(config);
  }

  @override
  setConfig(String content) {
    return config = gflagDecode(content);
  }
}

class CanInputJsonFile extends ConfigurationFile {
  @override
  get path => '/sdcard/run/can_input.json';

  @override
  generateFileContent() {
    return jsonEncode(config);
  }

  @override
  setConfig(String content) {
    config = jsonDecode(content);
    config['main'] ??= {};
  }
}

class DmsSetupFlagFile extends ConfigurationFile {
  @override
  get path => '/sdcard/run/dms_setup.flag';

  @override
  generateFileContent() {
    return gflagEncode(config);
  }

  @override
  setConfig(String content) {
    return config = gflagDecode(content);
  }
}

class MProtocolJsonFile extends ConfigurationFile {
  @override
  get path => '/data/mprot/mprot.json';

  @override
  generateFileContent() {
    return jsonEncode(config);
  }

  @override
  setConfig(String content) {
    return config = jsonDecode(content);
  }
}

class MProtocolConfigJsonFile extends ConfigurationFile {
  @override
  get path => '/data/mprot/config/config.json';

  @override
  generateFileContent() {
    return jsonEncode(config);
  }

  @override
  setConfig(String content) {
    config = jsonDecode(content);
    config['server'] ??= {};
    config['reg_param'] ??= {};
    config['resolution'] ??= {};
  }
}
