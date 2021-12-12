// toast 单例形式的弹出方法
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastUtil {
  static showMessage(String message) {
    // EasyLoading.show(status: message);
    EasyLoading.show(
      indicator: Container(
        color: Colors.red,
        // width: 250,
        // height: 200,
        child: Text(
          message,
        ),
      ),
    );
  }
}
