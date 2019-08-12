class Response {
  final String type;
  final String result;

  Response(this.type, this.result);

  Response.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        result = json['result']['data'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'result': result,
      };
}
