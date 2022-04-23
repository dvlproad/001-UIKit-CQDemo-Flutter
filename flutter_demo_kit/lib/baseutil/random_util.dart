/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-23 21:27:18
 * @Description: 在 Dart（以及 Flutter）中生成随机字符串的 3 种不同方法
 * 参考文章:[在 Dart（以及 Flutter）中生成随机字符串的 3 种不同方法](https://developer.aliyun.com/article/852404)
 */
import 'dart:math';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';

// void main() {
//   debugPrint(generateRandomString(10));
//   debugPrint(generateRandomString(20));
// }

// 生成具有给定长度的随机字符串。结果将仅包含字母和数字（az、AZ、0-9）
// Define a reusable function
String generateRandomString(int length) {
  final _random = Random();
  const _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
          (index) => _availableChars[_random.nextInt(_availableChars.length)])
      .join();

  return randomString;
}

// 生成具有给定长度的随机字符串。结果将包含特殊字符。
// Declare a fucntion for reusable purpose
String generateRandomString2(int len) {
  final _random = Random();
  final result = String.fromCharCodes(
      List.generate(len, (index) => _random.nextInt(33) + 89));
  return result;
}

// 使用加密库 这种方法利用了 Dart 团队发布的crypto包。下面的示例将使用 md5 散列和 sha1 散列来生成随机字符串。
// void main() {
//   debugPrint(md5RandomString());
//   debugPrint(sha1RandomString());
// }
// md5 hashing a random number
String md5RandomString() {
  final randomNumber = Random().nextDouble();
  final randomBytes = utf8.encode(randomNumber.toString());
  final randomString = md5.convert(randomBytes).toString();
  return randomString;
}

// sha1 hashing a random number
String sha1RandomString() {
  final randomNumber = Random().nextDouble();
  final randomBytes = utf8.encode(randomNumber.toString());
  final randomString = sha1.convert(randomBytes).toString();
  return randomString;
}
