import 'dart:async';

// class ClickOptimization {
/// 函数防抖
///
/// [func]: 要执行的方法
/// [delay]: 要迟延的时长
Function debounce(
  Function func, [
  Duration delay = const Duration(milliseconds: 2000),
]) {
  Timer timer;
  Function target = () {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func?.call();
    });
  };
  return target;
}

/// 函数节流
///
/// [func]: 要执行的方法
Function throttle(
  Future Function() func, {
  Duration delay = const Duration(milliseconds: 2000),
}) {
  if (func == null) {
    return func;
  }
  bool enable = true;
  Function target = () {
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
