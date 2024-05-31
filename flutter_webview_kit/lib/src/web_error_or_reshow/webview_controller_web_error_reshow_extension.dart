// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 13:36:09
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:42:16
 * @Description: 
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../flutter_webview_kit_adapt.dart';

/// 解决iOS部分设备在游戏过程中挂起app，持续一段时间后，回到app出现白屏。
extension ReshowReloadExtension on WebViewController {
  static int? _lastDismissTimeStamp; // 上一次 web 消失的时间

  /// 检查app生命周期期间 webView 白屏情况
  cj_checkWebViewWhiteScreenInAppLifecycleState(
    AppLifecycleState state, {
    required int minDismissInterval,
    // 最小消失时长（如果web进入后台时间大于[minDismissInterval]则进行reload。）
    // 是否需要检查是否存活，如果为空则默认存活，不为空则通过检查该js方法是否存在来判断存活,常见的值为 '__on_alive',
    String? checkAliveMethodName,
  }) async {
    // 解决iOS部分设备在游戏过程中挂起app，持续一段时间后，回到app出现白屏。
    if (state == AppLifecycleState.inactive) {
      //
    } else if (state == AppLifecycleState.paused) {
      _startDismiss();
    } else if (state == AppLifecycleState.resumed) {
      _reloadWhenReshowIfDismissInterval(
        minDismissInterval,
        checkAliveMethodName: checkAliveMethodName,
      );
    } else if (state == AppLifecycleState.detached) {
      //
    }
  }

  /// web 开始不在当前页面的情况，记录下当前时间
  void _startDismiss() {
    DateTime now = DateTime.now();
    _lastDismissTimeStamp = now.millisecondsSinceEpoch;
  }

  void _reloadWhenReshowIfDismissInterval(
    int minDismissInterval, {
    // 最小消失时长（如果web进入后台时间大于[minDismissInterval]则进行reload。）
    // 是否需要检查是否存活，如果为空则默认存活，不为空则通过检查该js方法是否存在来判断存活,常见的值为 '__on_alive',
    String? checkAliveMethodName,
  }) async {
    if (_lastDismissTimeStamp == null) {
      return;
    }
    double currentDismissInterval =
        (DateTime.now().millisecondsSinceEpoch - _lastDismissTimeStamp!) / 1000;
    if (currentDismissInterval <= minDismissInterval) {
      return;
    }

    bool isAlive = true;
    if (checkAliveMethodName != null) {
      bool exsitJSMethod = await cj_exsitJsMethodName(checkAliveMethodName);
      isAlive = exsitJSMethod;
    }

    if (!isAlive) {
      _lastDismissTimeStamp = null;
      reload();
    }
  }
}

/// onWebResourceError: (WebResourceError error) 时候是否 reload 的处理
extension ErrorReloadExtension on WebViewController {
  static int _currentTargetErrorCount = 0;

  /// 重置次数
  resetTargetErrorCount() {
    _currentTargetErrorCount = 0;
  }

  /// 捕获到错误时候的 re loadRequest 检查
  reloadRequesCheckWhenError(
    WebResourceError error, {
    // 只有遇到这些 WebResourceErrorType 错误才 reload ， 其他都是直接弹出错误提示或者跳过
    required List<String> shouldReloadWebResourceErrorTypes,
    // 最大的失败次数，超过则不能再重试，而是需要显示错误或者跳过了 （默认1次，后台配置）
    required int maxTargetErrorCount,
    // 捕获到目标错误时要执行的动作,（如果错误次数超过最大次数，提示错误；不超过则可尝试重新加载)
    required void Function(bool isBeyondMax) onCatchTargetError,
    // 尝试重新加载的间隔/间隔多长时间之后再重试，避免现在(如网络异常)立马执行还是错误
    Duration reloadRequestDuration = const Duration(milliseconds: 2000),
  }) {
    maxTargetErrorCount = max(maxTargetErrorCount, 1); // 避免传入的值小于1

    // ios首次安装，断网进入白屏，errorType==null,errorCode==-1009
    if (error.errorType == null && error.errorCode == -1009) {
      return;
    }
    if (!shouldReloadWebResourceErrorTypes.contains(error.errorType?.name)) {
      return;
    }

    _currentTargetErrorCount++;
    if (_currentTargetErrorCount >= maxTargetErrorCount) {
      onCatchTargetError(true);
      return;
    }

    Future.delayed(reloadRequestDuration).then((value) {
      onCatchTargetError(false);
    });
  }

  Widget renderDemoWebErrorAlert({
    required void Function() onTapClose, // 点击 关闭 按钮
    required void Function() onTapReLoadRequest, // 点击 重新加载 按钮
  }) {
    return Center(
      child: Container(
        width: 297.w_pt_cj,
        height: 192.h_pt_cj,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 44.h_pt_cj),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "友情提醒",
                    style: TextStyle(
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.f_pt_cj,
                      color: const Color(0xFF404040),
                    ),
                  ),
                ),
                SizedBox(height: 10.h_pt_cj),
                Text(
                  "网页加载失败",
                  style: TextStyle(
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w400,
                    fontSize: 13.f_pt_cj,
                    color: const Color(0xFF8b8b8b),
                  ),
                ),
                SizedBox(height: 37.h_pt_cj),
                Row(
                  children: [
                    SizedBox(width: 15.w_pt_cj),
                    InkWell(
                      onTap: onTapClose,
                      child: Container(
                        alignment: Alignment.center,
                        width: 128.w_pt_cj,
                        height: 36.h_pt_cj,
                        decoration: BoxDecoration(
                          color: const Color(0xfff0f0f0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(36.w_pt_cj),
                          ),
                        ),
                        child: Text(
                          "关闭",
                          style: TextStyle(
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF404040),
                            fontSize: 14.f_pt_cj,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 11.h_pt_cj),
                    InkWell(
                      onTap: onTapReLoadRequest,
                      child: Container(
                        alignment: Alignment.center,
                        width: 128.w_pt_cj,
                        height: 36.h_pt_cj,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE67D4F),
                          borderRadius: BorderRadius.all(Radius.circular(36)),
                        ),
                        child: Text(
                          "重新加载",
                          style: TextStyle(
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 14.f_pt_cj,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.h_pt_cj),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: onTapClose,
                child: Container(
                  width: 40.w_pt_cj,
                  height: 40.h_pt_cj,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w_pt_cj,
                    vertical: 10.h_pt_cj,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/close_icon3.png',
                      width: 20.w_pt_cj,
                      height: 20.h_pt_cj,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
