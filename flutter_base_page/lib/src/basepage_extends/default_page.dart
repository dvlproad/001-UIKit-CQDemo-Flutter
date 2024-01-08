/*
 * @Author: dvlproad
 * @Date: 2023-03-21 17:53:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-08 15:01:21
 * @Description: 
 */
import 'package:flutter/material.dart';

import './base_page.dart';

import '../pagetype_error/state_error_widget.dart';
import '../pagetype_nodata/nodata_widget.dart';

//class AppDefaultPage extends StatefulWidget {
abstract class AppDefaultPage extends AppBasePage {
  final String? title;

  AppDefaultPage({Key? key, this.title}) : super(key: key);

  // @override
  // // AppDefaultPageState createState() => AppDefaultPageState();
  // AppDefaultPageState createState() => getState();
  // ///子类实现
  // AppDefaultPageState getState() {
  //   print('请在子类中实现');
  // }
}

//class AppDefaultPageState extends State<AppDefaultPage> {
abstract class AppDefaultPageState<V extends AppDefaultPage>
    extends AppBasePageState<V> {
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
