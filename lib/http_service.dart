import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_app/configurations.dart';
import 'package:flutter_app/home.dart';
import 'package:http/http.dart' as http;


class Path {
  static final c4Version = "/api/v1/get_c4_version";
  static final adasPicture = "/api/v1/get_camera_image?camera=adas";
  static final dmsPicture = "/api/v1/get_camera_image?camera=driver";
  static final setCamera = "";
  static final deviceType = "/api/v1/get_device_type";
  static final adasStatus = "/api/v1/get_service_status?service=adas";
  static final dmsStatus = "/api/v1/get_service_status?service=dms";
  static final readFile = "/api/v1/read_file?path=";
  static final writeFile = "/api/v1/write_file?path=";


}

// "stopped" "running"

class ServiceStatus {
  static final String stopped = "stopped";
  static final String running = "running";
  static final String restarting = "restarting";
}

// "ok"
class MResult {
  static final String OK = "OK";
}

enum ServiceType {
  adas,dms
}


class HttpResult<T> {
  bool success = true;
  String message = "";
  Uint8List data = null;
  T model;
}

class ServiceModel {
  ServiceType type;
  bool isRunning = false;
  String status = "";

  ServiceModel(ServiceType type){
    this.type = type;
  }

}

class ConfigManager {
  CanInputJsonFile canFile = CanInputJsonFile();
  DmsSetupFlagFile dmsFile = DmsSetupFlagFile();
  DetectFlagFile detectFile = DetectFlagFile();
  MacrosConfigTextFile carFile = MacrosConfigTextFile();
  MProtocolConfigJsonFile protocolConfigFile = MProtocolConfigJsonFile();
  MProtocolJsonFile protocolFile = MProtocolJsonFile();



  static ConfigManager shared = ConfigManager();



  Future<Uint8List> getFile(ConfigurationFile file) {
    return HttpService.shared.readFile(file.path)
        .timeout(httpTimeoutInterval);
  }

  Future writeFile(ConfigurationFile file) {
    return HttpService.shared.writeToFile(file.path, jsonEncode(file.config))
        .timeout(httpTimeoutInterval);
  }


}


class ServiceManager {
  static final String adas = "adas";
  static final String dms = "dms";

  ServiceModel adasData = ServiceModel(ServiceType.adas);
  ServiceModel dmsData = ServiceModel(ServiceType.dms);

  static ServiceManager shared = ServiceManager();

  String nameOfService(ServiceType type) {
    if (type == ServiceType.adas) {
      return adas;
    } else {
      return dms;
    }
  }

  final String startPath = "/api/v1/start_service?service=";
  final String stopPath = "/api/v1/stop_service?service=";
  final String statusPath = "/api/v1/get_service_status?service=";
  final String cameraPath = "/api/v1/get_camera_image?camera=";

  Future<bool> startService(ServiceType type) async {
    final service = nameOfService(type);
    var resp = await http.post(HttpService.host + startPath + service);
    print("request " + resp.request.url.toString() + "\nresp.body " + resp.body);
    if (resp.statusCode == 200) {
      return resp.body == MResult.OK;
    } else {
      return Future.error("Start Service " + service + " failed");
    }
  }

  Future<bool> stopService(ServiceType type) async {
    final service = nameOfService(type);
    var resp = await http.post(HttpService.host + stopPath + service);
    print("request " + resp.request.url.toString() + "\nresp.body " + resp.body);
    if (resp.statusCode == 200) {
      return resp.body == MResult.OK;
    } else {
      return Future.error("Stop Service " + service + " failed");
    }
  }

  Future<String> getServiceStatus(ServiceType type) async {
    final service = nameOfService(type);
    var resp = await http.get(HttpService.host + statusPath + service);
    print("request " + resp.request.url.toString() + "\nresp.body " + resp.body);
    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      return Future.error("Get Service Status " + service + " failed");
    }
  }
}


class HttpService {
  static var host = "http://192.168.43.1:16402";
  static final shared = HttpService();


  Future<String> getC4Version() async {
    var response = await http.get(host + Path.c4Version);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return Future.error("Response code should be 200.");
    }
  }




  Future<Uint8List> getAdasPicture() async {
    var resp = await http.get(host + Path.adasPicture);
    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return Future.error("get adas camera picture error");
    }
  }


  Future<Uint8List> getDmsPicture() async {
    var resp = await http.get(host + Path.dmsPicture);
    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return Future.error("get dms camera picture error");
    }
  }

  Future<String> writeToFile(String path, data) async {
    var resp = await http.post(host + Path.writeFile +path,headers: {"Content-Type":"application/octet-stream"},body: data);
    print("request " + resp.request.toString());
    print("resp.statusCode " + resp.statusCode.toString());
    print("resp.body " + resp.body);
    if (resp.statusCode == 200) {
      return Utf8Decoder().convert(resp.bodyBytes);
    } else {
      return Future.error("write file " + path + " error");
    }
  }

  Future<Uint8List> readFile(String path) async {
    var resp = await http.get(host+Path.readFile + path);
    print("request " + resp.request.url.toString() + "\nresp.body " + resp.body);
    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return Future.error("read file " + path + " error");
    }
  }


  Future<String> getDeviceType() async {
    var resp = await http.get(host + Path.deviceType);
    print("request " + resp.request.url.toString() + "\nresp.body " + resp.body);
    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      return Future.error("get device type error");
    }
  }



}