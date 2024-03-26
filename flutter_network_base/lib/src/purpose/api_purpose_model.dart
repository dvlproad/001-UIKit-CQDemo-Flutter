/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-22 11:55:55
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
    return "{caller:$caller,purpose:$purpose}";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> responseMap = {};
    responseMap.addAll({"caller": caller});

    responseMap.addAll({"purpose": purpose});

    return responseMap;
  }
}

extension ParamAddPurposeExtension on Map<String, dynamic> {
  Map<String, dynamic> addPurpose({
    required String caller,
    required String purpose,
  }) {
    Map<String, dynamic> newMap = this;
    newMap.addAll({
      "ApiPurpose": {
        "caller": caller,
        "purpose": purpose,
      }
    });
    return newMap;
  }
}

extension ParamAddPurposeFromDetailMapExtension on Map<String, dynamic> {
  Map<String, dynamic> tryAddPurposeFromDetailMap(
      Map<String, dynamic> detailLogJsonMap) {
    Map<String, dynamic> newMap = this;
    if (detailLogJsonMap["BODY"]['ApiPurpose'] != null) {
      newMap.addAll({"ApiPurpose": detailLogJsonMap["BODY"]['ApiPurpose']});
    }

    return newMap;
  }
}
