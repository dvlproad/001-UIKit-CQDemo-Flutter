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
  static bool _showing = false;

  /// 接口请求超时调用这个提示
  static showTimeoutMsg() {
    showMessageOnlyOnce('网络开小差');
  }

  static showMessage(
    String message, {
    int duration = 1,
    bool needCancelOld = false, // 是否要取消旧的，避免视图一直叠加
  }) {
    if (message != null && message is String && message.isNotEmpty) {
      debugPrint(message);

      if (needCancelOld == true) {
        Fluttertoast.cancel();
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: duration,
        backgroundColor: Color(0xAA000000),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // 同时只显示一次toast
  static showMessageOnlyOnce(String message, {int duration = 1}) async {
    if (message != null &&
        message is String &&
        message.isNotEmpty &&
        _showing == false) {
      debugPrint(message);
      _showing = true;
      await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: duration,
        backgroundColor: Color(0xAA000000),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      _showing = false;
    }
  }

  static List<String> onlyOnceShowingToastKeys = [];
  static showMessageOnlyOnceWithKey(
    String message, {
    required String toastKey,
    Duration duration = const Duration(milliseconds: 1000),
  }) async {
    if (message == null || message.isEmpty) {
      return;
    }

    bool isToastKeyShowing = onlyOnceShowingToastKeys.contains(toastKey);
    debugPrint(
        "1======toastKey=${toastKey},onlyOnceShowingToastKeys=${onlyOnceShowingToastKeys},message=${message}");
    if (isToastKeyShowing == false) {
      onlyOnceShowingToastKeys.add(toastKey);
      await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: duration.inSeconds,
        backgroundColor: Color(0xAA000000),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Future.delayed(duration).then((value) {
        onlyOnceShowingToastKeys.remove(toastKey);
        debugPrint(
            "2======toastKey=${toastKey},onlyOnceShowingToastKeys=${onlyOnceShowingToastKeys}");
      });
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

  static FToast? timeoutToast;
  static bool timeoutToastShowing = false;
  static BuildContext Function()? _contextGetBlock;

  static init({
    required BuildContext Function() contextGetBlock,
  }) {
    _contextGetBlock = contextGetBlock;
  }

  static showUniqueMessage(
    String message, {
    Duration duration = const Duration(seconds: 1),
    bool needCancelOld = false, // 是否要取消旧的，避免视图一直叠加
  }) {
    if (timeoutToastShowing == true) {
      return;
    }

    if (timeoutToast == null && _contextGetBlock != null) {
      timeoutToast = FToast();
      BuildContext context = _contextGetBlock!();
      if (context == null) {
        return;
      }
      timeoutToast!.init(context);
    }

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("This is a Custom Toast"),
        ],
      ),
    );

    timeoutToast!.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: duration,
    );
    timeoutToastShowing = true;
    Future.delayed(duration).then((value) {
      timeoutToastShowing = false;
    });
  }
}
