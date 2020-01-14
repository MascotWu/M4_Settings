import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class Path {
  static final adasPicture = "/api/v1/get_camera_image?camera=adas";
  static final dmsPicture = "/api/v1/get_camera_image?camera=driver";
  static final setCamera = "";
}

class HttpService {
  static var host = "http://192.168.43.1:16402";
  static final shared = HttpService();

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




}