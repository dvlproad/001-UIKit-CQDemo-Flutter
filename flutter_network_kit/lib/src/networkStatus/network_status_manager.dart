/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-07 15:01:55
 * @Description: 网络状态管理
 */
import 'dart:async' show Completer, StreamSubscription;
import 'dart:developer' as developer;

import 'dart:io' show NetworkInterface, InternetAddressType, InternetAddress;
import 'dart:ui' show window;

import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// eventbus
import './network_eventbus.dart';
export './network_eventbus.dart' show NetworkType;
// export 'package:connectivity_plus/connectivity_plus.dart' show ConnectivityResult;

import 'package:flutter_log/flutter_log.dart';
import '../log/api_log_util.dart';

class NetworkStatusManager {
  // public method
  NetworkType get connectionStatus => _connectionStatus;

  Future<NetworkType> get realConnectionStatus async {
    await _initCompleter.future;
    return _connectionStatus;
  }

  // 单例
  bool _hasStart = false;
  Completer _initCompleter = Completer<String>();

  factory NetworkStatusManager() => _getInstance();
  static NetworkStatusManager get instance => _getInstance();
  static NetworkStatusManager? _instance;
  static NetworkStatusManager _getInstance() {
    if (_instance == null) {
      _instance = NetworkStatusManager._internal();
    }
    return _instance!;
  }

  NetworkStatusManager._internal() {
    //debugPrint('这个单例里的初始化方法只会执行一次');

    _init();
  }

  NetworkType _connectionStatus = NetworkType.unknow;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  _init() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    _updateConnectionStatus(result);

    _hasStart = true;
    _initCompleter
        .complete('NetworkStatusManager:初始化完成，此时才可以获取ConnectivityResult');
    print('NetworkStatusManager:初始化完成，此时才可以获取ConnectivityResult');

    return;
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    NetworkType oldConnectionStatus = _connectionStatus;
    if (result == ConnectivityResult.none) {
      _connectionStatus = NetworkType.none;
    } else if (result == ConnectivityResult.bluetooth) {
      _connectionStatus = NetworkType.bluetooth;
    } else if (result == ConnectivityResult.wifi) {
      _connectionStatus = NetworkType.wifi;
    } else if (result == ConnectivityResult.ethernet) {
      _connectionStatus = NetworkType.ethernet;
    } else if (result == ConnectivityResult.mobile) {
      _connectionStatus = NetworkType.mobile;
    } else {
      _connectionStatus = NetworkType.unknow;
    }

    LogApiUtil.logNetworkStatus(
      oldConnectionStatus: oldConnectionStatus,
      curConnectionStatus: _connectionStatus,
    );

    networkEventBus.fire(NetworkTypeChangeEvent(_connectionStatus));
  }
}
