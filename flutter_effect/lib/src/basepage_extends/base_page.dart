import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../pagetype_change/pagetype_loadstate_change_widget.dart';
import '../pagetype_change/pagetype_change_widget.dart'; // 为了引入WidgetType

import '../loading/state_loading_widget.dart';

//class BJHBasePage extends StatefulWidget {
abstract class BJHBasePage extends StatefulWidget {
  BJHBasePage({
    Key key,
  }) : super(key: key);

  // @override
  // // BJHBasePageState createState() => BJHBasePageState();
  // BJHBasePageState createState() => getState();
  // ///子类实现
  // BJHBasePageState getState() {
  //   print('请在子类中实现');
  // }
}

//class BJHBasePageState extends State<BJHBasePage> {
abstract class BJHBasePageState<V extends BJHBasePage> extends State<V>
    with AutomaticKeepAliveClientMixin {
  WidgetType _currentWidgetType = WidgetType.Init; //默认为初始界面
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
  Widget build(BuildContext context) {
    super.build(context);
    return isHideStatusBar()
        ? _bodyWidget(context)
        : Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
            backgroundColor: Colors.transparent,
            appBar: appBar(),
            body: _bodyWidget(context),
          );
  }

  // 是否允许键盘弹起改变布局
  bool resizeToAvoidBottomInset() => true;

  // appBar(在Scaffold中)
  PreferredSizeWidget appBar() {
    return null; // 要有导航栏，请在子类中实现
    // return AppBar(
    //   title: Text('BJHBasePage'),
    // );
  }

  // appBar(非Scaffold中):该值非空时候, init\error\nodata 等视图会自动下移，以此来复用 success 中的导航栏
  // appBar不能设置在success中，只能设置在appBar()或此处appBarWidget(BuildContext context)的原因是:
  // 原因是在有背景图存在的情况下，其他buildErrorWidget(BuildContext context)返回的视图为了能够显示背景图会设置成透明色，
  // 同样的因为设置了这个透明色，导致原本想的通过下移复用buildSuccessWidget(BuildContext context)中的导航栏，
  // 虽然复用了，但是success视图也显示上去了，而你的buildErrorWidget(BuildContext context)确是透明的，那就变成了把原本要遮盖住的视图给显示出来了，
  // 除非你能够把success中非appBar的部分给隐藏起来(可以，但代码操作不方便)
  // 所以appBar不能设置在success中，只能设置在appBar()或此处appBarWidget(BuildContext context)
  Widget appBarWidget(BuildContext context) {
    return null;
  }

  bool isHideStatusBar() {
    return false;
  }

  // 背景色（如果通过 backgroundWidget 设置背景视图，则此方法会失效）
  Color backgroundColor() {
    return Color(0xFFF0F0F0);
  }

  // 背景视图(常用来设置背景图片)
  Widget backgroundWidget(BuildContext context) {
    // 设置背景色
    return Container(
      color: Color(0xFFF0F0F0),
    );

    // eg1:设置铺满的背景图片
    // return Container(
    //   alignment: Alignment.topCenter,
    //   //color: Colors.yellow,
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
    double stautsBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
//或者 double stautsBarHeight = MediaQuery.of(context).padding.top;
    double successWidgetCustomAppBarHeight =
        appBarWidget(context) != null ? stautsBarHeight + 44 : 0;

    assert(backgroundWidget(context) != null);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          backgroundWidget(context),
          Column(
            children: [
              appBarWidget(context) ?? Container(height: 0),
              Expanded(
                child: _contentWidget(context, successWidgetCustomAppBarHeight),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 内容视图
  Widget _contentWidget(
      BuildContext context, double successWidgetCustomAppBarHeight) {
    return PageTypeLoadStateWidget(
      widgetType: _currentWidgetType,
      initWidget: buildInitWidget(context),
      successWidget: buildSuccessWidget(context),
      successWidgetCustomAppBarHeight: successWidgetCustomAppBarHeight,
      nodataWidget: buildNodataWidget(context),
      errorWidget: buildErrorWidget(context),
      showSelfLoading: _showSelfLoading,
      selfLoadingWidget: buildSelfLoadingWidgetWidget(context),
    );
  }

  ///显示当前页面自己的loading动画（目前使用场景：请求网络请求开始的时候调用）
  void showSelfLoadingAction() {
    _showSelfLoading = true;
    setState(() {});
  }

  /// 更新当前页面的页面类型(会自动停止动画)
  void updateWidgetType(WidgetType widgetType) {
    _currentWidgetType = widgetType;
    _showSelfLoading = false;
    if (mounted == false) {
      // 防止页面关闭执行setState()方法
      return;
    }
    setState(() {});
  }

  /// 获取当前状态(如网络异常时候，存在在导航栏上的右边的那些视图是要禁止点击的)
  WidgetType getCurrentWidgetType() {
    return _currentWidgetType;
  }

  Widget buildInitWidget(BuildContext context) {
    return null; // 如果返回null 不会黑屏，因为上面盖着 buildSuccessWidget
  }

  Widget buildSuccessWidget(BuildContext context) {
    print('请在子类中重写此方法,不需要调用super.');
    return null;
  }

  Widget buildNodataWidget(BuildContext context) {
    return null;
  }

  Widget buildErrorWidget(BuildContext context) {
    return null;
  }

  Widget buildSelfLoadingWidgetWidget(BuildContext context) {
    return Container(
      height: 242,
      // color: Color.fromRGBO(22, 17, 175, 0.5),
      child: StateLoadingWidget(),
    );
  }
}
