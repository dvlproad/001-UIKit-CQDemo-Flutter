/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-28 15:04:38
 * @Description: Api负责人模型
 */
import 'package:flutter/foundation.dart';

class LogPeopleBean {
  final String pid;
  final String name;

  LogPeopleBean({
    required this.pid,
    required this.name,
  });

  @override
  String toString() {
    return "{pid:$pid,name:$name}";
  }

  static LogPeopleBean formJson(Map<String, dynamic> json) {
    return LogPeopleBean(
      pid: json["pid"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> responseMap = {};
    responseMap.addAll({"pid": pid, "name": name});

    return responseMap;
  }
}

extension ParamAddPeopleExtension on Map {
  // 1、会添加到 api 请求的 body 中
  Map<String, dynamic> addApier(LogPeopleBean apier) {
    try {
      // 创建一个新的 Map，该 Map 保留原始 Map 的键值对和类型
      Map<String, dynamic> newMap = Map<String, dynamic>.from(this);
      // 创建一个新的 Map，将 Map 中的键和值强制转换为指定类型。经常引起错误
      // Map<String, dynamic> newMap = cast<String, dynamic>();
      newMap.addAll({"ApiPeople": apier.toMap()});
      return newMap;
    } catch (err) {
      // 避免类似转换错误
      debugPrint("addApier error:$err");
      return this as Map<String, dynamic>;
    }
  }

  Map<String, dynamic> addApper(LogPeopleBean apper) {
    try {
      // 创建一个新的 Map，该 Map 保留原始 Map 的键值对和类型
      Map<String, dynamic> newMap = Map<String, dynamic>.from(this);
      // 创建一个新的 Map，将 Map 中的键和值强制转换为指定类型。经常引起错误
      // Map<String, dynamic> newMap = cast<String, dynamic>();
      newMap.addAll({"AppPeople": apper.toMap()});
      return newMap;
    } catch (err) {
      debugPrint("addApper error:$err");
      return this as Map<String, dynamic>;
    }
  }

  String get logApierKey {
    return "ApiPeople";
  }

  String get logApperKey {
    return "AppPeople";
  }

  // 2、从 api 请求的 body 中获取 ApiPeople, 添加到新map的指定字段中
  Map<String, dynamic> addPeopleFromBodyMap(Map<String, dynamic> bodyJsonMap) {
    try {
      // 创建一个新的 Map，该 Map 保留原始 Map 的键值对和类型
      Map<String, dynamic> newMap = Map<String, dynamic>.from(this);
      // 创建一个新的 Map，将 Map 中的键和值强制转换为指定类型。经常引起错误
      // Map<String, dynamic> newMap = cast<String, dynamic>();
      if (bodyJsonMap['ApiPeople'] != null) {
        newMap.addAll({logApierKey: bodyJsonMap['ApiPeople']});
      }
      if (bodyJsonMap['AppPeople'] != null) {
        newMap.addAll({logApperKey: bodyJsonMap['AppPeople']});
      }
      return newMap;
    } catch (err) {
      debugPrint("addPeopleFromBodyMap error:$err");
      return this as Map<String, dynamic>;
    }
  }

  // 3、对从 api 请求的 body 中获取并添加的指定字段进行输出
  String? get logPeoplesString {
    String _logPeopleString = "";
    if (this[logApierKey] != null && this[logApierKey].isNotEmpty) {
      Map<String, dynamic> peopleJson = this[logApierKey];
      String uname = peopleJson["name"] ?? "";
      _logPeopleString += "-> $uname";
    }

    if (this[logApperKey] != null && this[logApperKey].isNotEmpty) {
      Map<String, dynamic> peopleJson = this[logApperKey];
      String uname = peopleJson["name"] ?? "";
      _logPeopleString += "-> $uname";
    }

    if (_logPeopleString.isEmpty) {
      return null;
    }
    return _logPeopleString;
  }

  // 发送到企业微信等时候，一般需要从此model中拿id
  LogPeopleBean? get logApier {
    if (this[logApierKey] == null || this[logApierKey].isEmpty) {
      return null;
    }
    Map<String, dynamic> peopleJson = this[logApierKey];
    return LogPeopleBean.formJson(peopleJson);
  }

  LogPeopleBean? get logApper {
    if (this[logApperKey] == null || this[logApperKey].isEmpty) {
      return null;
    }
    Map<String, dynamic> peopleJson = this[logApperKey];
    return LogPeopleBean.formJson(peopleJson);
  }
}
