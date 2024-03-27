/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-27 11:41:57
 * @Description: API的用途模型
 */

class ApiPurposeModel {
  final String caller;
  final String purpose;

  ApiPurposeModel({
    required this.caller,
    required this.purpose,
  });

  @override
  String toString() {
    return "$caller -> $purpose";
  }

  static ApiPurposeModel formJson(Map<String, dynamic> json) {
    return ApiPurposeModel(
      caller: json["caller"] ?? "",
      purpose: json["purpose"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> responseMap = {};
    responseMap.addAll({"caller": caller});

    responseMap.addAll({"purpose": purpose});

    return responseMap;
  }
}

extension ParamAddPurposeExtension on Map {
  // 1、会添加到 api 请求的 body 中
  Map<String, dynamic> addPurpose({
    required String caller,
    required String purpose,
  }) {
    Map<String, dynamic> newMap = cast<String, dynamic>();
    newMap.addAll({
      "ApiPurpose": {"caller": caller, "purpose": purpose}
    });
    return newMap;
  }

  String get logPurposeKey {
    return "ApiPurpose";
  }

  // 2、从 api 请求的 body 中获取 ApiPurpose, 添加到新map的指定字段中
  Map<String, dynamic> addPurposeFromBodyMap(Map<String, dynamic> bodyJsonMap) {
    Map<String, dynamic> newMap = cast<String, dynamic>();
    if (bodyJsonMap['ApiPurpose'] != null) {
      newMap.addAll({logPurposeKey: bodyJsonMap['ApiPurpose']});
    }
    return newMap;
  }

  // 3、对从 api 请求的 body 中获取并添加的指定字段进行输出
  String? get logPurposeString {
    if (this[logPurposeKey] == null || this[logPurposeKey].isEmpty) {
      return null;
    }

    Map<String, dynamic> purposeJson = this[logPurposeKey];
    String apiCaller = purposeJson["caller"] ?? "未知页";
    String apiPurpose = purposeJson["purpose"] ?? "未知用途";
    return "$apiCaller -> $apiPurpose";
  }
}
