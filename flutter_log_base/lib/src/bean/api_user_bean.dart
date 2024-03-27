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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> responseMap = {};
    responseMap.addAll({"pid": pid});

    return responseMap;
  }
}

extension ParamAddPeopleExtension on Map<String, dynamic> {
  // 1、会添加到 api 请求的 body 中
  Map<String, dynamic> addPeople({
    required String pid,
  }) {
    Map<String, dynamic> newMap = this;
    newMap.addAll({
      "ApiPeople": {
        "pid": pid,
      }
    });
    return newMap;
  }

  String get logPeopleKey {
    return "ApiPeople";
  }

  // 2、从 api 请求的 body 中获取 ApiPeople, 添加到新map的指定字段中
  Map<String, dynamic> addPeopleFromBodyMap(Map<String, dynamic> bodyJsonMap) {
    Map<String, dynamic> newMap = this;
    if (bodyJsonMap['ApiPeople'] != null) {
      newMap.addAll({logPeopleKey: bodyJsonMap['ApiPeople']});
    }

    return newMap;
  }

  // 3、对从 api 请求的 body 中获取并添加的指定字段进行输出
  String? get logPeopleString {
    if (this[logPeopleKey] == null || this[logPeopleKey].isEmpty) {
      return null;
    }

    Map<String, dynamic> peopleJson = this[logPeopleKey];
    String? pid = peopleJson["pid"];
    if (pid == null || pid.isEmpty) {
      return null;
    }
    return "-> $pid";
  }
}
