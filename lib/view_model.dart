import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_app/configurations.dart';
import 'package:rxdart/rxdart.dart';

import 'lane_painter.dart';

class ViewModel {
  var _connectionStatus = new BehaviorSubject<bool>();

  static ViewModel vm = new ViewModel();

  ViewModel() {
    ServerSocket.bind(InternetAddress.anyIPv4, 16346)
        .then((ServerSocket serverSocket) {
      print("等待连接");

      serverSocket.listen(deviceConnected, onError: (e) {
        print("没有网络的时候无法监听本地端口 $e");
        _connectionStatus.add(false);
      });
    });
  }

  String get plateNumber => mProtocolConfigJsonFile.plateNumber;

  set plateNumber(number) {
    mProtocolConfigJsonFile.plateNumber = number;
    push(mProtocolConfigJsonFile);
  }

  bool get associatedWithVideo => mProtocolConfigJsonFile.associatedWithVideo;

  set associatedWithVideo(enabled) {
    mProtocolConfigJsonFile.associatedWithVideo = enabled;
    push(mProtocolConfigJsonFile);
  }

  String get resolution => mProtocolConfigJsonFile.resolution;

  set resolution(resolution) {
    mProtocolConfigJsonFile.resolution = resolution;
    push(mProtocolConfigJsonFile);
  }

  bool get ignoreSpeedLimitation =>
      mProtocolConfigJsonFile.ignoreSpeedLimitation;

  set ignoreSpeedLimitation(enabled) {
    mProtocolConfigJsonFile.ignoreSpeedLimitation = enabled;
    push(mProtocolConfigJsonFile);
  }

  String get terminalId => mProtocolConfigJsonFile.terminalId;

  set terminalId(id) {
    mProtocolConfigJsonFile.terminalId = id;
    push(mProtocolConfigJsonFile);
  }

  int get plateColor => mProtocolConfigJsonFile.plateColor;

  set plateColor(color) {
    mProtocolConfigJsonFile.plateColor = color;
    push(mProtocolConfigJsonFile);
  }

  String get deviceIdOfJT808 => mProtocolConfigJsonFile.deviceIdOfJT808;

  set deviceIdOfJT808(id) {
    mProtocolConfigJsonFile.deviceIdOfJT808 = id;
    push(mProtocolConfigJsonFile);
  }

  int get port => mProtocolConfigJsonFile.port;

  set port(port) {
    mProtocolConfigJsonFile.port = port;
    push(mProtocolConfigJsonFile);
  }

  get absence => _dmsSetupFlagFile.absence;

  set absence(enabled) {
    _dmsSetupFlagFile.absence = enabled;
  }

  String get ip => mProtocolConfigJsonFile.ip;

  set ip(ip) {
    mProtocolConfigJsonFile.ip = ip;
    push(mProtocolConfigJsonFile);
  }

  get handsOff => _dmsSetupFlagFile.handsOff;

  set handsOff(enabled) {
    _dmsSetupFlagFile.handsOff = enabled;
    push(_dmsSetupFlagFile);
  }

  get lookDown => _dmsSetupFlagFile.lookDown;

  set lookDown(enabled) {
    _dmsSetupFlagFile.lookDown = enabled;
    push(_dmsSetupFlagFile);
  }

  get lookUp => _dmsSetupFlagFile.lookUp;

  set lookUp(enabled) {
    _dmsSetupFlagFile.lookUp = enabled;
    push(_dmsSetupFlagFile);
  }

  get longtimeDriving => _dmsSetupFlagFile.longtimeDriving;

  set longtimeDriving(enabled) {
    _dmsSetupFlagFile.longtimeDriving = enabled;
    push(_dmsSetupFlagFile);
  }

  get occlusion => _dmsSetupFlagFile.occlusion;

  set occlusion(enabled) {
    _dmsSetupFlagFile.occlusion = enabled;
    push(_dmsSetupFlagFile);
  }

  get lookAround => _dmsSetupFlagFile.lookAround;

  set lookAround(enabled) {
    _dmsSetupFlagFile.lookAround = enabled;
    push(_dmsSetupFlagFile);
  }

  get makePhoneCall => _dmsSetupFlagFile.makePhoneCall;

  set makePhoneCall(enabled) {
    _dmsSetupFlagFile.makePhoneCall = enabled;
    push(_dmsSetupFlagFile);
  }

  get smoking => _dmsSetupFlagFile.smoking;

  set smoking(enabled) {
    _dmsSetupFlagFile.smoking = enabled;
    push(_dmsSetupFlagFile);
  }

  get substitute => _dmsSetupFlagFile.substitute;

  set substitute(enabled) {
    _dmsSetupFlagFile.substitute = enabled;
    push(_dmsSetupFlagFile);
  }

  bool get fatigue => _dmsSetupFlagFile.fatigue;

  set fatigue(bool enabled) {
    _dmsSetupFlagFile.fatigue = enabled;
    push(_dmsSetupFlagFile);
  }

  bool get tired => _dmsSetupFlagFile.tired;

  set tired(bool enabled) {
    _dmsSetupFlagFile.tired = enabled;
    push(_dmsSetupFlagFile);
  }

  bool get ldw => laneConfigFile.ldw;

  set ldw(bool enabled) {
    laneConfigFile.ldw = enabled;
    push(laneConfigFile);
  }

  get wearingSunglasses => _dmsSetupFlagFile.wearingSunglasses;

  set wearingSunglasses(enabled) {
    _dmsSetupFlagFile.wearingSunglasses = enabled;
    push(_dmsSetupFlagFile);
  }

  get yawn => _dmsSetupFlagFile.yawn;

  set yawn(bool enabled) {
    _dmsSetupFlagFile.yawn = enabled;
    push(_dmsSetupFlagFile);
  }

  bool get pcw => laneConfigFile.pcw;

  set pcw(bool enabled) {
    laneConfigFile.pcw = enabled;
    push(laneConfigFile);
  }

  get tsr => laneConfigFile.tsr;

  set tsr(bool enabled) {
    laneConfigFile.tsr = enabled;
    push(laneConfigFile);
  }

  bool get fcw => carConfigFile.fcw;

  set fcw(bool enabled) {
    carConfigFile.fcw = enabled;
    push(carConfigFile);
  }

  bool get hmw => carConfigFile.hmw;

  set hmw(bool enabled) {
    carConfigFile.hmw = enabled;
    push(carConfigFile);
  }

  static ViewModel get() {
    return vm;
  }

  addOrUpdate(ConfigurationFile file, configurations) {
    file.config.addAll(configurations);
    push(file);
  }

  addOrUpdateSpeed(int speed) {
    if (!canInputJsonFile.config.containsKey('main'))
      canInputJsonFile.config['main'] = {};
    canInputJsonFile.config['main']['fake_speed'] = speed;
    push(canInputJsonFile);
  }

  addOrUpdateBaudRate(String baudRate) {
    canInputJsonFile.config['main']['baudrate'] = baudRate;
    push(canInputJsonFile);
  }

  deleteSpeed() {
    if (canInputJsonFile.config['main'].containsKey('fake_speed')) {
      canInputJsonFile.config['main'].remove('fake_speed');
    }
      push(canInputJsonFile);
  }

  var _adasPicture = new BehaviorSubject<Uint8List>();
  var _dmsPicture = new BehaviorSubject<Uint8List>();

  BehaviorSubject takePictureOfAdas() {
    var length = Uint8List(4);
    var byteData = ByteData.view(length.buffer);

    var command = jsonEncode({
      "type": "get_camera_image",
      "data": {"camera": 'adas'}
    });

    byteData.setUint32(0, command.length);

    sock.add(length);
    sock.add(utf8.encode(command));

    return _adasPicture;
  }

  BehaviorSubject takePictureOfDms() {
    var length = Uint8List(4);
    var byteData = ByteData.view(length.buffer);

    var command = jsonEncode({
      "type": "get_camera_image",
      "data": {"camera": 'driver'}
    });

    byteData.setUint32(0, command.length);

    sock.add(length);
    sock.add(utf8.encode(command));

    return _dmsPicture;
  }

  delete(ConfigurationFile file, String key) {
    file.config.remove(key);
    push(file);
  }

  push(ConfigurationFile file) {
    var message = Uint8List(4);
    var bytedata = ByteData.view(message.buffer);

    var command = jsonEncode({
      "type": "write_file",
      "data": {
        "path": file.path,
        "data": base64Encode(file.generateFileContent())
      }
    });

    bytedata.setUint32(0, command.length);

    sock.add(message);
    sock.add(utf8.encode(command));
  }

  Observable<bool> get connectionStatus => _connectionStatus;

  clear() {}

  Socket sock;

  MacrosConfigTextFile carConfigFile = new MacrosConfigTextFile();
  DetectFlagFile laneConfigFile = new DetectFlagFile();
  DmsSetupFlagFile _dmsSetupFlagFile = new DmsSetupFlagFile();
  CanInputJsonFile canInputJsonFile = new CanInputJsonFile();
  MProtocolConfigJsonFile mProtocolConfigJsonFile =
      new MProtocolConfigJsonFile();
  MProtocolJsonFile mProtocolJsonFile = new MProtocolJsonFile();

  getFiles(Socket socket, ConfigurationFile file) {
    var message = Uint8List(4);
    var byteData = ByteData.view(message.buffer);
    var command = jsonEncode({"type": "read_file", "data": file.path});
    byteData.setUint32(0, command.length);
    socket.add(message);
    socket.add(utf8.encode(command));
  }

  List<int> _buffer = [];

  void onData(List<int> buffer) {
    _buffer.addAll(buffer);

    while (_buffer.length >= 4) {
      var length =
          ByteData.view(Uint8List.fromList(_buffer).buffer, 0, 4).getUint32(0);

      if (_buffer.length < length + 4) break;

      var command = String.fromCharCodes(_buffer, 4, length + 4);
      onCommand(command);
      _buffer.removeRange(0, length + 4);
    }
  }

  void addOrUpdateServerIp(String ip) {
    mProtocolConfigJsonFile.config['server']['ipaddr'] = ip;
    push(mProtocolConfigJsonFile);
  }

  void addOrUpdateServerPort(String port) {
    mProtocolConfigJsonFile.config['server']['port'] = port;
    push(mProtocolConfigJsonFile);
  }

  void addOrUpdateDeviceIdOfJT808(String deviceId) {
    mProtocolConfigJsonFile.config['reg_param']['reg_id'] = deviceId;
    push(mProtocolConfigJsonFile);
  }

  void addOrUpdatePlateNumber(String plateNumber) {
    mProtocolConfigJsonFile.config['reg_param']['car_num'] = plateNumber;
    push(mProtocolConfigJsonFile);
  }

  addOrUpdateTerminalId(String terminalId) {
    mProtocolConfigJsonFile.config['reg_param']['dev_id'] = terminalId;
    push(mProtocolConfigJsonFile);
  }

  addOrUpdateAssociatedWithVideoOfJT808(bool associated) {
    mProtocolConfigJsonFile.config['reg_param']['associated_video'] =
        associated;
    push(mProtocolConfigJsonFile);
  }

  addOrUpdateIgnoreSpeedLimited(bool ignore) {
    mProtocolConfigJsonFile.config['ignore_spdth'] = ignore;
    push(mProtocolConfigJsonFile);
  }

  addOrUpdatePlateColor(int color) {
    mProtocolConfigJsonFile.config['reg_param']['plate_color'] = color;
    push(mProtocolConfigJsonFile);
  }

  addOrUpdateResolutionForJt808(String resolution) {
    mProtocolConfigJsonFile.config['resolution'] ??= {};
    mProtocolConfigJsonFile.config['resolution']['adas_video'] = resolution;
    mProtocolConfigJsonFile.config['resolution']['adas_image'] = resolution;
    mProtocolConfigJsonFile.config['resolution']['dms_video'] = resolution;
    mProtocolConfigJsonFile.config['resolution']['dms_image'] = resolution;
    push(mProtocolConfigJsonFile);
  }

  String yaw;
  String pitch;

  addOrUpdateResolutionForSuBiao(String resolution) {
    mProtocolConfigJsonFile.config['resolution'] ??= {};
    mProtocolConfigJsonFile.config['resolution']['adas_video'] = resolution;
    mProtocolConfigJsonFile.config['resolution']['adas_image'] = resolution;
    mProtocolConfigJsonFile.config['resolution']['dms_video'] = resolution;
    mProtocolConfigJsonFile.config['resolution']['dms_image'] = resolution;
    push(mProtocolConfigJsonFile);
  }

  addOrUpdateAssociatedWithVideoOfSuBiao(bool associated) {
    mProtocolConfigJsonFile.config['protocol'] ??= {};
    mProtocolConfigJsonFile.config['protocol']['associated_video'] = associated;
    push(mProtocolConfigJsonFile);
  }

  addOrUpdateUseRtData(bool useRtData) {
    mProtocolConfigJsonFile.config['protocol'] ??= {};
    mProtocolConfigJsonFile.config['protocol']['use_rtdata'] = useRtData;
    push(mProtocolConfigJsonFile);
  }

  double volume;

  getVolume() {
    var message = Uint8List(4);
    var byteData = ByteData.view(message.buffer);
    var command = jsonEncode({"type": "get_system_volume"});
    byteData.setUint32(0, command.length);
    sock.add(message);
    sock.add(utf8.encode(command));
  }

  void setVolume(volume) {
    var message = Uint8List(4);
    var byteData = ByteData.view(message.buffer);
    var command = jsonEncode({"type": "set_system_volume", "data": volume});
    byteData.setUint32(0, command.length);
    sock.add(message);
    sock.add(utf8.encode(command));
  }

  // Since the device doesn't know the IP address of the cellphone, and the
  // IP address of device is fixed, it is necessary for cellphone to connect
  // the device first and send a string message to the device:
  //
  //   'set_instruction_server_host this\n'
  //
  // to tell the device to establish a tcp connection to itself. After that,
  // the device will reply
  //
  //   'OK\n'
  //
  // and try to connect the cellphone.
  tellDeviceTheIpOfPhone() {
    // if server socket have not established yet
    // then establish it.

    // connect device, send command and wait for response.
    Socket.connect("192.168.43.1", 16400).then((Socket socket) {
      socket.listen((List<int> event) {
        if (String.fromCharCodes(event) == "OK\n") print("在设备上配置手机的IP地址成功");
      });
      socket.write('set_instruction_server_host this\n');
      print("正在在设备上配置手机的IP地址");
    }, onError: (e) {
      print('在设备上配置手机的IP地址失败 $e');
      _connectionStatus.add(false);
    }).timeout(Duration(seconds: 2), onTimeout: () {
      print("在设备上配置手机的IP地址超时");
      _connectionStatus.add(false);
    });
  }

  deviceConnected(Socket socket) {
    print("连接建立");
    _connectionStatus.add(true);
    sock = socket;

    socket.listen(onData, onError: (e) {
      print('socket.listen报错 $e');
      _connectionStatus.add(false);
    });

    getFiles(socket, carConfigFile);
    getFiles(socket, laneConfigFile);
    getFiles(socket, _dmsSetupFlagFile);
    getFiles(socket, canInputJsonFile);
    getFiles(socket, mProtocolConfigJsonFile);
    getFiles(socket, mProtocolJsonFile);

    getVolume();
    getCameraParams();
  }

  void getCameraParams() {
    var message = Uint8List(4);
    var byteData = ByteData.view(message.buffer);
    var command = jsonEncode({"type": "get_camera_params"});
    byteData.setUint32(0, command.length);
    sock.add(message);
    sock.add(utf8.encode(command));
  }

  OpticalParam opticalParam = OpticalParam();
  OpticalParam originalOpticalParam = OpticalParam();
  bool hasBeenCalculated = false;

  onCommand(String command) {
    var socketMessage = jsonDecode(command);

    print(socketMessage['type']);
    if (socketMessage['type'] == 'read_file_ok' ||
        socketMessage['type'] == 'read_file_error') {
      carConfigFile.handle(socketMessage);
      laneConfigFile.handle(socketMessage);
      canInputJsonFile.handle(socketMessage);
      _dmsSetupFlagFile.handle(socketMessage);
      mProtocolConfigJsonFile.handle(socketMessage);
      mProtocolJsonFile.handle(socketMessage);
      push(carConfigFile);
      push(laneConfigFile);
      push(canInputJsonFile);
      push(_dmsSetupFlagFile);
      push(mProtocolConfigJsonFile);
      push(mProtocolJsonFile);
    } else if (socketMessage['type'] == 'get_camera_image_ok') {
      if (socketMessage['result']['camera'] == 'adas') {
        _adasPicture.add(base64Decode(socketMessage['result']['image']));
      } else if (socketMessage['result']['camera'] == 'driver') {
        _dmsPicture.add(base64Decode(socketMessage['result']['image']));
      }
    } else if (socketMessage['type'] == 'get_system_volume_ok') {
      volume = socketMessage['result'].toDouble();
    } else if (socketMessage['type'] == 'get_camera_params_ok') {
      hasBeenCalculated = false;
      opticalParam.cu = socketMessage['result']['cu'];
      opticalParam.cv = socketMessage['result']['cv'];
      opticalParam.fu = socketMessage['result']['fu'];
      opticalParam.fv = socketMessage['result']['fv'];
      opticalParam.width = socketMessage['result']['width'].toDouble();
      opticalParam.height = socketMessage['result']['height'].toDouble();

      originalOpticalParam.cu = socketMessage['result']['cu'];
      originalOpticalParam.cv = socketMessage['result']['cv'];
      originalOpticalParam.fu = socketMessage['result']['fu'];
      originalOpticalParam.fv = socketMessage['result']['fv'];
      originalOpticalParam.width = socketMessage['result']['width'].toDouble();
      originalOpticalParam.height =
          socketMessage['result']['height'].toDouble();
    }
  }
}