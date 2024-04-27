import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_kit/flutter_lifecycle_kit.dart';

//class CJBasePage extends StatefulWidget {
abstract class CJBasePage extends LifeCycleView {
  const CJBasePage({
    Key? key,
  }) : super(key: key);

// @override
// // CJBasePageState createState() => CJBasePageState();
// CJBasePageState createState() => getState();
// ///子类实现
// CJBasePageState getState() {
//   print('请在子类中实现');
// }
}

//class CJBasePageState extends State<CJBasePage> {
abstract class CJBasePageState<V extends CJBasePage>
    extends LifeCycleViewState<V> with AutomaticKeepAliveClientMixin {
  // 点击背景的时候，是否执行关闭键盘(默认false，避免无脑关闭键盘而在退出页面的时候重新触发build)
  bool get needUnfocusWhenTap => false;

  // 背景视图(常用来设置背景图片)
  Widget backgroundWidget(BuildContext context) {
    // 设置背景色
    return Container(
      color: const Color(0xFFF7F7F7),
    );

    // eg1:设置铺满的背景图片
    // return Container(
    //   alignment: Alignment.topCenter,
    //   color: const Color(0xFFF7F7F7),
    //   constraints: const BoxConstraints(
    //     minWidth: double.infinity,
    //     minHeight: double.infinity,
    //   ),
    //   child: Image.asset(
    //     "images/wish/bg_icon.png",
    //     fit: BoxFit.fitWidth,
    //   ),
    // );

    // eg2:设置绝对定位的背景图片
    // return Positioned(
    //   top: 0,
    //   right: 0,
    //   left: 0,
    //   height: Adapt.px(678),
    //   child: Image.asset(
    //     "images/wish/bg_icon.png",
    //     fit: BoxFit.fitWidth,
    //   ),
    // );
  }

  Widget? appBarWidget(BuildContext context) {
    return null;
  }

  /// 设置指定的 widgetType 离屏幕顶部的距离(默认是直接距离 appBar 的高度 Height)
  double contentWidgetTop(double appBarHeight) {
    return appBarHeight;
  }

  /// 设置指定的 widgetType 离屏幕底部的距离(默认是直接距离 creenBottom 的高度 Height)
  double contentWidgetBottom(double screenBottomHeight) {
    return 0; // 默认0
  }

  /// 内容视图
  Widget contentWidget(BuildContext context);

  /// 覆盖在页面上，且位于底部吸附的视图
  Widget? overlayAdsorbBottomWidget(
      BuildContext context, double screenBottomHeight) {
    return null;
    // return Container(
    //   height: screenBottomHeight + 100,
    //   color: Colors.green,
    //   padding: EdgeInsets.only(bottom: screenBottomHeight),
    //   child: Container(height: 100, color: Colors.cyan.withOpacity(0.3)),
    // );
  }

  /// 覆盖整个页面的视图
  Widget? overlayAdsorbFullWidget(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double statusBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
    //或者 double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight =
        appBarWidget(context) != null ? statusBarHeight + 44 : 0;
    double screenBottomHeight = mediaQuery.padding.bottom;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: needUnfocusWhenTap != true
          ? null
          : () {
              FocusScope.of(context).unfocus(); // 关闭键盘，会触发重新 build
            },
      child: Stack(
        children: [
          visibilityDetectorWidget(context, child: backgroundWidget(context)),
          Column(
            children: [
              Container(
                height: contentWidgetTop(appBarHeight),
              ),
              Expanded(
                child: contentWidget(context),
              ),
              Container(
                height: contentWidgetBottom(screenBottomHeight),
              ),

              // Container(
              //   height: mediaQuery.size.height - contentWidgetTop(_currentWidgetType, appBarHeight) - 10,
              //   color: Colors.green,
              //   // child: contentWidget(context),
              // ),
            ],
          ),
          // appbar 使用 Positioned 包起来,以避免当 contentWidget 从 appbar的顶部绘制时候，会遮挡住或被遮挡住
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: appBarWidget(context) ?? Container(height: 0),
          ),
          // overlayAdsorbBottomWidget 吸附底部的视图
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: overlayAdsorbBottomWidget(context, screenBottomHeight) ??
                Container(height: 0),
          ),
          // overlayAdsorbFullWidget 全局视图
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: overlayAdsorbFullWidget(context) ?? Container(height: 0),
          ),
        ],
      ),
    );
  }
}
