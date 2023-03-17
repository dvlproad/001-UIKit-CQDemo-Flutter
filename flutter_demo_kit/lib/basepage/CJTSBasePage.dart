/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 13:56:33
 * @Description: 
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//class CJTSBasePage extends StatefulWidget {
abstract class CJTSBasePage extends StatefulWidget {
  final String? title;

  CJTSBasePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState createState() => getState();

  ///子类实现
  CJTSBasePageState getState();
}

//class _CJTSTableHomeBasePageState extends State<CJTSBasePage> {
abstract class CJTSBasePageState<V extends CJTSBasePage> extends State<V> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        color: backgroundColor(),
        child: contentWidget(),
      ),
    );
  }

  // appBar
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'CJTSBasePage'),
    );
  }

  // backgroundColor
  Color backgroundColor() {
    return Colors.black.withAlpha(30);
  }

  /// 内容视图
  Widget contentWidget() {
    return Text('请在子类中实现');
  }
}
