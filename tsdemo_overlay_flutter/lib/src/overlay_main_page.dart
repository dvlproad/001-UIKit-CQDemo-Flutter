import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './TSOverlayView/TSAlertViewHomePage.dart';
import './TSOverlayUtil/overlay_util_home_page.dart';

class TSOverlayMainPage extends StatefulWidget {
  @override
  _TSOverlayMainPageState createState() => _TSOverlayMainPageState();
}

class _TSOverlayMainPageState extends State<TSOverlayMainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('OverlayView')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('OverlayUtil')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('School')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: 0,
        alignment: Alignment.center,
        children: <Widget>[
          TSAlertViewHomePage(),
          TSOverlayUtilHomePage(),
          TSAlertViewHomePage(),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
