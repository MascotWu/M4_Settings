import 'dart:convert';

import 'package:gbk2utf8/gbk2utf8.dart';

import 'convert.dart';

abstract class ConfigurationFile {
  var path;

  Map<String, dynamic> config = {};

  setConfig(List<int> content);

  generateFileContent();

  void handle(socketMessage) {
    if (socketMessage['result']['path'] == path) {
      setConfig(
          base64Decode(socketMessage['result']['data']));
    }
  }
}

class MacrosConfigTextFile extends ConfigurationFile {
  @override
  final path = '/sdcard/run/macros_config.txt';

  @override
  generateFileContent() {
    return utf8.encode(gflagEncode(config));
  }

  @override
  setConfig(List<int> content) {
    return config = gflagDecode(utf8.decode(content));
  }
}

class DetectFlagFile extends ConfigurationFile {
  @override
  String get path => '/sdcard/run/detect.flag';

  @override
  generateFileContent() {
    return utf8.encode(gflagEncode(config));
  }

  @override
  setConfig(List<int> content) {
    return config = gflagDecode(utf8.decode(content));
  }
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
    config = jsonDecode(utf8.decode(content));
    config['main'] ??= {};
  }
}

class DmsSetupFlagFile extends ConfigurationFile {
  @override
  get path => '/sdcard/run/dms_setup.flag';

  @override
  generateFileContent() {
    return utf8.encode(gflagEncode(config));
  }

  @override
  setConfig(List<int> content) {
    return config = gflagDecode(utf8.decode(content));
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
    return config = jsonDecode(utf8.decode(content));
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
    config = jsonDecode(gbk.decode(content));
  }
}
