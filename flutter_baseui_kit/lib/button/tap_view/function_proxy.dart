import 'dart:async';

import 'package:flutter/material.dart';

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
