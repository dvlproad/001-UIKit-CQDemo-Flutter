/*
 * @Author: dvlproad
 * @Date: 2025-03-31 15:27:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-03-31 20:50:28
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'video_input_page.dart';
import 'parsed_videos_page.dart';
import 'more_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    VideoInputPage(), // 解析输入页
    ParsedVideosPage(), // 已解析页
    MorePage(), // 更多页
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
