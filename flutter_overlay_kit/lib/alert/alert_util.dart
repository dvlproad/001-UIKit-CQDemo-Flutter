/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 01:11:32
 * @Description: Alert弹窗工具类
 */
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import './message_alert_view.dart';

class AlertUtil {
  // 我知道了
  static Future showIKnowAlert(
    BuildContext context, {
    bool barrierDismissible = false,
    String? title,
    String? message,
    void Function()? iKnowHandle,
  }) {
    return showAlert(
      context,
      barrierDismissible: barrierDismissible,
      alertViewBulider: (context) {
        return IKnowMessageAlertView(
          title: title,
          message: message,
          iKnowTitle: "我知道了",
          iKnowHandle: () {
            Navigator.pop(context);
            if (iKnowHandle != null) {
              iKnowHandle();
            }
          },
        );
      },
    );
  }

  // 可点击背景关闭
  static Future showTwoActionAlert({
    required BuildContext context,
    String? title,
    String? message,
    String? cancelTitle,
    Function()? cancelHandle,
    String? okTitle,
    required Function() okHandle,
  }) {
    return showCancelOKAlert(
      context: context,
      barrierDismissible: true,
      title: title,
      message: message,
      cancelTitle: cancelTitle,
      cancelHandle: cancelHandle,
      okTitle: okTitle,
      okHandle: okHandle,
    );
  }

  // 取消 + 确定
  static Future showCancelOKAlert({
    required BuildContext context,
    bool barrierDismissible = false,
    String? title,
    String? message,
    TextAlign? messageAlign,
    String? cancelTitle,
    Function()? cancelHandle,
    String? okTitle,
    required Function() okHandle,
  }) {
    return showAlert(
      context,
      barrierDismissible: barrierDismissible,
      alertViewBulider: (context) {
        return CancelOKMessageAlertView(
          title: title,
          message: message,
          messageAlign: messageAlign,
          cancelTitle: cancelTitle ?? "取消",
          cancelHandle: () {
            Navigator.of(context).pop();
            // Navigator.pop(context);
            if (cancelHandle != null) {
              cancelHandle();
            }
          },
          okTitle: okTitle ?? "确定",
          okHandle: () {
            // Navigator.pop(context);
            Navigator.of(context).pop();
            if (okHandle != null) {
              okHandle();
            }
          },
        );
      },
    );
  }

  // '等宽均分的 Buttons' AlertView
  static Future showFlexWidthButtonsAlert({
    required BuildContext context,
    bool barrierDismissible = false,
    String? title,
    String? message,
    required List<String> buttonTitles,
    required void Function(int buttonIndex) onPressedButton,
  }) {
    return showAlert(
      context,
      barrierDismissible: barrierDismissible,
      alertViewBulider: (context) {
        return FlexWidthButtonsMessageAlertView(
          title: title,
          message: message,
          buttonTitles: buttonTitles,
          onPressedButton: onPressedButton, // Navigator.pop(context);
        );
      },
    );
  }

  static Future showAlert(
    BuildContext context, {
    bool barrierDismissible = false,
    required Widget Function(BuildContext context) alertViewBulider,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          alertViewBulider(context),
        ],
      ),
    );
    /*
    // return;

    FocusNode _commentFocus = FocusNode();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Container(
        color: Colors.red,
        child: GestureDetector(
          onTap: () {
            print('触摸收起键盘');
            FocusScope.of(context).requestFocus(_commentFocus); // 获取焦点
            Future.delayed(Duration(milliseconds: 0)).then((value) {
              _commentFocus.unfocus(); // 失去焦点
            });
            // FocusScope.of(context).requestFocus(FocusNode());//可能是上下文context引起的无效
          },
          // GestureDetector 里的 child 不是 Container，而是Column等会无法响应点击
          child: Container(
            color: Colors.green,
            child: Stack(
              children: [
                TextField(focusNode: _commentFocus), // 键盘处理的中介
                Container(
                  constraints: BoxConstraints.expand(),
                  color: Colors.yellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      alertViewBulider(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    */
  }
}
