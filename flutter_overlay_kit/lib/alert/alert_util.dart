import 'package:flutter/material.dart';
import './message_alert_view.dart';

class AlertUtil {
  // 我知道了
  static showIKnowAlert(
    @required BuildContext context, {
    String title,
    String message,
    void Function() iKnowHandle,
  }) {
    showAlert(
      context,
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

  // 取消 + 确定
  static showCancelOKAlert({
    @required BuildContext context,
    String title,
    String message,
    String cancelTitle,
    Function() cancelHandle,
    String okTitle,
    @required Function() okHandle,
  }) {
    showAlert(
      context,
      alertViewBulider: (context) {
        return CancelOKMessageAlertView(
          title: title,
          message: message,
          cancelTitle: cancelTitle ?? "取消",
          cancelHandle: () {
            Navigator.pop(context);
            if (cancelHandle != null) {
              cancelHandle();
            }
          },
          okTitle: okTitle ?? "确定",
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

  // '等宽均分的 Buttons' AlertView
  static showFlexWidthButtonsAlert({
    @required BuildContext context,
    String title,
    String message,
    List<String> buttonTitles,
    void Function(int buttonIndex) onPressedButton,
  }) {
    showAlert(
      context,
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

  static void showAlert(
    @required BuildContext context, {
    @required Widget Function(BuildContext context) alertViewBulider,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          alertViewBulider(context),
        ],
      ),
    );
  }
}
