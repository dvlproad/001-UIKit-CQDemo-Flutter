/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-14 18:43:49
 * @Description: Alert弹窗工具类
 */
import 'package:flutter/material.dart';
import '../../flutter_demo_init.dart';
import './message_alert_view.dart';

class CJTSAlertUtil {
  /// 我知道了 [context]可空
  static Future showIKnowAlert(
    BuildContext? context, {
    bool barrierDismissible = false,
    String? title,
    String? message,
    RichText? richTextWidget,
    String? confirmText,
    TextAlign? messageAlign,
    bool showCloseButton = true,
    void Function()? iKnowHandle,
    bool? scrollable,
  }) {
    return showAlert(
      context,
      barrierDismissible: barrierDismissible,
      alertViewBulider: (context) {
        return IKnowMessageAlertView(
          title: title,
          message: message,
          richTextWidget: richTextWidget,
          messageAlign: messageAlign,
          iKnowTitle: confirmText ?? "我知道了",
          barrierDismissible: barrierDismissible,
          showCloseButton: showCloseButton,
          iKnowHandle: () {
            Navigator.pop(context);
            if (iKnowHandle != null) {
              iKnowHandle();
            }
          },
          scrollable: scrollable,
        );
      },
    );
  }

  // 取消 + 确定
  static Future showCancelOKAlert({
    BuildContext? context,
    bool barrierDismissible = false,
    String? title,
    String? message,
    TextAlign? messageAlign,
    String? cancelTitle,
    Function()? cancelHandle,
    Function()? closeHandle,
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
            if (cancelHandle != null) {
              cancelHandle();
            }
          },
          okTitle: okTitle ?? "确定",
          okHandle: () {
            Navigator.of(context).pop();
            okHandle();
          },
          closeHandle: () {
            Navigator.of(context).pop();
            if (closeHandle != null) {
              closeHandle();
            }
          },
        );
      },
    );
  }

  // '等宽均分的 Buttons' AlertView
  static Future showFlexWidthButtonsAlert({
    BuildContext? context,
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
    BuildContext? context, {
    bool barrierDismissible = false,
    required Widget Function(BuildContext context) alertViewBulider,
  }) {
    if (context == null && CJTSDemoInit.overlayContextNullHandle != null) {
      context = CJTSDemoInit.overlayContextNullHandle!();
    }

    if (context == null) {
      debugPrint('🚗🚗🚗 alert context is null');
      return Future(() => false);
    }

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          alertViewBulider(context!),
        ],
      ),
    );
  }
}
