import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './tsdatepage.dart';

class TSBasePageHomePage extends CJTSBasePage {
  TSBasePageHomePage({Key key}) : super(key: key);

  @override
//  _TSBasePageHomePageState createState() => _TSBasePageHomePageState();
  CJTSBasePageState getState() {
    return _TSBasePageHomePageState();
  }
}

class _TSBasePageHomePageState extends CJTSBasePageState<TSBasePageHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('DatePicker 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "其他",
        'values': [
          {
            'title': "DatePicker",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          },
          {
            'title': "DatePicker",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              PickHelper.openDateTimePicker(context,
                  onConfirm: (Picker picker, List<int> selected) {
                print(selected);
                DateTime dateTime =
                    (picker.adapter as DateTimePickerAdapter).value;
                print(dateTime);
              });
            },
          },
        ]
      },
    ];

    return Column(
      children: <Widget>[
        Expanded(
          child: CJTSSectionTableView(
            context: context,
            sectionModels: sectionModels,
          ),
        ),
      ],
    );
  }
}
