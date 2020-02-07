class CameraPosition {
  double carWidth;

  double cameraHeight;

  double cameraLeftDist;

  double cameraRightDist;

  double cameraFrontDist;

  double frontWheelFrontDist;

  CameraPosition();

  CameraPosition.fromJson(Map<String, dynamic> json)
      : carWidth = double.parse(json["carWidth"]),
        cameraHeight = double.parse(json["cameraHeight"]),
        cameraLeftDist = double.parse(json["cameraLeftDist"]),
        cameraRightDist = double.parse(json["cameraRightDist"]),
        cameraFrontDist = double.parse(json["cameraFrontDist"]),
        frontWheelFrontDist = double.parse(json["frontWheelFrontDist"]);

  Map<String, String> toJson() => <String, String>{
        "carWidth": carWidth.toString(),
        "cameraHeight": cameraHeight.toString(),
        "cameraLeftDist": cameraLeftDist.toString(),
        "cameraRightDist": cameraRightDist.toString(),
        "cameraFrontDist": cameraFrontDist.toString(),
        "frontWheelFrontDist": frontWheelFrontDist.toString(),
      };
}

class CameraOriginalPosition extends CameraPosition {
  double cameraLeftGlassDist;
  double cameraRightGlassDist;

  CameraOriginalPosition();

  CameraOriginalPosition.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    cameraLeftGlassDist = double.parse(json["cameraLeftGlassDist"]);
    cameraRightGlassDist = double.parse(json["cameraRightGlassDist"]);
  }

  Map<String, String> toJson() {
    var json = super.toJson();
    json["cameraLeftGlassDist"] = cameraLeftGlassDist.toString();
    json["cameraRightGlassDist"] = cameraRightGlassDist.toString();
    return json;
  }
}
