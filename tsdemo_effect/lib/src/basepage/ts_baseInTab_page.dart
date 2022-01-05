import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'dart:math';

import './ts_baseInTab_subpage1.dart';
import './ts_baseInTab_subpage2.dart';

class TSBaseInTabPage extends BJHBasePage {
  TSBaseInTabPage({Key key}) : super(key: key);

  @override
  _TSBaseInTabPageState createState() => _TSBaseInTabPageState();
}

// 1 实现 SingleTickerProviderStateMixin
class _TSBaseInTabPageState extends BJHBasePageState<TSBaseInTabPage>
    with SingleTickerProviderStateMixin {
  // 2 定义 TabController 变量
  TabController _tabController;

  // 3 覆盖重写 initState，实例化 _tabController
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      print(_tabController.index);
    });

    // 显示界面 SuccessWithData, 若未设置，则会显示init视图
    updateWidgetType(WidgetType.SuccessWithData, needUpdateUI: false);
  }

  @override
  Color backgroundColor() {
    return Colors.red;
  }

  // appBar
  // @override
  // PreferredSizeWidget appBar() {
  //   // return null; // 要有导航栏，请在子类中实现
  //   return AppBar(
  //     title: Text('tabController'),
  //     bottom: _tabbar,
  //   );
  // }

  // @override
  // bool appBarIsAddToSuccess() {
  //   return false;
  // }

  // @override
  // Widget buildSuccessWidget(BuildContext context) {
  //   return _tabBarView;
  // }

  @override
  Widget buildSuccessWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.green,
        ),
        Positioned(
          child: Container(
            padding: EdgeInsets.only(top: 40, bottom: 0),
            child: _tabBarAndTabBarView,
          ),
        ),
      ],
    );
  }

  Widget get _tabBarAndTabBarView {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: _tabbar,
        ),
        Expanded(
          child: Container(child: _tabBarView),
        ),
      ],
    );
  }

  TabBar get _tabbar {
    return TabBar(
      controller: _tabController, // 4 需要配置 controller！！！
      // isScrollable: true,
      tabs: <Widget>[
        // Tab(text: '同文件'),
        Tab(text: '新文件没Base'),
        Tab(text: '新文件有Base'),
      ],
    );
  }

  TabBarView get _tabBarView {
    return TabBarView(
      controller: _tabController, // 4 需要配置 controller！！！
      children: <Widget>[
        // _subPage1,
        TSBaseInTabSubPage1(),
        TSBaseInTabSubPage2(),
      ],
    );
  }

  Widget get _subPage1 {
    return Container(
      color: Colors.yellow,
      child: Column(
        // 改为 ListView 会偏移
        children: <Widget>[
          CQTSRipeButton.tsRipeButtonIndex(1),
          CQTSRipeButton.tsRipeButtonIndex(2),
          ListTile(
            onTap: () {
              print('点击按钮1-2');
            },
            title: Text('diyigezuixin  推荐'),
          ),
        ],
      ),
    );
  }
}
