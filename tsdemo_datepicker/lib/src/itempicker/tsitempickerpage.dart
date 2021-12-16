import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';

import 'dart:convert';

class TSItemPickerPage extends StatefulWidget {
  @override
  _TSItemPickerPageState createState() => _TSItemPickerPageState();
}

class _TSItemPickerPageState extends State<TSItemPickerPage> {
  int selectedSexIndex1;
  int selectedSexIndex2;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ItemPicker'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            _chooseSexRow1,
            _chooseSexRow2,
          ],
        ),
      ),
    );
  }

  Widget get _chooseSexRow1 {
    return ListTile(
      title: Text('1. 选择照片(无法设置初始选中值)'),
      onTap: () {
        ItemPickerUtil.chooseItem(
          context,
          title: '选择照片',
          itemTitles: ['相册', '相机'],
          currentSelectedIndex: selectedSexIndex1,
          onConfirm: (selectedIndex) {
            selectedSexIndex1 = selectedIndex;
            List<String> itemTitles = ['男', '女'];
            String sexString = itemTitles[selectedIndex];
            CJTSToastUtil.showMessage('所选择的性别:$sexString');
          },
        );
      },
    );
  }

  Widget get _chooseSexRow2 {
    return ListTile(
      title: Text('2. 选择男女'),
      onTap: () {
        ItemPickerPickerUtil.chooseItem(
          context,
          title: '选择性别',
          itemTitles: ['男', '女'],
          currentSelectedIndex: selectedSexIndex2,
          onConfirm: (selectedIndex) {
            selectedSexIndex2 = selectedIndex;
            List<String> itemTitles = ['男', '女'];
            String sexString = itemTitles[selectedIndex];
            CJTSToastUtil.showMessage('所选择的性别:$sexString');
          },
        );
      },
    );
  }
}
