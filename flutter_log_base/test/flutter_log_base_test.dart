/*
 * @Author: dvlproad dvlproad@163.com
 * @Date: 2023-03-21 20:30:53
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-28 11:54:09
 * @FilePath: /flutter_log_base/test/flutter_log_base_test.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_log_base/flutter_log_base.dart';

void main() {
  test('adds one to input values', () {
    Map<String, dynamic> bodyJsonMap = {
      "ApiPurpose":
          ApiPurposeModel(caller: "caller21", purpose: "purpose21").toMap(),
      "ApiPeople":
          LogPeopleBean(pid: "body_apier21", name: "body_接口人21").toMap(),
      "AppPeople":
          LogPeopleBean(pid: "body_apper21", name: "body_前端人21").toMap(),
    };

    // 这是正确的
    String content = "hello world";
    // CQTODO:
    // 为什么以下两个类有区别，testTypeMap1 会导致错误，而 testTypeMap2 不会
    // Map testTypeMap1 = {"content": content, "b": "hh"};
    // Map testTypeMap2 = {
    //   "content": content,
    //   "b": {"hh"}
    // };
    Map testTypeMap = {
      "content": content,
      "b": {"hh"},
    }
        .addPurpose(caller: "广场页", purpose: "查询频道内容数据")
        .addApier(LogPeopleBean(pid: "apier11", name: "接口人11"))
        .addApper(LogPeopleBean(pid: "apper11", name: "前端人11"))
        .addPurposeFromBodyMap(bodyJsonMap)
        .addPeopleFromBodyMap(bodyJsonMap);

    debugPrint("===== testTypeMap=$testTypeMap");
    return;
    /*
    Map<String, dynamic> dd12 = {
      "pageNum": 1,
      "pageSize": 10,
      "accountId": "12345678",
    };
    dd12.addPurpose(caller: "广场页", purpose: "查询频道内容数据");
    debugPrint("===== purpose更改前=$dd12");

    dd12.addPurposeFromBodyMap(bodyJsonMap);
    debugPrint("===== purpose更改后=$dd12");

    debugPrint("");
    dd12.addAll({"newKey1": "newValue1"});
    debugPrint("");

    dd12.addApier(LogPeopleBean(pid: "apier11"));
    dd12.addApper(LogPeopleBean(pid: "apper11"));
    debugPrint("===== people更改前=$dd12");
    dd12.addPeopleFromBodyMap(bodyJsonMap);
    debugPrint("===== people更改后=$dd12");
    */
  });
}
