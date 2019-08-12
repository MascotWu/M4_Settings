import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

  setCameraConfiguration(configurations) {
    macrosConfigTextFile.addAll(configurations);

    var message = Uint8List(4);
    var bytedata = ByteData.view(message.buffer);

    var command =
        '{"type":"write_file","data":{"path":"/sdcard/run/macros_config.txt","data":"' +
            base64Encode(utf8.encode(gflagEncode(macrosConfigTextFile))) +
            '"}}';

    bytedata.setUint32(0, command.length);

    sock.add(message);
    sock.add(utf8.encode(command));

//    command =
//        '{"type":"write_file","data":{"path":"/sdcard/run/detect.flag","data":"' +
//            base64Encode(utf8.encode(gflagEncode(config))) +
//            '"}}';
//
//    bytedata.setUint32(0, command.length);
//
//    sock.add(message);
//    sock.add(utf8.encode(command));
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
      socket.listen(onData);
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

  var sock;

  void onData8(Socket socket) {
    sock = socket;
    socket.listen(onData9);

    var message = Uint8List(4);
    var byteData = ByteData.view(message.buffer);
    var command =
        '{"type": "read_file", "data": "/sdcard/run/macros_config.txt"}';
    byteData.setUint32(0, command.length);

    socket.add(message);
    socket.add(utf8.encode(command));
  }

  Map<String, dynamic> macrosConfigTextFile;

  var length = 0;
  var total;
  var state = "first";
  List<int> buffer = [];

  void onData9(List<int> event) {
    if (state == 'first') {
      total = event[0] * 0x01000000 +
          event[1] * 0x010000 +
          event[2] * 0x0100 +
          event[3];

      buffer.addAll(event);
      state = 'amend';
      total -= event.length - 4;
    }
    if (state == 'amend') {
      if (total == 0) {
        state = 'first';

        var jsonDecode2 =
            jsonDecode(String.fromCharCodes(buffer.getRange(4, buffer.length)));

        if (jsonDecode2['type'] == 'read_file_ok') {
          macrosConfigTextFile = gflagDecode(String.fromCharCodes(
              base64Decode(jsonDecode2['result']['data'])));
          _cameraConfiguration.add(macrosConfigTextFile);
        }
        if (jsonDecode2['type'] == 'write_file_ok') {
          print('write file ok');
        }
      } else {
        total -= event.length;
      }
      buffer.clear();
    }
  }

  onError(e) {
    print("Error:没有网络的时候 ");

    print(e);
    _connectionStatus.add(false);
  }
}
