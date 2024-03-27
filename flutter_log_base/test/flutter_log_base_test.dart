/*
 * @Author: dvlproad dvlproad@163.com
 * @Date: 2023-03-21 20:30:53
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-27 17:51:41
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
      "ApiPeople": ApiPeopleBean(pid: "body_apier21").toMap(),
      "AppPeople": ApiPeopleBean(pid: "body_apier21").toMap(),
    };

    // 这是正确的
    String accountId = "123456";
    Map testTypeMap = {
      "a": 1,
      "b": {
        "pageNum": 1,
        "pageSize": 10,
        "accountId": accountId,
      }
          .addPurpose(caller: "广场页", purpose: "查询频道内容数据")
          .addApier(ApiPeopleBean(pid: "apier11"))
          .addApper(ApiPeopleBean(pid: "apper11"))
          .addPurposeFromBodyMap(bodyJsonMap)
          .addPeopleFromBodyMap(bodyJsonMap),
    };
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

    dd12.addApier(ApiPeopleBean(pid: "apier11"));
    dd12.addApper(ApiPeopleBean(pid: "apper11"));
    debugPrint("===== people更改前=$dd12");
    dd12.addPeopleFromBodyMap(bodyJsonMap);
    debugPrint("===== people更改后=$dd12");
    */
  });
}
