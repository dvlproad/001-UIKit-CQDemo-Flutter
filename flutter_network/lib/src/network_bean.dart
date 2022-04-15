class ResponseModel {
  int statusCode;
  String message;
  dynamic result;
  bool isCache;

  ResponseModel({this.statusCode, this.message, this.result, this.isCache});

  bool get isSuccess => statusCode == 0;

  /// 获取错误时候的 responseModel
  static ResponseModel errorResponseModel(String message) {
    ResponseModel responseModel = ResponseModel(
      statusCode: -1,
      message: message,
      result: null,
    );
    return responseModel;
  }
}

enum RequestMethod {
  post,
  get,
}
