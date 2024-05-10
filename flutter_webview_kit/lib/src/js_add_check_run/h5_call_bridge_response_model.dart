/*
 * @Author: dvlproad
 * @Date: 2023-01-13 18:54:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 11:10:55
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

  static JSResponseModel init({
    String? message,
  }) {
    return JSResponseModel(
      resultCode: 0,
    );
  }

  static JSResponseModel error({
    String? message,
  }) {
    return JSResponseModel(resultCode: 1, message: message);
  }

  static JSResponseModel success({
    required bool isSuccess,
    dynamic result,
  }) {
    return JSResponseModel(
      resultCode: isSuccess ? 1 : 0,
      result: result,
    );
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
