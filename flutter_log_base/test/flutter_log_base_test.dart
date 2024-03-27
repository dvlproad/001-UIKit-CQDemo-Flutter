/*
 * @Author: dvlproad dvlproad@163.com
 * @Date: 2023-03-21 20:30:53
 * @LastEditors: dvlproad dvlproad@163.com
 * @LastEditTime: 2023-03-24 01:18:40
 * @FilePath: /flutter_log_base/test/flutter_log_base_test.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_log_base/flutter_log_base.dart';

void main() {
  test('adds one to input values', () {
    // 这是正确的
    // Map dd11 = {
    //   "pageNum": 1,
    //   "pageSize": 10,
    //   "accountId": "12345678",
    // };
    // dd11.addPurpose(caller: "广场页", purpose: "查询频道内容数据");
    // dd11.addAll({"newKey1": "newValue1"});
    // debugPrint("dd1=$dd11");

    Map<String, dynamic> dd12 = {
      "pageNum": 1,
      "pageSize": 10,
      "accountId": "12345678",
    };
    dd12.addPurpose(caller: "广场页", purpose: "查询频道内容数据");
    debugPrint("===== purpose更改前=$dd12");

    Map<String, dynamic> bodyJsonMap = {
      "ApiPurpose":
          ApiPurposeModel(caller: "caller21", purpose: "purpose21").toMap(),
      "ApiPeople": ApiPeopleBean(pid: "apier21").toMap(),
      "AppPeople": ApiPeopleBean(pid: "apier21").toMap(),
    };
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

    /*
    // 以下错误：在 Dart 中，无法直接将方法链式调用应用于字面量对象。字面量对象在定义时是不可变的，无法动态添加方法。
    var dd2 = {
      "pageNum": 1,
      "pageSize": 10,
      "accountId": "12345678",
    }.addPurpose(caller: "广场页", purpose: "查询频道内容数据");
    dd2.addAll({"newKey2": "newValue"});
    debugPrint("dd2=$dd2");
    */
  });
}
