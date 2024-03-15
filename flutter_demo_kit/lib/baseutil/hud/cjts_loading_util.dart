// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-13 10:17:11
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-16 00:30:56
 * @Description: loading 单例形式的弹出方法
 * @FilePath: /lib/src/hud/loading_util.dart
 */
import 'package:flutter/material.dart';

OverlayEntry? doingTextOverlayEntry;

class CJTSLoadingUtil {
  static int? _minLoadingMilliseconds; // 最少展示多长时间
  static DateTime? _startLoadingDateTime;

  static Map<String, OverlayEntry> contextOverlayMap = {};

  /// 在 context 中展示 loading ，(一定记得在 dispose 方法中调用 LoadingUtil.dismissInContext(context);)
  static showInContext(
    BuildContext context, {
    int? minLoadingMilliseconds,
    int? maxLoadingMilliseconds,
  }) {
    String contextKey = context.hashCode.toString();
    // print('==============showInContext:$contextKey');
    OverlayEntry? pageOverlayEntry = contextOverlayMap[contextKey];
    if (pageOverlayEntry != null) {
      return; // 显示中
    }

    double loadingWidth = 49;
    double loadingHeight = 20;
    Widget child = Image.asset(
      'assets/loading_center_new.gif',
      package: 'flutter_demo_kit',
      width: loadingWidth,
      height: loadingHeight,
    );

    pageOverlayEntry =
        _getCenterOverlayInContext(context, child, loadingWidth, loadingHeight);

    // if (Overlay.of(context) == null) {
    //   return;
    // }

    Overlay.of(context).insert(pageOverlayEntry);
    contextOverlayMap[contextKey] = pageOverlayEntry;
    if (minLoadingMilliseconds != null) {
      _minLoadingMilliseconds = minLoadingMilliseconds;
      _startLoadingDateTime = DateTime.now();
    }

    if (maxLoadingMilliseconds != null) {
      Future.delayed(Duration(milliseconds: maxLoadingMilliseconds))
          .then((value) {
        //
      });
    }
  }

  /// 在 context 中关闭 loading ，(一定记得在 dispose 方法中调用 LoadingUtil.dismissInContext(context);)
  static dismissInContext(BuildContext context) {
    if (_minLoadingMilliseconds == null) {
      _dismissInContext(context);
      return;
    }

    _startLoadingDateTime ??= DateTime.now();

    Duration difference = DateTime.now().difference(_startLoadingDateTime!);
    bool canFinishLoad = difference.inMilliseconds >= _minLoadingMilliseconds!;
    if (canFinishLoad == false) {
      int remainLoadingMilliseconds =
          _minLoadingMilliseconds! - difference.inMilliseconds;
      Future.delayed(Duration(milliseconds: remainLoadingMilliseconds))
          .then((value) {
        _minLoadingMilliseconds = null;
        _startLoadingDateTime = null;
        _dismissInContext(context);
        return;
      });
    } else {
      _minLoadingMilliseconds = null;
      _startLoadingDateTime = null;
      _dismissInContext(context);
    }
  }

  static _dismissInContext(BuildContext context) {
    String contextKey = context.hashCode.toString();
    // print('==============dismissInContext:$contextKey');
    OverlayEntry? pageOverlayEntry = contextOverlayMap[contextKey];
    if (pageOverlayEntry == null) {
      return; // 已删除
    }

    pageOverlayEntry.remove();

    contextOverlayMap.remove(contextKey);
  }

  static showDongingTextInContext(
    BuildContext context,
    String text, {
    int milliseconds = 0,
    void Function()? completeBlock,
  }) {
    double childWidth = 100;
    double childHeight = 44;
    Widget child = Container(
      // color: Colors.grey[350],
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.blue, spreadRadius: 1),
        ],
      ),
      width: childWidth,
      height: childHeight,
      child: Center(
        child: Text(text),
      ),
    );
    doingTextOverlayEntry =
        _getCenterOverlayInContext(context, child, childWidth, childHeight);

    Overlay.of(context).insert(doingTextOverlayEntry!);

    if (milliseconds > 0) {
      Future.delayed(Duration(milliseconds: milliseconds), () {
        dismissDongingTextInContext(context);
        if (completeBlock != null) {
          completeBlock();
        }
      });
    }
  }

  static dismissDongingTextInContext(BuildContext context) {
    if (doingTextOverlayEntry != null) {
      doingTextOverlayEntry!.remove();
      doingTextOverlayEntry =
          null; // 防止如请求失败重试或先请求缓存再请求实际这种api接口，一个入口有多次回调，导致此处多次调用引起崩溃
    }
  }

  /// 获取要显示在 context 中心的完整视图
  static OverlayEntry _getCenterOverlayInContext(
    BuildContext context,
    Widget child,
    double childWidth,
    double childHeight,
  ) {
    double left = MediaQuery.of(context).size.width / 2 - childWidth / 2;
    double top = MediaQuery.of(context).size.height / 2 - childHeight / 2;

    return OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: top,
          left: left,
          child: GestureDetector(
            onTap: () async {
              dismissInContext(context);
            },
            child: child,
          ),
        );
      },
    );
  }
}
