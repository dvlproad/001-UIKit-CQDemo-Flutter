import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static showMessage(String message) {
    if (message != null && message is String && message.isNotEmpty) {
      print(message);
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

  // 需要产品补充完善需求
  static showNeedProduct({String message}) {
    String lastMessage = '需要产品补充完善需求';
    if (message != null) {
      lastMessage = '$lastMessage:$message';
    }
    showMessage(lastMessage);
  }

  // 需要H5补充url
  static showNeedH5({String message}) {
    String lastMessage = '需要H5补充url';
    if (message != null) {
      lastMessage = '$lastMessage:$message';
    }
    showMessage(lastMessage);
  }
}



/*
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
*/