import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';

class TSDatePickerPage extends StatefulWidget {
  @override
  _TSDatePickerPageState createState() => _TSDatePickerPageState();
}

class _TSDatePickerPageState extends State<TSDatePickerPage> {
  String currentSelectedDateString;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('DatePicker'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('1. 选择生日'),
              onTap: () {
                DatePickerUtil.chooseBirthday(
                  context,
                  title: '选择你的生日',
                  selectedyyyyMMddDateString: currentSelectedDateString,
                  onConfirm: (selectedyyyyMMddDateString) {
                    currentSelectedDateString = selectedyyyyMMddDateString;
                    CJTSToastUtil.showMessage(
                        '所选择的日期:$selectedyyyyMMddDateString');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
