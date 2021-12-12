import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../pagetype_change/pagetype_loadstate_change_widget.dart';
import '../pagetype_change/pagetype_change_widget.dart'; // 为了引入WidgetType

import '../loading/state_loading_widget.dart';

//class BJHBasePage extends StatefulWidget {
abstract class BJHBasePage extends StatefulWidget {
  final String title;

  BJHBasePage({Key key, this.title}) : super(key: key);

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
  @override
  bool get wantKeepAlive => true;
  WidgetType _currentWidgetType = WidgetType.Init; //默认为初始界面
  bool _showSelfLoading = false; // 默认不显示本视图自身的加载动画

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
    return Scaffold(
      appBar: appBar(),
      body: Container(
        color: Color(0xffF0F0F0),
        child: contentWidget(context),
      ),
    );
  }

  // appBar
  PreferredSizeWidget appBar() {
    return null; // 要有导航栏，请在子类中实现
    // return AppBar(
    //   title: Text(widget.title ?? 'BJHBasePage'),
    // );
  }

  /// 内容视图
  Widget contentWidget(BuildContext context) {
    // return buildSuccessWidget(context);
    // return Text('请在子类中实现');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: PageTypeLoadStateWidget(
        widgetType: _currentWidgetType,
        initWidget: buildInitWidget(context),
        successWidget: buildSuccessWidget(context),
        nodataWidget: buildNodataWidget(context),
        errorWidget: buildErrorWidget(context),
        showSelfLoading: _showSelfLoading,
        selfLoadingWidget: buildSelfLoadingWidgetWidget(context),
      ),
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
    //return null; // 如果返回null 会黑屏
    return buildSuccessWidget(context); // 默认为successWidget，解决用户未设置导致页面空空的问题
  }

  Widget buildSuccessWidget(BuildContext context) {
    print('请在子类中重写此方法,不需要调用super.');
    return null;
  }

  Widget buildNodataWidget(BuildContext context) {
    return buildSuccessWidget(context); // 默认为successWidget
  }

  Widget buildErrorWidget(BuildContext context) {
    return buildSuccessWidget(context); // 默认为successWidget
  }

  Widget buildSelfLoadingWidgetWidget(BuildContext context) {
    return Container(
      height: 242,
      // color: Color.fromRGBO(22, 17, 175, 0.5),
      child: StateLoadingWidget(),
    );
  }
}
