/*
 * @Author: dvlproad
 * @Date: 2024-05-14 11:09:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 09:37:18
 * @Description: 
 */
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// initState中添加 WidgetsBinding.instance.addObserver(KeyBoardObserver.instance);
/// dispose中添加 WidgetsBinding.instance.removeObserver(KeyBoardObserver.instance);
class KeyBoardObserver extends WidgetsBindingObserver {
  static final KeyBoardObserver _instance = KeyBoardObserver._();
  static KeyBoardObserver get instance => _instance;
  KeyBoardObserver._() {
    //
  }

  // 这个是实时变化的键盘高度
  void Function(bool isKeyboardShow, double keyboardHeight)? listener;
  void addListener(
    void Function(bool isKeyboardShow, double keyboardHeight) listener,
  ) {
    this.listener = listener;
  }

  Timer? _debounceTimer;
  bool isKeyboardOpen = false;
  double keyboardHeight = 0.0;
  double lastKeyboardHeight = 0.0;

  /// 页面尺寸改变时回调
  @override
  void didChangeMetrics() {
    /// 一次键盘弹出 会触发 多次 didChangeMetrics ，判断该次键盘弹出是否执行完didChangeMetrics
    /// 150ms 如果有新变化，则废弃旧变化的检查
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel(); // 避免有新变化时候，之前的变化变得不再关注了，却还在执行
    }

    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      final newKeyboardHeight =
          MediaQueryData.fromWindow(window).viewInsets.bottom;
      String actionString = "";
      if (newKeyboardHeight > 0 && !isKeyboardOpen) {
        // 键盘弹出
        actionString = "键盘弹出";
        isKeyboardOpen = true;
        keyboardHeight = newKeyboardHeight;
      } else if (newKeyboardHeight == 0 && isKeyboardOpen) {
        // 键盘收起
        actionString = "键盘收起";
        isKeyboardOpen = false;
        keyboardHeight = 0.0;
      } else {
        // 键盘高度变化，更新键盘高度
        if (newKeyboardHeight == keyboardHeight) {
          return;
        }
        actionString = "键盘高度变化，更新键盘高度";
        keyboardHeight = newKeyboardHeight;
      }
      _log("didChangeMetrics $isKeyboardOpen: $actionString $keyboardHeight");
      listener?.call(isKeyboardOpen, keyboardHeight);
    });
  }

  void _log(String message) {
    String dateTimeString = DateTime.now().toString(); //.substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
