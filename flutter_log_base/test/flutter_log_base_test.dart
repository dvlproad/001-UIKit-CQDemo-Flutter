// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad dvlproad@163.com
 * @Date: 2023-03-21 20:30:53
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-28 15:03:41
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

    // 单独测试
    Map<String, dynamic> purpose_params1 = {
      "pageIndex": 1,
    }.addPurpose(caller: "广场页", purpose: "查询频道内容数据");
    debugPrint("===== purpose_params1=$purpose_params1");
    debugPrint("");

    Map<String, dynamic> purpose_params2 = {
      "pageIndex": 1,
    }.addPurposeFromBodyMap(bodyJsonMap);
    debugPrint("===== purpose_params2=$purpose_params2");
    debugPrint("");

    var apier_params = {
      "pageIndex": 1,
    }.addApier(LogPeopleBean(pid: "apier11", name: "接口人11"));
    debugPrint("===== apier_params=$apier_params");
    debugPrint("");

    var apper_params = {
      "pageIndex": 1,
    }.addApper(LogPeopleBean(pid: "apper11", name: "前端人11"));
    debugPrint("===== apper_params=$apper_params");
    debugPrint("");

    Map people_params2 = {
      "pageIndex": 1,
    }.addPeopleFromBodyMap(bodyJsonMap);
    debugPrint("===== people_params2=$people_params2");
    debugPrint("");

    // 连锁测试
    debugPrint("===========连锁测试===========");
    var purpose_people_params1 = {
      "pageIndex": 1,
    }
        .addPurpose(caller: "广场页", purpose: "查询频道内容数据")
        .addApier(LogPeopleBean(pid: "apier11", name: "接口人11"))
        .addApper(LogPeopleBean(pid: "apper11", name: "前端人11"));
    debugPrint("===== purpose_people_params1=$purpose_people_params1");

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
