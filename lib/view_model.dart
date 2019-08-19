import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_app/configurations.dart';
import 'package:rxdart/rxdart.dart';

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

  static get() {
    return vm;
  }

  addOrUpdate(ConfigurationFile file, configurations) {
    file.config.addAll(configurations);
    push(file);
  }

  addOrUpdateSpeed(int speed) {
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
      push(canInputJsonFile);
    }
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
        "data": base64Encode(utf8.encode(file.generateFileContent()))
      }
    });

    bytedata.setUint32(0, command.length);

    sock.add(message);
    sock.add(utf8.encode(command));
  }

  Observable<bool> isConnectedWithDevice() {
    return _connectionStatus;
  }

  Observable<bool> get connectionStatus => _connectionStatus;

  clear() {}

  Socket sock;

  MacrosConfigTextFile macroConfigFile = new MacrosConfigTextFile();
  DetectFlagFile detectFlagFile = new DetectFlagFile();
  DmsSetupFlagFile dmsSetupFlagFile = new DmsSetupFlagFile();
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

  var length = 0;
  var total;
  var state = "first";
  List<int> buffer = [];

  void onData9(List<int> event) {
    print('收到数据包 ${event.length}');
    if (state == 'first') {
      total = event[0] * 0x01000000 +
          event[1] * 0x010000 +
          event[2] * 0x0100 +
          event[3];
      total += 4;

      state = 'amend';
    }
    if (state == 'amend') {
      buffer.addAll(event);
      total -= event.length;

      while (total <= 0) {
        state = 'first';

        var socketMessage = jsonDecode(
            String.fromCharCodes(buffer.getRange(4, buffer.length + total)));

        if (socketMessage['type'] == 'read_file_ok') {
          if (socketMessage['result']['path'] == macroConfigFile.path) {
            macroConfigFile.setConfig(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          } else if (socketMessage['result']['path'] == detectFlagFile.path) {
            detectFlagFile.setConfig(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          } else if (socketMessage['result']['path'] == canInputJsonFile.path) {
            canInputJsonFile.setConfig(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          } else if (socketMessage['result']['path'] == dmsSetupFlagFile.path) {
            dmsSetupFlagFile.setConfig(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          } else if (socketMessage['result']['path'] ==
              mProtocolConfigJsonFile.path) {
            mProtocolConfigJsonFile.setConfig(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          } else if (socketMessage['result']['path'] ==
              mProtocolJsonFile.path) {
            mProtocolJsonFile.setConfig(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          }
        } else if (socketMessage['type'] == 'read_file_error') {
          print('read_file_error');
        } else if (socketMessage['type'] == 'write_file_ok') {
          print('write file ok');
        } else if (socketMessage['type'] == 'write_file_error') {
          print('write file error');
        } else if (socketMessage['type'] == 'get_camera_image_ok') {
          print('get_camera_image_ok');
          if (socketMessage['result']['camera'] == 'adas') {
            _adasPicture.add(base64Decode(socketMessage['result']['image']));
          } else if (socketMessage['result']['camera'] == 'driver') {
            _dmsPicture.add(base64Decode(socketMessage['result']['image']));
          }
        } else if (socketMessage['type'] == 'get_camera_image_error') {
          print('get_camera_image_error');
        } else if (socketMessage['type'] == 'get_system_volume_ok') {
          print('get_system_volume_ok');
          volume = socketMessage['result'];
          _volume.add(socketMessage['result']);
        } else if (socketMessage['type'] == 'set_system_volume_ok') {
          print('set_system_volume_ok');
        }

        buffer.removeRange(0, buffer.length + total);

        if (total >= -4)
          break;
        else {
          total = buffer[0] * 0x01000000 +
              buffer[1] * 0x010000 +
              buffer[2] * 0x0100 +
              buffer[3];
          total += 4;
          total -= buffer.length;
        }
      }
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

  resetMProtocolConfigJsonFile(String protocol) {
    if (protocol == 'jt808')
      mProtocolConfigJsonFile.config = {
        "server": {},
        "reg_param": {},
        "resolution": {}
      };
    else if (protocol == 'subiao')
      mProtocolConfigJsonFile.config = {'protocol': {}, 'resolution': {}};
  }

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

  num volume;

  var _volume = new BehaviorSubject<double>();

  getVolume() {
    var message = Uint8List(4);
    var byteData = ByteData.view(message.buffer);
    var command = jsonEncode({"type": "get_system_volume"});
    byteData.setUint32(0, command.length);
    sock.add(message);
    sock.add(utf8.encode(command));
    return _volume;
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

  waitingForDeviceToConnect() {}

  deviceConnected(Socket socket) {
    print("连接建立");
    _connectionStatus.add(true);
    sock = socket;

    socket.listen(onData9, onError: (e) {
      print('socket.listen报错 $e');
      _connectionStatus.add(false);
    });

    getFiles(socket, macroConfigFile);
    getFiles(socket, detectFlagFile);
    getFiles(socket, dmsSetupFlagFile);
    getFiles(socket, canInputJsonFile);
    getFiles(socket, mProtocolConfigJsonFile);
    getFiles(socket, mProtocolJsonFile);

    getVolume();
  }
}
