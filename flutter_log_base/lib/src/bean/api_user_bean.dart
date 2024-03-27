/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-27 12:38:00
 * @Description: Api负责人模型
 */
class ApiPeopleBean {
  String pid;

  ApiPeopleBean({
    required this.pid,
  });

  @override
  String toString() {
    return "{pid:$pid}";
  }

  static ApiPeopleBean formJson(Map<String, dynamic> json) {
    return ApiPeopleBean(
      pid: json["pid"],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> responseMap = {};
    responseMap.addAll({"pid": pid});

    return responseMap;
  }
}

extension ParamAddPeopleExtension on Map<String, dynamic> {
  // 1、会添加到 api 请求的 body 中
  void addApier(ApiPeopleBean apier) {
    addAll({"ApiPeople": apier.toMap()});
  }

  void addApper(ApiPeopleBean apper) {
    addAll({"AppPeople": apper.toMap()});
  }

  String get logApierKey {
    return "ApiPeople";
  }

  String get logApperKey {
    return "AppPeople";
  }

  // 2、从 api 请求的 body 中获取 ApiPeople, 添加到新map的指定字段中
  Map<String, dynamic> addPeopleFromBodyMap(Map<String, dynamic> bodyJsonMap) {
    Map<String, dynamic> newMap = this;
    if (bodyJsonMap['ApiPeople'] != null) {
      newMap.addAll({logApierKey: bodyJsonMap['ApiPeople']});
    }
    if (bodyJsonMap['AppPeople'] != null) {
      newMap.addAll({logApperKey: bodyJsonMap['AppPeople']});
    }

    return newMap;
  }

  // 3、对从 api 请求的 body 中获取并添加的指定字段进行输出
  String? get logPeoplesString {
    String _logPeopleString = "";
    if (this[logApierKey] != null && this[logApierKey].isNotEmpty) {
      Map<String, dynamic> peopleJson = this[logApierKey];
      String pid = peopleJson["pid"] ?? "";
      _logPeopleString += "-> $pid";
    }

    if (this[logApperKey] != null && this[logApperKey].isNotEmpty) {
      Map<String, dynamic> peopleJson = this[logApperKey];
      String pid = peopleJson["pid"] ?? "";
      _logPeopleString += "-> $pid";
    }

    if (_logPeopleString.isEmpty) {
      return null;
    }
    return _logPeopleString;
  }

  // 发送到企业微信等时候，一般需要从此model中拿id
  ApiPeopleBean? get logApier {
    if (this[logApierKey] == null || this[logApierKey].isEmpty) {
      return null;
    }
    Map<String, dynamic> peopleJson = this[logApierKey];
    return ApiPeopleBean.formJson(peopleJson);
  }

  ApiPeopleBean? get logApper {
    if (this[logApperKey] == null || this[logApperKey].isEmpty) {
      return null;
    }
    Map<String, dynamic> peopleJson = this[logApperKey];
    return ApiPeopleBean.formJson(peopleJson);
  }
}
