/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-08 17:14:43
 * @Description: 
 */
import 'dart:io';
import 'dart:ui';


class CommonModel {
  // CommonModel _commonModel;

  static final CommonModel _instance = CommonModel._internal();

  factory CommonModel() => _instance;

  // CommonModel get mediaModel => _commonModel;

  CommonModel._internal() {
    // if (_commonModel == null) {
    //   _commonModel = CommonModel();
    // }
  }

  CancelToken? cancelToken;

  void dispose() {
    // cancelToken?.cancel();
  }

  int uploadDeviceLastTime = 0;

  ///版本检查
  // Future<VersionBean> checkVersion() async {
  //   return CheckVersionSystemUtil.getVersion();
  // }
}
