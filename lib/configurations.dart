class Configuration {
  getPath() {}
  Map<String, dynamic> config;
}

class MacrosConfigTextFile with Configuration {
  final String _path = '/sdcard/run/macros_config.txt';

  getPath() {
    return _path;
  }
}

class DetectFlagFile with Configuration {
  final String _path = '/sdcard/run/detect.flag';

  getPath() {
    return _path;
  }
}
