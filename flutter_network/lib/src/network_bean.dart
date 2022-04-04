class ResponseModel {
  int statusCode;
  String message;
  dynamic result;
  bool isCache;

  ResponseModel({this.statusCode, this.message, this.result, this.isCache});

  bool get isSuccess => statusCode == 0;
}

enum RequestMethod {
  post,
  get,
}
