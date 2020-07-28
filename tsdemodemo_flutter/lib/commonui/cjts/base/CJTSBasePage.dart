import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//class CJTSBasePage extends StatefulWidget {
abstract class CJTSBasePage extends StatefulWidget {
  final String title;

  CJTSBasePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState createState() => getState();
  CJTSBasePageState getState();
}

//class _CJTSTableHomeBasePageState extends State<CJTSBasePage> {
abstract class CJTSBasePageState<V extends CJTSBasePage>
    extends State<V> {
  var sectionModels = [];

  @override
  void initState() {
    super.initState();

    sectionModels = [
      {
        'theme': "组件",
        'values': [
          {'title': "Button(按钮)", 'nextPageName': "TSButtonHomePage"},
          {'title': "Image(图片)", 'nextPageName': "TSImageHomePage"},
          // { 'title': "ToolBar(工具器)", 'nextPageName': "ToolBarHomePage" },
        ]
      },
      {
        'theme': "弹窗/蒙层",
        'values': [
          {'title': "Toast", 'nextPageName': "TSToastPage"},
          {'title': "Alert", 'nextPageName': "TSAlertPage"},
          {'title': "ActionSheet", 'nextPageName': "TSActionSheetPage"},
        ]
      }
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'CJTSBasePage'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: contentWidget(),
        ),
      ),
    );
  }

  /// 内容视图
  Widget contentWidget() {
    return Text('请在子类中实现');
  }
}
