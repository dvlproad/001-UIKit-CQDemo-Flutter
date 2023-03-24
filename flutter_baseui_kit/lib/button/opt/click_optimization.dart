/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 16:59:49
 * @Description: 函数防抖(停止后执行)、函数节流(立即执行)
 */
import 'dart:async';

// class ClickOptimization {
/// 函数防抖(停止后执行)
///
/// [func]: 要执行的方法
/// [delay]: 要迟延的时长
debounce(
  Function func, [
  Duration delay = const Duration(milliseconds: 2000),
]) {
  Timer? timer;
  Function target = () {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func.call();
    });
  };
  return target;
}

/// 函数节流(立即执行)
///
/// [func]: 要执行的方法
void Function() throttle(
  Future Function() func, {
  Duration delay = const Duration(milliseconds: 2000),
}) {
  bool enable = true;
  void Function()? target = () {
    if (enable == true) {
      enable = false;
      func().then((_) async {
        await Future.delayed(delay);
        enable = true;
      });
    }
  };
  return target;
}
// }
