import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './basepage/tsdatepage.dart';

class TSDatePickerHomePage extends CJTSBasePage {
  TSDatePickerHomePage({Key key}) : super(key: key);

  @override
//  _TSDatePickerHomePageState createState() => _TSDatePickerHomePageState();
  CJTSBasePageState getState() {
    return _TSDatePickerHomePageState();
  }
}

class _TSDatePickerHomePageState
    extends CJTSBasePageState<TSDatePickerHomePage> {
  var sectionModels = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('DataPicker 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "DataPicker",
        'values': [
          {
            'title': "DataPicker",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
