import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'CJTSSectionTableView.dart';

//class CJTSTableHomeBasePage extends StatefulWidget {
abstract class CJTSTableHomeBasePage extends StatefulWidget {
  final String title;

  CJTSTableHomeBasePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSTableHomeBasePageState createState() => getState();
  CJTSTableHomeBasePageState getState();
}

//class _CJTSTableHomeBasePageState extends State<CJTSTableHomeBasePage> {
abstract class CJTSTableHomeBasePageState<V extends CJTSTableHomeBasePage> extends State<V> {
  var sectionModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sectionModels = [
      { 'theme': "组件",
        'values': [
          { 'title': "Button(按钮)", 'nextPageName': "TSButtonHomePage" },
          { 'title': "Image(图片)", 'nextPageName': "TSImageHomePage" },
          // { 'title': "ToolBar(工具器)", 'nextPageName': "ToolBarHomePage" },
        ]
      },
      { 'theme': "弹窗/蒙层",
        'values': [
          { 'title': "Toast", 'nextPageName': "TSToastPage" },
          { 'title': "Alert", 'nextPageName': "TSAlertPage" },
          { 'title': "ActionSheet", 'nextPageName': "TSActionSheetPage" },
        ]
      }
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base List2 '),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: CJTSSectionTableView(
              sectionModels: sectionModels,
          ),
        ),
      ),
    );
  }
}
