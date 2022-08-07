/*
 * @Author: dvlproad
 * @Date: 2022-08-07 16:54:38
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-07 18:30:53
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CQEmojiLengthLimitingTextInputFormatter
    extends LengthLimitingTextInputFormatter {
  CQEmojiLengthLimitingTextInputFormatter(int? maxLength) : super(maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    // 没有限制，则使用最新值
    if (maxLength == null || maxLength! <= 0) {
      return newValue;
    }

    // 是删除文本操作，则使用最新值
    int newValueLength = newValue.text.characters.length;
    int oldValueLength = oldValue.text.characters.length;
    if (newValueLength < oldValueLength) {
      return newValue;
    }

    // 是添加文本操作，但新文本仍不会没超过限制
    if (newValueLength <= maxLength!) {
      return newValue;
    }

    // 是添加文本操作，但新文本会超过限制
    return oldValue;
  }
}
