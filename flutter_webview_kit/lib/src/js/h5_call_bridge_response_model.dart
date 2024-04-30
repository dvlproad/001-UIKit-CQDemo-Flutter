/*
 * @Author: dvlproad
 * @Date: 2023-01-13 18:54:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-20 11:54:57
 * @Description: 
 */
class JSResponseModel {
  final int resultCode;
  final String? message;
  final dynamic result;

  JSResponseModel({
    this.resultCode = 0,
    this.message,
    this.result,
  });

  static Map<String, dynamic> initMap({
    String? message,
  }) {
    return JSResponseModel(
      resultCode: 0,
    ).toMap();
  }

  static Map<String, dynamic> errorMap({
    String? message,
  }) {
    return JSResponseModel(resultCode: 1, message: message).toMap();
  }

  static Map<String, dynamic> successMap({
    required bool isSuccess,
    dynamic result,
  }) {
    return JSResponseModel(
      resultCode: isSuccess ? 1 : 0,
      result: result,
    ).toMap();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> responseMap = {};

    responseMap.addAll({"resultCode": resultCode});
    if (message != null) {
      responseMap.addAll({"message": message});
    }
    if (result != null) {
      responseMap.addAll({"result": result});
    }
    return responseMap;
  }

  bool get isSuccess => resultCode == 0;
}
