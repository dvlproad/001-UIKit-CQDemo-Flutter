/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 18:01:14
 * @Description: 
 */
import 'dart:math';

// 需要 import 'dart:math';
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

enum CQRipeStringType {
  none, // 中英文+数字任意
  number, // 数字
  english, //英文字母
  chinese, // 中文
}

String cqtsRandomString(
  int minLength,
  int maxLength,
  CQRipeStringType stringType,
) {
  Iterable<int> charCodes = Iterable.generate(
    maxLength,
    (_) {
      return _chars.codeUnitAt(_rnd.nextInt(_chars.length));
    },
  );
  return String.fromCharCodes(
    charCodes,
    minLength,
    maxLength,
  );
}
