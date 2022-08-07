/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 00:51:59
 * @Description: Toast工具类
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static showMessage(String message) {
    if (message != null && message is String && message.isNotEmpty) {
      debugPrint(message);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xAA000000),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // 此方法为为了替换项目中的 Toast.show 方法，临时增加了一个无用变量(此方法最后要删掉)
  static showMsg(String message, BuildContext context, {int duration = 1}) {
    showMessage(message);
  }

  // 开发中
  static showDoing({String? message}) {
    String lastMessage = '开发中';
    if (message != null) {
      lastMessage = '$lastMessage:$message';
    }
    showMessage(lastMessage);
  }

  // 需要产品补充完善需求
  static showNeedProduct({String? message}) {
    String lastMessage = '需要产品补充完善需求';
    if (message != null) {
      lastMessage = '$lastMessage:$message';
    }
    showMessage(lastMessage);
  }

  // 需要H5补充url
  static showNeedH5({String? message}) {
    String lastMessage = '需要H5补充url';
    if (message != null) {
      lastMessage = '$lastMessage:$message';
    }
    showMessage(lastMessage);
  }
}
