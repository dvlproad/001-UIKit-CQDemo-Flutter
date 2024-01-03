/*
 * @Author: dvlproad
 * @Date: 2023-12-18 10:06:37
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-03 17:14:34
 * @Description: 
 */
import 'dart:async';

import 'package:flutter/widgets.dart';
import './function_proxy.dart';

extension FunctionExt on Function {
  VoidCallback throttle({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).throttle;
  }

  VoidCallback debounce({int? timeout}) {
    return FunctionProxy(this, timeout: timeout).debounce;
  }
}
