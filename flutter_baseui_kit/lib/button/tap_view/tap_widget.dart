/*
 * @Author: dvlproad
 * @Date: 2023-12-18 10:06:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-03 17:14:47
 * @Description: 
 */
import 'package:flutter/cupertino.dart';
import './extensions.dart';

enum TapType { none, throttle, debounce }

class TapWidget extends StatelessWidget {
  final Widget? child;
  final Function? onTap;
  final TapType type;
  final int? timeout;

  const TapWidget({
    Key? key,
    this.child,
    this.onTap,
    this.type = TapType.throttle,
    this.timeout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _getOnTap(),
      child: child,
    );
  }

  VoidCallback? _getOnTap() {
    if (type == TapType.throttle) {
      return onTap?.throttle(timeout: timeout);
    } else if (type == TapType.debounce) {
      return onTap?.debounce(timeout: timeout);
    }
    return () => onTap?.call();
  }
}

class ThrottleTapWidget extends TapWidget {
  const ThrottleTapWidget({
    Key? key,
    Widget? child,
    Function? onTap,
  }) : super(
          key: key,
          child: child,
          onTap: onTap,
          type: TapType.throttle,
        );
}

class DebounceTapWidget extends TapWidget {
  const DebounceTapWidget({
    Key? key,
    Widget? child,
    Function? onTap,
  }) : super(
          key: key,
          child: child,
          onTap: onTap,
          type: TapType.debounce,
        );
}
