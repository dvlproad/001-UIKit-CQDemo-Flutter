/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-10 20:55:42
 * @Description: 
 */
import 'package:flutter/material.dart';

class TSTabBarBaePage extends StatefulWidget {
  final String? title; // 标题
  final List<Widget> tabs; // <Widget>[Tab(text: '新文件没Base'),]
  final List<Widget> tabPages;

  TSTabBarBaePage({
    Key? key,
    this.title,
    required this.tabs,
    required this.tabPages,
  }) : super(key: key);

  @override
  _TSTabBarBaePageState createState() => _TSTabBarBaePageState();
}

// 1 实现 SingleTickerProviderStateMixin
class _TSTabBarBaePageState extends State<TSTabBarBaePage>
    with SingleTickerProviderStateMixin {
  // 2 定义 TabController 变量
  late TabController _tabController;

  // 3 覆盖重写 initState，实例化 _tabController
  @override
  void initState() {
    super.initState();

    if (widget.tabs.length != widget.tabPages.length) {
      debugPrint("Error:请保证个数相等");
    }

    int length = widget.tabs.length;
    _tabController = TabController(length: length, vsync: this);

    _tabController.addListener(() {
      debugPrint("点击tabIndex:${_tabController.index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _tabBarAndTabBarView;
  }

  Widget get _tabBarAndTabBarView {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          Container(child: header(widget.title ?? '')),
          SizedBox(height: 30, child: _tabbar),
          Expanded(child: Container(child: _tabBarView)),
        ],
      ),
    );
  }

  Widget header(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.red,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TabBar get _tabbar {
    return TabBar(
      controller: _tabController, // 4 需要配置 controller！！！
      // isScrollable: true,
      tabs: widget.tabs,
    );
  }

  TabBarView get _tabBarView {
    return TabBarView(
      controller: _tabController, // 4 需要配置 controller！！！
      children: widget.tabPages,
    );
  }
}
