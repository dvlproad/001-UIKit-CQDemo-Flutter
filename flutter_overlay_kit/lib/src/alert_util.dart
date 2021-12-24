import 'package:flutter/material.dart';
import './message_alert_view.dart';

class AlertUtil {
  // 我知道了
  // static showIKnowAlert(
  //     String title, String message, Void Function() iKnowHandle) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       // return Container();
  //     },
  //   );
  // }

  // 取消 + 确定
  static showCancelOKAlert(
    BuildContext context,
    String title,
    String message,
    Function() cancelHandle,
    Function() okHandle,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return CancelOKMessageAlertView(
          title: title,
          message: message,
          cancelTitle: "取消",
          cancelHandle: () {
            Navigator.pop(context);
            if (cancelHandle != null) {
              cancelHandle();
            }
          },
          okTitle: "确定",
          okHandle: () {
            Navigator.pop(context);
            if (okHandle != null) {
              okHandle();
            }
          },
        );
      },
    );
  }
}
