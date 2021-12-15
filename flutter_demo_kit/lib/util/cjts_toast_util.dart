import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CJTSToastUtil {
  static showMessage(String message) {
    if (message != null && message is String && message.isNotEmpty) {
      print(message);
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
