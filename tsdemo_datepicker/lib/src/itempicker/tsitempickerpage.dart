import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';

class TSItemPickerPage extends StatefulWidget {
  @override
  _TSItemPickerPageState createState() => _TSItemPickerPageState();
}

class _TSItemPickerPageState extends State<TSItemPickerPage> {
  int selectedSexIndex;

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
            _chooseSexRow,
          ],
        ),
      ),
    );
  }

  Widget get _chooseSexRow {
    return ListTile(
      title: Text('1. 选择男女'),
      onTap: () {
        ItemPickerUtil.chooseItem(
          context,
          title: '选择性别',
          itemTitles: ['男', '女'],
          currentSelectedIndex: selectedSexIndex,
          onConfirm: (selectedIndex) {
            selectedSexIndex = selectedIndex;
            List<String> itemTitles = ['男', '女'];
            String sexString = itemTitles[selectedIndex];
            CJTSToastUtil.showMessage('所选择的性别:$sexString');
          },
        );
      },
    );
  }
}
