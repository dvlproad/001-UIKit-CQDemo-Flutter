import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';

import './version_bean.dart';
export './version_bean.dart';

import './check_version_system_util.dart';

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

  CancelToken cancelToken;

  void dispose() {
    // cancelToken?.cancel();
  }

  int uploadDeviceLastTime = 0;

  ///版本检查
  Future<VersionBean> checkVersion() async {
    return CheckVersionSystemUtil.getVersion();
  }
}
