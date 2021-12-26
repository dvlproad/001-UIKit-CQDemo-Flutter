import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import 'dart:convert';

class TSActionSheetHomePage extends StatefulWidget {
  @override
  _TSActionSheetHomePageState createState() => _TSActionSheetHomePageState();
}

class _TSActionSheetHomePageState extends State<TSActionSheetHomePage> {
  int selectedSexIndex1;
  int selectedSexIndex2;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ActionSheet'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            _chooseSexRow1,
          ],
        ),
      ),
    );
  }

  Widget get _chooseSexRow1 {
    return ListTile(
      title: Text('1. 选择照片(无法设置初始选中值)'),
      onTap: () {
        ActionSheetUtil.chooseItem(
          context,
          title: '选择照片',
          itemTitles: ['相册', '相机'],
          currentSelectedIndex: selectedSexIndex1,
          onConfirm: (selectedIndex) {
            selectedSexIndex1 = selectedIndex;
            List<String> itemTitles = ['相册', '相机'];
            String sexString = itemTitles[selectedIndex];
            CJTSToastUtil.showMessage('所选择的照片:$sexString');
          },
        );
      },
    );
  }
}
