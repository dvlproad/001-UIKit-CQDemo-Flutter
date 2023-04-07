/*
 * @Author: dvlproad
 * @Date: 2023-03-21 17:53:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 14:37:40
 * @Description: 
 */
import 'package:flutter/material.dart';

import './base_page.dart';

import '../pagetype_error/state_error_widget.dart';
import '../pagetype_nodata/nodata_widget.dart';

//class BJHDefaultPage extends StatefulWidget {
abstract class BJHDefaultPage extends BJHBasePage {
  final String? title;

  BJHDefaultPage({Key? key, this.title}) : super(key: key);

  // @override
  // // BJHDefaultPageState createState() => BJHDefaultPageState();
  // BJHDefaultPageState createState() => getState();
  // ///子类实现
  // BJHDefaultPageState getState() {
  //   print('请在子类中实现');
  // }
}

//class BJHDefaultPageState extends State<BJHDefaultPage> {
abstract class BJHDefaultPageState<V extends BJHDefaultPage>
    extends BJHBasePageState<V> {
  /// 请求网络数据(常用此函数名)
  void getData() {}

  @override
  Widget buildInitWidget(BuildContext context) {
    //return null; // 如果返回null 会黑屏
    return Container(
      color: Colors.white,
    );
  }

  @override
  Widget buildSuccessWidget(BuildContext context) {
    return Container();
  }

  @override
  Widget buildNodataWidget(BuildContext context) {
    return StateNodataWidget();
  }

  @override
  Widget buildErrorWidget(BuildContext context) {
    return StateErrorWidget(
      errorRetry: getData,
    );
  }
}
