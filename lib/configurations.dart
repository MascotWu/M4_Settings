import 'dart:convert';

import 'convert.dart';

abstract class ConfigurationFile {
  var path;

  Map<String, dynamic> config = {};

  generateFileContent();
}

class MacrosConfigTextFile extends ConfigurationFile {
  @override
  final path = '/sdcard/run/macros_config.txt';

  @override
  generateFileContent() {
    return gflagEncode(config);
  }
}

class DetectFlagFile extends ConfigurationFile {
  @override
  String get path => '/sdcard/run/detect.flag';

  @override
  generateFileContent() {
    return gflagEncode(config);
  }
}

class CanInputJsonFile extends ConfigurationFile {
  @override
  get path => '/sdcard/run/can_input.json';

  @override
  generateFileContent() {
    return jsonEncode(config);
  }
}

class DmsSetupFlagFile extends ConfigurationFile {
  @override
  get path => '/sdcard/run/dms_setup.flag';

  @override
  generateFileContent() {
    return gflagEncode(config);
  }
}

class MProtocolJsonFile extends ConfigurationFile {
  @override
  get path => '/data/mprot/mprot.json';

  @override
  generateFileContent() {
    return jsonEncode(config);
  }
}

class MProtocolConfigJsonFile extends ConfigurationFile {
  MProtocolConfigJsonFile() {
    config = {'server': {}, 'reg_param': {}, 'resolution': {}};
  }

  @override
  get path => '/data/mprot/config/config.json';

  @override
  generateFileContent() {
    return jsonEncode(config);
  }
}
