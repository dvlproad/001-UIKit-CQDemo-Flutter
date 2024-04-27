import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_kit/flutter_lifecycle_kit.dart';

import './cj_base_view.dart';
import '../widget/pagetype_loadstate_change_widget.dart';
import '../widget/pagetype_change_widget.dart'; // 为了引入WidgetType

//class CQBasePage extends StatefulWidget {
abstract class CQBasePage extends CJBasePage {
  final VoidCallback? onScrollToTop;
  final Map<String, dynamic>? arguments;

  const CQBasePage({
    Key? key,
    this.onScrollToTop,
    this.arguments,
  }) : super(key: key);

// @override
// // CQBasePageState createState() => CQBasePageState();
// CQBasePageState createState() => getState();
// ///子类实现
// CQBasePageState getState() {
//   print('请在子类中实现');
// }
}

//class CQBasePageState extends State<CQBasePage> {
abstract class CQBasePageState<V extends CQBasePage>
    extends CJBasePageState<V> {
  /// 获取当前状态(如网络异常时候，存在在导航栏上的右边的那些视图是要禁止点击的)
  WidgetType get currentWidgetType => _currentWidgetType;
  WidgetType _currentWidgetType = WidgetType.Unknow; // 要显示的界面类型
  bool _showSelfLoading = false; // 默认不显示本视图自身的加载动画

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void viewDidAppear(AppearBecause appearBecause) {
    super.viewDidAppear(appearBecause);
  }

  @override
  void viewDidDisappear(DisAppearBecause disAppearBecause) {
    super.viewDidDisappear(disAppearBecause);
  }

  Widget? _initWidget;
  @override
  Widget build(BuildContext context) {
    _initWidget = buildInitWidget(context);
    if (_currentWidgetType == WidgetType.Unknow) {
      // 如果未知，则进行判断初始界面类型
      if (_initWidget != null) {
        // 未设置 initWidget, 则默认初始类型都为 SuccessWithData
        _currentWidgetType = WidgetType.Init;
      } else {
        _currentWidgetType = WidgetType.SuccessWithData;
      }
    }

    return super.build(context);
  }

  // 点击背景的时候，是否执行关闭键盘(默认false，避免无脑关闭键盘而在退出页面的时候重新触发build)
  @override
  bool get needUnfocusWhenTap => false;

  /// 覆盖在页面上，且位于底部吸附的视图
  @override
  Widget? overlayAdsorbBottomWidget(
      BuildContext context, double screenBottomHeight) {
    return null;
  }

  /// 覆盖整个页面的视图
  @override
  Widget? overlayAdsorbFullWidget(BuildContext context) {
    return null;
  }

  // 背景视图(常用来设置背景图片)
  @override
  Widget backgroundWidget(BuildContext context) {
    // 设置背景色
    return Container(
      color: const Color(0xFFF7F7F7),
    );
  }

  @override
  Widget? appBarWidget(BuildContext context) {
    return null;
  }

  /// 设置指定的 widgetType 离屏幕顶部的距离(默认是直接距离 appBar 的高度 Height)
  @override
  double contentWidgetTop(double appBarHeight) {
    return appBarHeight;
  }

  /// 设置指定的 widgetType 离屏幕底部的距离(默认是直接距离 creenBottom 的高度 Height)
  @override
  double contentWidgetBottom(double screenBottomHeight) {
    return 0; // 默认0
  }

  /// 内容视图
  @override
  Widget contentWidget(BuildContext context) {
    Widget? _errorWidget = buildErrorWidget(context);
    if (_currentWidgetType == WidgetType.ErrorNetwork && _errorWidget == null) {
      print(
          "Error:你想要展示无网络状态页，但未设置，所以请重写 Widget buildErrorWidget(BuildContext context)");
    }

    Widget? _nodataWidget = buildNodataWidget(context);
    if (_currentWidgetType == WidgetType.SuccessNoData &&
        _nodataWidget == null) {
      print(
          "Error:你想要展示无数据状态页，但未设置，所以请重写 Widget buildNodataWidget(BuildContext context)");
    }

    return PageTypeLoadStateWidget(
      widgetType: _currentWidgetType,
      initWidget: _initWidget,
      successWidget: buildSuccessWidget(context),
      nodataWidget: _nodataWidget,
      errorWidget: _errorWidget,
      showSelfLoading: _showSelfLoading,
      selfLoadingWidget: buildSelfLoadingWidgetWidget(context),
    );
  }

  ///显示当前页面自己的loading动画（目前使用场景：请求网络请求开始的时候调用）
  void showSelfLoadingAction() {
    _showSelfLoading = true;
    setState(() {});
  }

  ///隐藏当前页面自己的loading动画
  void dismissSelfLoadingAction() {
    _showSelfLoading = false;
    if (mounted == false) {
      // 防止页面关闭执行setState()方法
      return;
    }
    setState(() {});
  }

  /// 更新当前页面的页面类型(会自动停止动画)，调用此方法未设置 needUpdateUI 会默认刷新
  void updateWidgetType(
    WidgetType widgetType, {
    bool needUpdateUI = true,
  }) {
    _currentWidgetType = widgetType;
    _showSelfLoading = false;
    if (mounted == false) {
      // 防止页面关闭执行setState()方法
      return;
    }

    bool needSetState = needUpdateUI;
    if (needSetState && mounted) {
      setState(() {});
    }
  }

  Widget? buildInitWidget(BuildContext context) {
    return null; // 如果返回null 不会黑屏，因为上面盖着 buildSuccessWidget
  }

  Widget buildSuccessWidget(BuildContext context) {
    print('请在子类中重写此方法,不需要调用super.');
    // MediaQueryData mediaQuery = MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    // MediaQueryData mediaQuery = MediaQuery.of(context);
    // double _height = mediaQuery.size.height;
    return Container();
  }

  Widget? buildNodataWidget(BuildContext context) {
    return null;
    // return StateNodataWidget();
  }

  Widget? buildErrorWidget(BuildContext context) {
    return null;
    // return StateErrorWidget(errorRetry: () {
    //   print("刷新了");
    // });
  }

  Widget buildSelfLoadingWidgetWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.amber,
        height: 240,
      ),
    );
  }
}
