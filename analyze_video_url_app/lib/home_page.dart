/*
 * @Author: dvlproad
 * @Date: 2025-04-16 22:05:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-16 22:17:55
 * @Description: 
 */
import 'package:flutter/material.dart';
import './video_input_page.dart';
import './parsed_videos_page.dart';
import './more_page.dart';
import './tab_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tabController = AppTabController();

  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabController.currentIndex,
        children: [
          VideoInputPage(), // 解析输入页
          ParsedVideosPage(), // 已解析页
          MorePage(), // 更多页
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.currentIndex,
        onTap: (index) => _tabController.switchToTab(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "解析输入",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "已解析",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "更多",
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    super.dispose();
  }
}
