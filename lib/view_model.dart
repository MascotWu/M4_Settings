import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_app/configurations.dart';
import 'package:rxdart/rxdart.dart';

import 'convert.dart';

class ViewModel {
  var _connectionStatus = new BehaviorSubject<bool>();
  var _cameraConfiguration = new BehaviorSubject<Map<String, dynamic>>();

  ViewModel() {
    ServerSocket.bind(InternetAddress.anyIPv4, 16346)
        .then(onDataReceived, onError: onError)
        .catchError(onError);
  }

  static ViewModel vm = new ViewModel();

  static get() {
    return vm;
  }

  getCameraConfig() {
    return _cameraConfiguration;
  }

  addOrUpdate(ConfigurationFile file, configurations) {
    file.config.addAll(configurations);
    push(file);
  }

  addOrUpdateSpeed(int speed) {
    if (canInputJsonFile.config.containsKey('main')) {
      canInputJsonFile.config['main']['fake_speed'] = speed;
      push(canInputJsonFile);
    }
  }

  addOrUpdateBaudRate(String baudRate) {
    if (canInputJsonFile.config.containsKey('main')) {
      canInputJsonFile.config['main']['baudrate'] = baudRate;
      push(canInputJsonFile);
    }
  }

  deleteSpeed() {
    if (canInputJsonFile.config.containsKey('main') &&
        canInputJsonFile.config['main'].containsKey('fake_speed')) {
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

  establishConnection() {
    // if server socket have not established yet
    // then establish it.

    // connect device and waiting
    Socket.connect("192.168.43.1", 16400).then((Socket socket) {
      socket.listen(onData, onError: onError);
      socket.write('set_instruction_server_host this\n');
      print("Connect成功");
    }, onError: (e) {
      print("e");
      print(e);
      _connectionStatus.add(false);
    });
  }

  clear() {}

  void onData(List<int> event) {
    _connectionStatus.add(String.fromCharCodes(event) == "OK\n");
    print("Connect成功，收到OK");
  }

  FutureOr onDataReceived(ServerSocket value) {
    print("开始监听");
    value.listen(onData8, onError: onError);
  }

  Socket sock;

  MacrosConfigTextFile macroConfigFile = new MacrosConfigTextFile();
  DetectFlagFile detectFlagFile = new DetectFlagFile();
  DmsSetupFlagFile dmsSetupFlagFile = new DmsSetupFlagFile();
  CanInputJsonFile canInputJsonFile = new CanInputJsonFile();
  MProtocolConfigJsonFile mProtocolConfigJsonFile =
      new MProtocolConfigJsonFile();
  MProtocolJsonFile mProtocolJsonFile = new MProtocolJsonFile();

  void onData8(Socket socket) {
    sock = socket;
    socket.listen(onData9, onError: onError);

    getFiles(socket, macroConfigFile);
    getFiles(socket, detectFlagFile);
    getFiles(socket, dmsSetupFlagFile);
    getFiles(socket, canInputJsonFile);
  }

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
    print('通信成功');
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
            macroConfigFile.config = gflagDecode(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
            _cameraConfiguration.add(macroConfigFile.config);
          } else if (socketMessage['result']['path'] == detectFlagFile.path) {
            detectFlagFile.config = gflagDecode(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          } else if (socketMessage['result']['path'] == canInputJsonFile.path) {
            canInputJsonFile.config = jsonDecode(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          } else if (socketMessage['result']['path'] == dmsSetupFlagFile.path) {
            dmsSetupFlagFile.config = gflagDecode(String.fromCharCodes(
                base64Decode(socketMessage['result']['data'])));
          }
        } else if (socketMessage['type'] == 'read_file_error') {
          print('read_file_error');
        } else if (socketMessage['type'] == 'write_file_ok') {
          print('write file ok');
        } else if (socketMessage['type'] == 'write_file_error') {
          print('write file error');
        } else if (socketMessage['type'] == 'get_camera_image_ok') {
          if (socketMessage['result']['camera'] == 'adas') {
            print('get_camera_image_ok');
            _adasPicture.add(base64Decode(socketMessage['result']['image']));
          } else if (socketMessage['result']['camera'] == 'driver') {
            _dmsPicture.add(base64Decode(socketMessage['result']['image']));
          }
        } else if (socketMessage['type'] == 'get_camera_image_error') {
          print('get_camera_image_error');
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

  onError(e) {
    print("Error:没有网络的时候 ");

    print(e);
    _connectionStatus.add(false);
  }
}
