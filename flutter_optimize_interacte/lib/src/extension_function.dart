/*
 * @Author: dvlproad
 * @Date: 2023-12-18 10:06:37
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 18:13:24
 * @Description: 
 */
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

extension FunctionExt on Function {
  VoidCallback throttle({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).throttle;
  }

  VoidCallback debounce({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).debounce;
  }
}

class FunctionProxy {
  static Timer? _throttleTimer;
  final Function? target;
  final int timeout;

  FunctionProxy(this.target, {int? timeout}) : timeout = timeout ?? 350;

  void throttle() {
    _throttleTimer?.cancel();
    _throttleTimer = Timer(Duration(milliseconds: timeout), () {
      _throttleTimer!.cancel();
      _throttleTimer = null;
      target?.call();
    });
  }

  void debounce() {
    /// 还在[timeout]之内，抛弃上一次 直至两次点击间隔超过[timeout]
    if (_throttleTimer?.isActive ?? false) {
      debugPrint('Tap debounce');
      _throttleTimer?.cancel();
    } else {
      target?.call();
    }
    _throttleTimer = Timer(Duration(milliseconds: timeout), () {
      _throttleTimer!.cancel();
      _throttleTimer = null;
    });
  }
}
