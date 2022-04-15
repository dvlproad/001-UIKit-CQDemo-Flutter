/*
 * @Author: dvlproad
 * @Date: 2022-04-16 04:33:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-16 05:24:36
 * @Description: 文本框输入限制
 */
import 'package:flutter/services.dart';

// WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),//只允许输入字母
// WhitelistingTextInputFormatter(RegExp("[0-9.]")),//只允许输入小数
// WhitelistingTextInputFormatter(RegExp("[0-9 ]")),//只允许输入数字和空格
// WhitelistingTextInputFormatter(RegExp(
//       "[a-zA-Z ]|[\u4e00-\u9fa5]|[0-9]")), //只能输入汉字或者字母或数字

class TextInputFormatterUtil {
  /// 用户名文本限制
  static List<TextInputFormatter> usernameInputFormatters() {
    return <TextInputFormatter>[
      FilteringTextInputFormatter.allow(
        RegExp("[a-zA-Z ]|[\u4e00-\u9fa5]|[0-9]"),
      ), //只能输入汉字或者字母或数字,
    ];
  }

  /// 手机号文本限制
  static List<TextInputFormatter> phoneInputFormatters() {
    return <TextInputFormatter>[
      WhitelistingTextInputFormatter.digitsOnly, //只允许输入数字
      LengthLimitingTextInputFormatter(11), //限制最多15位字符
    ];
  }

  /// 昵称文本限制
  static List<TextInputFormatter> nicknameInputFormatters() {
    return <TextInputFormatter>[
      LengthLimitingTextInputFormatter(15), //限制最多15位字符
    ];
  }
}
