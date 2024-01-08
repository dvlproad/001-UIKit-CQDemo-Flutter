import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_kit/flutter_lifecycle_kit.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart'
    show StateLoadingWidget;
import 'package:flutter_log_with_env/flutter_log_with_env.dart';

import '../pagetype_change/pagetype_loadstate_change_widget.dart';
import '../pagetype_change/pagetype_change_widget.dart'; // 为了引入WidgetType

// import '../pagetype_error/state_error_widget.dart';
// import '../pagetype_nodata/nodata_widget.dart';

import 'package:flutter_error_catch/flutter_error_catch.dart';

import 'package:flutter_buried_point/flutter_buried_point.dart';

import 'package:flutter_network_base/flutter_network_base.dart'; // 网络 HttpStatusCode
import 'package:visibility_detector/visibility_detector.dart';

//class AppBasePage extends StatefulWidget {
abstract class AppBasePage extends LifeCyclePage {
  final VoidCallback? onScrollToTop;
  final Map<String, dynamic>? arguments;

  const AppBasePage({
    Key? key,
    this.onScrollToTop,
    this.arguments,
  }) : super(key: key);

// @override
// // AppBasePageState createState() => AppBasePageState();
// AppBasePageState createState() => getState();
// ///子类实现
// AppBasePageState getState() {
//   print('请在子类中实现');
// }
}

//class AppBasePageState extends State<AppBasePage> {
abstract class AppBasePageState<V extends AppBasePage>
    extends LifeCycleBasePageState<V> with AutomaticKeepAliveClientMixin {
  WidgetType _currentWidgetType = WidgetType.Unknow; // 要显示的界面类型
  bool _showSelfLoading = false; // 默认不显示本视图自身的加载动画

  Widget? _initWidget;

  // 用于记录页面停留时长
  DateTime? _pageAppearTime;

  late String _routeClassString;

  Map<String, dynamic>? _pageInfo;

  Map<String, dynamic>? _arguments;

  String? _currentRoutePath;
  bool enableVAPM = false;
  late String _pageKey;

  @override
  bool get wantKeepAlive => true;

  /// 额外的埋点参数
  /// 用于[viewDidAppear]和[viewDidDisappear]的埋点事件
  Map<String, dynamic> _extraParameters = {};
  // ignore: unused_field
  bool _isVisible = false;
  String? pageCode;
  String? networkUrls = '';

  bool _useVisibilityDetector = false;

  @override
  void initState() {
    _routeClassString = widget.runtimeType.toString();

    super.initState();

    pageCode = "${_routeClassString}_$hashCode";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void addExtraParameter(String key, dynamic value) {
    _extraParameters[key] = value;
  }

  @override
  void viewDidAppear(AppearBecause appearBecause) {
    super.viewDidAppear(appearBecause);
    _isVisible = true;
    // 注意：_currentRoutePath 不和 _routeClassString 一起写在 initState 是因为 ModalRoute.of(context) 不能写在该方法里。
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      _currentRoutePath = route.settings.name;
    }

    AppCatchError.currentPageClassString = _routeClassString;
    AppCatchError.currentPageRoutePath = _currentRoutePath;

    // if (appearBecause == AppearBecause.newCreate) {}

    String appearBecauseString = appearBecause.toString().split('.').last;
    Map<String, dynamic> parameters = {
      "page": _routeClassString,
      "pageKey": _pageKey,
      "cause": appearBecauseString,
    };
    parameters.addAll(_extraParameters);
    // 埋点上报
    _pageAppearTime = DateTime.now();
    BuriedPointManager().addEvent('viewDidAppear', parameters);

    if (_pageInfo?["pageShowType"] != 'tab' &&
        _pageInfo?["pageShowType"] != 'normal') return;
    _arguments = getArguments();
    AppLogUtil.logMessage(
      needTackTrace: false,
      logType: LogObjectType.route,
      logLevel: LogLevel.success,
      shortMap: getAppearShortMap(),
      detailMap: {
        "arguments": _arguments,
        "pageKey": _pageKey,
      },
    );
  }

  @override
  void viewDidDisappear(DisAppearBecause disAppearBecause) {
    super.viewDidDisappear(disAppearBecause);
    _isVisible = false;

    String disAppearBecauseString = disAppearBecause.toString().split('.').last;

    Map<String, dynamic> parameters = {
      "page": _routeClassString,
      "pageKey": _pageKey,
      "cause": disAppearBecauseString,
      "duration": DateTime.now().millisecondsSinceEpoch -
          _pageAppearTime!.millisecondsSinceEpoch,
    };
    parameters.addAll(_extraParameters);
    // 埋点上报
    BuriedPointManager().addEvent('viewDidDisappear', parameters);

    AppCatchError.beforePageClassString = _routeClassString;
    AppCatchError.beforePageRoutePath = _currentRoutePath;

    if (_pageInfo?["pageShowType"] != 'tab' &&
        _pageInfo?["pageShowType"] != 'normal') return;
    AppLogUtil.logMessage(
      needTackTrace: false,
      logType: LogObjectType.route,
      logLevel: LogLevel.success,
      shortMap: getDisappearShortMap(),
      detailMap: {
        "arguments": _arguments,
        "pageKey": _pageKey,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

    return VisibilityDetector(
        key: Key(pageCode ?? ""),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction > 0) {
            /// 页面真正的显示面积大于 0
          }
        },
        child: Listener(
          child: _getBodyWeight(context),
          onPointerDown: (_) {
            //
          },
        ));
  }

  Widget _getBodyWeight(BuildContext context) {
    return shouldGiveUpScaffold()
        ? _bodyWidget(context)
        : Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
            backgroundColor: Colors.transparent,
            appBar: appBar(),
            body: shouldCustomOnPressed != true
                ? _bodyWidget(context)
                : WillPopScope(
                    onWillPop: () => customOnPressedBack(),
                    child: _bodyWidget(context),
                  ),
          );
  }

  /// 是否要自定义导航栏上返回按钮的事件(自定义的话会自动失去侧滑返回)
  bool get shouldCustomOnPressed {
    return false;
  }

  /// 自定义导航栏上返回按钮的事件(只有当 shouldCustomOnPressed 为true的时候才会调用到此方法)，返回值为是否可以退出当前页面(默认true可以)
  Future<bool> customOnPressedBack() async {
    return true;
  }

  // 是否允许键盘弹起改变布局
  bool resizeToAvoidBottomInset() => true;

  // appBar(在Scaffold中)
  PreferredSizeWidget? appBar() {
    return null; // 要有导航栏，请在子类中实现
    // return AppBar(
    //   title: Text('AppBasePage'),
    // );
  }

  /// 设置指定的 widgetType 离屏幕顶部的距离(默认是直接距离 appBar 的高度 Height)
  double contentWidgetTop(WidgetType widgetType, double appBarHeight) {
    return appBarHeight;
  }

  // appBar(非Scaffold中):appBarWidget 只要非null，则有 stautsBarHeight + 44 的高度
  // appBar不能设置在success中，只能设置在appBar()或此处appBarWidget(BuildContext context)的原因是:
  // 原因是在有背景图存在的情况下，其他buildErrorWidget(BuildContext context)返回的视图为了能够显示背景图会设置成透明色，
  // 同样的因为设置了这个透明色，导致原本想的通过下移复用buildSuccessWidget(BuildContext context)中的导航栏，
  // 虽然复用了，但是success视图也显示上去了，而你的buildErrorWidget(BuildContext context)确是透明的，那就变成了把原本要遮盖住的视图给显示出来了，
  // 除非你能够把success中非appBar的部分给隐藏起来(可以，但代码操作不方便)
  // 所以appBar不能设置在success中，只能设置在appBar()或此处appBarWidget(BuildContext context)
  Widget? appBarWidget(BuildContext context) {
    return null;
  }

  /// 设置指定的 widgetType 离屏幕底部的距离(默认是直接距离 creenBottom 的高度 Height)
  double contentWidgetBottom(WidgetType widgetType, double screenBottomHeight) {
    return 0; // 默认0
  }

  /// 底部吸附视图
  Widget? bottomAdsorbWidget(BuildContext context, double screenBottomHeight) {
    return null;
    // return Container(
    //   height: screenBottomHeight + 100,
    //   color: Colors.green,
    //   padding: EdgeInsets.only(bottom: screenBottomHeight),
    //   child: Container(height: 100, color: Colors.cyan.withOpacity(0.3)),
    // );
  }

  /// 覆盖整个页面的视图
  Widget? centerAbsorbWidget(BuildContext context) {
    return null;
  }

  /// 是否不添加 Scaffold 层
  bool shouldGiveUpScaffold() {
    return false;
  }

  bool shouldUseBackGroundColor() {
    return true;
  }

  // 背景视图(常用来设置背景图片)
  Widget backgroundWidget(BuildContext context) {
    // 设置背景色
    return Container(
      color: shouldUseBackGroundColor()
          ? const Color(0xFFF7F7F7)
          : Colors.transparent,
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

  /// 内容视图
  Widget _bodyWidget(BuildContext context) {
    // return buildSuccessWidget(context);
    // return Text('请在子类中实现');

    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    double statusBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
    //或者 double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight =
        appBarWidget(context) != null ? statusBarHeight + 44 : 0;
    double screenBottomHeight = mediaQuery.padding.bottom;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          _useVisibilityDetector
              ? visibilityDetectorWidget(context,
                  child: backgroundWidget(context))
              : backgroundWidget(context),
          // appBarWidget(context) ?? Container(height: 0),
          Column(
            children: [
              Container(
                height: contentWidgetTop(_currentWidgetType, appBarHeight),
              ),
              Expanded(
                child: _contentWidget(context),
              ),
              Container(
                height:
                    contentWidgetBottom(_currentWidgetType, screenBottomHeight),
              ),

              // Container(
              //   height: mediaQuery.size.height - contentWidgetTop(_currentWidgetType, appBarHeight) - 10,
              //   color: Colors.green,
              //   // child: _contentWidget(context),
              // ),
            ],
          ),
          // appbar 使用 Positioned 包起来,以避免当 _contentWidget 从 appbar的顶部绘制时候，会遮挡住或被遮挡住
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: appBarWidget(context) ?? Container(height: 0),
          ),
          // bottomAdsorbWidget 吸附底部的视图
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: bottomAdsorbWidget(context, screenBottomHeight) ??
                Container(height: 0),
          ),
          // 全局视图
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: centerAbsorbWidget(context) ?? Container(height: 0),
          ),
        ],
      ),
    );
  }

  /// 内容视图
  Widget _contentWidget(BuildContext context) {
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

  void updateWidgetTypeWithApiStatusCode(
    int apiStatusCode, {
    bool needUpdateUI = true,
  }) {
    WidgetType widgetType;
    if (apiStatusCode == 0) {
      return;
    } else if (apiStatusCode == HttpStatusCode.ErrorTimeout) {
      return;
    } else {
      if (currentWidgetType == WidgetType.SuccessWithData) {
        return;
      }

      widgetType = WidgetType.ErrorNetwork;
    }

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

  /// 获取当前状态(如网络异常时候，存在在导航栏上的右边的那些视图是要禁止点击的)
  WidgetType get currentWidgetType {
    return _currentWidgetType;
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
    return const SizedBox(
      height: 242,
      // color: Color.fromRGBO(22, 17, 175, 0.5),
      child: StateLoadingWidget(),
    );
  }

  popPage() {
    Navigator.pop(context);
  }

  @override
  bool useVisibilityDetector() {
    return _useVisibilityDetector;
  }

  String getPageType() {
    return "";
  }

  Map<String, dynamic>? getArguments() {
    return null;
  }

  Map<dynamic, dynamic> getAppearShortMap() {
    String routeNameCN = _pageInfo?["pageDesc"] ?? "";
    if (routeNameCN.isNotEmpty) {
      if (_pageInfo?["pageShowType"] == 'tab') {
        return {
          "routeNameCN": "进入Tab页面:$routeNameCN",
        };
      } else {
        return {
          "routeNameCN": "进入页面:$routeNameCN",
        };
      }
    } else {
      return {
        "routePath": "进入页面:$_routeClassString",
      };
    }
  }

  Map<dynamic, dynamic> getDisappearShortMap() {
    String routeNameCN = _pageInfo?["pageDesc"] ?? "";
    if (routeNameCN.isNotEmpty) {
      if (_pageInfo?["pageShowType"] == 'tab') {
        return {
          "routeNameCN": "离开Tab页面:$routeNameCN",
        };
      } else {
        return {
          "routeNameCN": "离开页面:$routeNameCN",
        };
      }
    } else {
      return {
        "routePath": "离开页面:$_routeClassString",
      };
    }
  }

  void scrollToTop() {}
}
