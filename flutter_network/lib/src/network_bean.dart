/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-16 01:17:08
 * @Description: 服务器返回的数据模型
 */
class ResponseModel {
  int statusCode;
  String message;
  dynamic result;
  bool isCache;

  ResponseModel({this.statusCode, this.message, this.result, this.isCache});

  bool get isSuccess => statusCode == 0;

  /// 获取错误时候的 responseModel
  static ResponseModel errorResponseModel(String message, {bool isCache}) {
    ResponseModel responseModel = ResponseModel(
      statusCode: -1,
      message: message,
      result: null,
      isCache: isCache,
    );
    return responseModel;
  }
}

enum RequestMethod {
  post,
  get,
}
