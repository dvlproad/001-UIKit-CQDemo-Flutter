/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 17:52:22
 * @Description: 网络环境管理器
 */
// 创建一个单例的Manager类
import 'dart:async';

import 'package:flutter/material.dart';
import './packageType_page_data_bean.dart';
import './packageType_page_data_cache_util.dart';

import './main_diff_util.dart';

class PackageTargetPageDataManager {
  bool hasInitCompleter = false;
  Completer initCompleter = Completer<String>();

  List<PackageTargetModel> _packageTargetModels;
  PackageTargetModel _selectedPackageTargetModel;

  List<PackageTargetModel> get packageTargetModels => _packageTargetModels;
  PackageTargetModel get selectedPackageTargetModel =>
      _selectedPackageTargetModel;

  // 工厂模式
  factory PackageTargetPageDataManager() => _getInstance();
  static PackageTargetPageDataManager get instance => _getInstance();
  static PackageTargetPageDataManager _instance;
  PackageTargetPageDataManager._internal() {
    // 初始化
    init();
  }

  init() {
    _getCache();
  }

  // 获取缓存数据
  void _getCache() async {}

  static PackageTargetPageDataManager _getInstance() {
    if (_instance == null) {
      _instance = new PackageTargetPageDataManager._internal();
    }
    return _instance;
  }

  // packageTarget:获取当前的环境id或环境数据(已选中的要标记check出来)
  Future<Null> initWithDefaultPackageTargetIdAndModels({
    @required List<PackageTargetModel> packageTargetModels_whenNull,
    @required String defaultPackageTargetId_whenNull,
    @required bool canUseCachePackageTarget, // false 则强制使用默认环境
  }) async {
    // 设置 "供切换的"和"默认的" 网络环境
    List<PackageTargetModel> packageTargetModels =
        PackageTargetPageDataManager().packageTargetModels;
    if (packageTargetModels == null) {
      packageTargetModels = packageTargetModels_whenNull;
    }

    String currentPackagetTargetId;
    if (canUseCachePackageTarget == true) {
      currentPackagetTargetId =
          await PackageTargetPageDataCacheUtil.getPackageTargetId();
      if (currentPackagetTargetId == null) {
        currentPackagetTargetId = defaultPackageTargetId_whenNull;
      } else {
        List<String> packageTargetIds = [];
        for (PackageTargetModel packageTargetModel in packageTargetModels) {
          packageTargetIds.add(packageTargetModel.envId);
        }
        if (packageTargetIds.contains(currentPackagetTargetId) == false) {
          print(
              '温馨提示:找不到$currentPackagetTargetId指定的网络环境,可能为数据发生了改变,所以强制使用默认的网络环境');
          currentPackagetTargetId = defaultPackageTargetId_whenNull;
        }
        PackageTargetPageDataCacheUtil.setPackageTargetId(
            currentPackagetTargetId);
      }
    } else {
      currentPackagetTargetId = defaultPackageTargetId_whenNull;
    }

    // 根据 selectedPackageTargetId 获取到 _selectedPackageTargetModel，同时对各 PackageTargetModel 进行是否 check 的标记
    for (int i = 0; i < packageTargetModels.length; i++) {
      PackageTargetModel packageTargetModel = packageTargetModels[i];
      if (packageTargetModel.envId == currentPackagetTargetId) {
        packageTargetModel.check = true;
        _selectedPackageTargetModel = packageTargetModel;
      } else {
        packageTargetModel.check = false;
      }
    }

    _packageTargetModels = packageTargetModels;

    initCompleter.complete('PackageTargetPageDataManager:初始化完成，此时才可以进行实际环境获取');
    print('PackageTargetPageDataManager:初始化完成，此时才可以进行实际环境获取');
    hasInitCompleter = true;
  }

  /// 修改网络环境_页面数据
  updatePackageTargetPageSelectedData(
      PackageTargetModel selectedPackageTargetModel) {
    _selectedPackageTargetModel = selectedPackageTargetModel;
    PackageTargetPageDataCacheUtil.setPackageTargetId(
        selectedPackageTargetModel.envId);
  }
}
