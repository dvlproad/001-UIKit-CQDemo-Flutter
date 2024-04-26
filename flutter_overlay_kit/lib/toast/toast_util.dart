/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 11:57:39
 * @Description: Toast工具类
 */
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:synchronized/synchronized.dart';
import 'package:toast/toast.dart' as old;

import '../../flutter_overlay_kit_adapt.dart';
import '../overlay_init.dart';

class ToastUtil {
  static final Lock _lock = Lock();
  // 2个相同的文案的toast之间间隔至少需要x秒
  static final double _interval = 2.0;
  // 管理正在展示中的文案
  static final Set<String> _messages = {};

  ///需在游戏中展示/调用toast请使用 forceShowMessage 方法
  static showMessage(
    String? message, {
    int duration = 1,
    bool needCancelOld = false, // 是否要取消旧的，避免视图一直叠加
    String? key, // 用来判断这个toast是否正在展示
    ToastGravity gravity = ToastGravity.CENTER, // toast展示位置，默认屏幕中间
    bool needForceShow = false, //是否要在游戏中展示
  }) {
    if (message == null || message.isEmpty) {
      return;
    }
    if (needForceShow == false) {
      if (OverlayInit.shouldGiveupToastCheck != null) {
        bool shouldGiveup = OverlayInit.shouldGiveupToastCheck!();
        if (shouldGiveup == true) {
          return;
        }
      }
    }
    if (needCancelOld == true) {
      Fluttertoast.cancel();
    }
    _lock.synchronized(() {
      // 1.这个文案是否正在展示
      if (key != null) {
        if (_messages.contains(key)) {
          return;
        }
      } else {
        if (_messages.contains(message)) {
          return;
        }
      }
      // 2.记录正在展示
      if (key != null) {
        _messages.add(key);
      } else {
        _messages.add(message);
      }
      // 3.在指定时间过后移出列表
      Future.delayed(Duration(milliseconds: (_interval * 1000).toInt()), () {
        if (key != null) {
          _messages.remove(key);
        } else {
          _messages.remove(message);
        }
      });

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: duration,
        backgroundColor: Color(0xFF333333),
        textColor: Colors.white,
        fontSize: 13.0.w_pt_cj,
      );
    });
  }

  ///此方法为 游戏中调用APP的Toast方法/APP提供给游戏调用的方法中，触发toast，
  ///需在游戏中展示
  static forceShowMessage(
    String? message, {
    int duration = 1,
    bool needCancelOld = false, // 是否要取消旧的，避免视图一直叠加
    String? key, // 用来判断这个toast是否正在展示
    ToastGravity gravity = ToastGravity.CENTER, // toast展示位置，默认屏幕中间
  }) {
    showMessage(
      message,
      duration: duration,
      needCancelOld: needCancelOld,
      key: key,
      gravity: gravity,
      needForceShow: true,
    );
  }

  ///因百度键盘导致Fluttertoast库toast无法弹出，故使用Toast
  static showToastMessage(
    String message, {
    int? gravity = old.Toast.center,
    int? duration,
    bool needForceShow = false, //是否要在游戏中展示
  }) {
    ///游戏中，不显示APP内的toast，除非该路由本身调用
    if (needForceShow == false) {
      if (OverlayInit.shouldGiveupToastCheck != null) {
        bool shouldGiveup = OverlayInit.shouldGiveupToastCheck!();
        if (shouldGiveup == true) {
          return;
        }
      }
    }

    old.Toast.show(
      message,
      gravity: gravity,
      duration: duration,
    );
  }

  // 此方法为为了替换项目中的 Toast.show 方法，临时增加了一个无用变量(此方法最后要删掉)
  static showMsg(String? message, BuildContext context, {int duration = 1}) {
    if (message == null) {
      return;
    }
    showMessage(message);
  }

  static showErrorMsg(String? message) {
    if (message == null) {
      showMessage('非常抱歉！服务器开小差了～');
    } else {
      showMessage(message);
    }
  }

  /// 接口请求超时调用这个提示
  static showTimeoutMsg() {
    showMessage('网络开小差');
  }

  static showSubmitSuccessMsg() {
    showMessage('提交成功!');
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

  static showUniqueMessage(
    String message, {
    Duration duration = const Duration(seconds: 1),
    bool needCancelOld = false, // 是否要取消旧的，避免视图一直叠加
  }) {
    if (timeoutToastShowing == true) {
      return;
    }

    if (timeoutToast == null && OverlayInit.contextGetBlock != null) {
      timeoutToast = FToast();
      BuildContext? context = OverlayInit.contextGetBlock!();
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
