/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-09 11:26:57
 * @Description: Alert弹窗工具类
 */
import 'package:flutter/material.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';
import '../flutter_overlay_kit_adapt.dart';
import '../overlay_init.dart';
import './message_alert_view.dart';

// import 'package:flutter_button_base/flutter_button_base.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'; // 为了取button

class AlertUtil {
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
    // double height = MediaQuery.of(context).size.height;
    // double containerHeight = height ??
    //     height -
    //         AdaptCJHelper.stautsBarHeight -
    //         AdaptCJHelper.screenBottomHeight;
    return showAlert(
      context,
      barrierDismissible: barrierDismissible,
      alertViewBulider: (context) {
        return IKnowMessageAlertView(
          title: title,
          message: message,
          messageAlign: messageAlign,
          iKnowTitle: confirmText ?? "我知道了",
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
    BuildContext? context,
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
          cancelStyleType:
              cancelTitle == null || cancelTitle == '取消' || cancelTitle == '不保留'
                  ? ThemeStateBGType.theme_gray
                  : ThemeStateBGType.orange_orange,
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
    if (context == null && OverlayInit.overlayContextNullHandle != null) {
      context = OverlayInit.overlayContextNullHandle!();
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

  static Future showAddressAlert({
    BuildContext? context,
    bool barrierDismissible = false,
    required String limitArea,
  }) {
    return showAlert(
      context,
      barrierDismissible: barrierDismissible,
      alertViewBulider: (context) {
        return Container(
          width: 266.w_pt_cj,
          height: 171.h_pt_cj,
          padding: EdgeInsets.symmetric(horizontal: 20.w_pt_cj),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.w_pt_cj),
          ),
          child: Column(
            children: [
              SizedBox(height: 20.h_pt_cj),
              Text(
                '很抱歉，当前【收货地址】不符合活动条件！',
                style: BoldTextStyle(
                    color: Color(0xFF404040), fontSize: 15.w_pt_cj),
              ),
              SizedBox(
                height: 15.h_pt_cj,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '当前活动仅限【收货地址】在',
                      style: RegularTextStyle(
                          color: Color(0xFF333333), fontSize: 13.w_pt_cj)),
                  TextSpan(
                      text: limitArea,
                      style: RegularTextStyle(
                          color: const Color(0xFFE47E4E),
                          fontSize: 13.w_pt_cj)),
                  TextSpan(
                      text: '开放;',
                      style: RegularTextStyle(
                          color: Color(0xFF333333), fontSize: 13.w_pt_cj))
                ]),
              ),
              SizedBox(height: 10.h_pt_cj),
              InkWell(
                child: Container(
                  width: 197.w_pt_cj,
                  height: 38.h_pt_cj,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE47E4E),
                    borderRadius: BorderRadius.circular(19.w_pt_cj),
                  ),
                  child: Text(
                    "好的，知道了",
                    style: BoldTextStyle(
                      fontSize: 13.w_pt_cj,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
              // _renderButton(context, likeUnreadModel),
            ],
          ),
        );
      },
    );
  }
}
