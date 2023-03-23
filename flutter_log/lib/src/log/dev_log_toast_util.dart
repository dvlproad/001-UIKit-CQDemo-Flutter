/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 18:48:05
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CJTSToastUtil {
  static showMessage(String message) {
    if (message.isNotEmpty) {
      debugPrint("CJTSToastUtil.showMessage($message)");
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
