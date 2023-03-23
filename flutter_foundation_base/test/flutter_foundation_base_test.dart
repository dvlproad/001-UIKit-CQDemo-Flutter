/*
 * @Author: dvlproad
 * @Date: 2023-03-23 21:31:09
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 22:57:17
 * @FilePath: /flutter_foundation_base/test/flutter_foundation_base_test.dart
 * @Description: 单元测试
 */
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_foundation_base/flutter_foundation_base.dart';

void main() {
  test('adds one to input values', () {
    Map keyValue = {};
    String keyValueString = FormatterUtil.convert(keyValue, 0, isObject: true);
    debugPrint("keyValueString = $keyValueString");
    expect(keyValueString, "{}");
  });
}
