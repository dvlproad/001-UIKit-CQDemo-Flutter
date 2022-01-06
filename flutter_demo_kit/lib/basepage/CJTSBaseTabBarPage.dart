import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//class CJTSBaseTabBarPage extends StatefulWidget {
abstract class CJTSBaseTabBarPage extends StatefulWidget {
  final List<dynamic> tabbarModels;

  CJTSBaseTabBarPage({
    Key key,
    this.tabbarModels,
  }) : super(key: key);

  @override
//  CJTSBaseTabBarPageState createState() => CJTSBaseTabBarPagetate();
  CJTSBaseTabBarPageState createState() => getState();

  ///子类实现
  CJTSBaseTabBarPageState getState() {
    print('请在子类中实现');
  }
}

//class CJTSBaseTabBarPageState extends State<CJTSBaseTabBarPage> {
abstract class CJTSBaseTabBarPageState<V extends CJTSBaseTabBarPage>
    extends State<V> {
  List<dynamic> _tabbarModels;
  int _selectedIndex = 0;

  List<dynamic> get tabbarModels {
    List<dynamic> tabbarModels = [
      {
        'title': "标题",
        'nextPage': Text('页面page'),
      },
    ];

    return tabbarModels;
  }

  @override
  void initState() {
    super.initState();

    _tabbarModels = tabbarModels;
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _mainWidgets,
      body: _pages,
    );
  }

  Widget get _mainWidgets {
    List<BottomNavigationBarItem> items = [];
    for (var tabbarModel in _tabbarModels) {
      BottomNavigationBarItem item = BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(tabbarModel['title']),
      );
      items.add(item);
    }
    return BottomNavigationBar(
      // 底部导航
      items: items,
      currentIndex: _selectedIndex,
      fixedColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }

  Widget get _pages {
    List<Widget> pages = [];
    for (var tabbarModel in _tabbarModels) {
      Widget page = tabbarModel['nextPage'];
      pages.add(page);
    }

    return IndexedStack(
      index: _selectedIndex,
      alignment: Alignment.center,
      children: pages,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}