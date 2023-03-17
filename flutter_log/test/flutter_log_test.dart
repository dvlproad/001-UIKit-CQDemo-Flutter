/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-12-19 19:04:01
 * @Description: 
 */
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_log/flutter_log.dart';

void main() {
  test('adds one to input values', () {
    Map keyValue = {};
    String keyValueString = FormatterUtil.convert(keyValue, 0, isObject: true);
    debugPrint("keyValueString = $keyValueString");
    expect(keyValueString, "{}");
  });
}
