/// 编译模式类型
enum ComplieMode {
  unknown, // 未知模式
  debug,
  profile,
  release,
}

class ComplieModeUtil {
  /// 获取当前的编译模式
  static ComplieMode getCompileMode() {
    if (_isDebug()) {
      return ComplieMode.debug; //"debug"
    } else {
      const bool isProfile = const bool.fromEnvironment("dart.vm.profile");
      const bool isReleaseMode = const bool.fromEnvironment("dart.vm.product");
      if (isProfile) {
        return ComplieMode.profile; //"profile";
      } else if (isReleaseMode) {
        return ComplieMode.release; //"release";
      } else {
        return ComplieMode.unknown; //"Unknown type";
      }
    }
  }

  /// 判断是否为Debug模式
  static bool _isDebug() {
    bool inDebug = false;
    assert(inDebug =
        true); // 根据模式的介绍，可以知道Release模式关闭了所有的断言，assert的代码在打包时不会打包到二进制包中。因此我们可以借助断言，写出只在Debug模式下生效的代码
    return inDebug;
  }
}
