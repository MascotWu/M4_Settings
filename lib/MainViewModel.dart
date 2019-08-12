import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_app/version.dart';
import 'package:rxdart/rxdart.dart';

class MainViewModel {
  var _connectionStatus = new BehaviorSubject<bool>();

  MainViewModel() {
    ServerSocket.bind(InternetAddress.anyIPv4, 16346)
        .then(onDataReceived, onError: onError)
        .catchError(onError2);
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
    value.listen(onData8, onError: onError3);
  }

  var sock;

  void onData8(Socket socket) {
    sock = socket;
    socket.listen(onData9);

    var message = Uint8List(4);
    var bytedata = ByteData.view(message.buffer);

//    bytedata.setUint8(0, 0x00);
//    bytedata.setUint8(1, 0x00);
//    bytedata.setUint8(2, 0x00);
//    bytedata.setUint8(3, 40);
//
//    socket.add(message);
//    socket.add(utf8.encode('{"type": "get_c4_version", "data": null}'));

    //---
    bytedata.setUint8(0, 0x00);
    bytedata.setUint8(1, 0x00);
    bytedata.setUint8(2, 0x00);
    bytedata.setUint8(3, 59);

    socket.add(message);
    socket.add(utf8
        .encode('{"type": "read_file", "data": "/sdcard/run/can_input.json"}'));
  }

  Observable<String> getVersion() {
    // send
    sock.add();
    // receive
    FutureOr<String> Function() computation;
    Future<String> fu = new Future(computation);

    return Observable.fromFuture(fu);
  }

  var config;

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
      total = total - (event.length - 4);
    }
    if (state == 'amend') {
      total -= event.length;
      if (total == 0) {
        state = 'first';

        var jsonDecode2 =
            jsonDecode(String.fromCharCodes(event.getRange(4, event.length)));

        var response = Response.fromJson(jsonDecode2);

        if (response.type == 'read_file_ok')
          config = jsonDecode(String.fromCharCodes(
              base64Decode(Response.fromJson(jsonDecode2).result)));
      }
    }
  }

  onError(e) {
    print("Error:没有网络的时候 ");

    print(e);
    _connectionStatus.add(false);
  }

  onError2(e) {
    print("ffasd");
  }

  onError3(e) {
    print(e);
  }

  void handleData(List<int> data, EventSink<Uint8List> sink) {}
}
