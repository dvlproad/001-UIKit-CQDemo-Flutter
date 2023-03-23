/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 17:10:10
 * @Description: log日志管理器
 */
import 'dart:collection';

import '../../bean/err_options.dart';
import '../../bean/net_options.dart';
import '../../bean/req_options.dart';
import '../../bean/res_options.dart';

class LogPoolManager {
  ///请求日志存储
  late LinkedHashMap<String, NetOptions> logMap;

  late List<String> keys;

  ///存储请求最大数
  int maxCount = 50;
  static LogPoolManager? _instance;

  LogPoolManager._singleton() {
    // ignore: prefer_collection_literals
    logMap = LinkedHashMap();
    keys = <String>[];
  }

  static LogPoolManager getInstance() {
    _instance ??= LogPoolManager._singleton();
    return _instance!;
  }

  // request
  void onRequest(
    ReqOptions options, {
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
    required void Function(NetOptions apiInfo) completeBlock,
  }) {
    NetOptions apiInfo = _addNew(
      options,
      getSuccessResponseModelBlock: getSuccessResponseModelBlock,
    );

    completeBlock(apiInfo);
  }

  NetOptions _addNew(
    ReqOptions options, {
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
  }) {
    if (logMap.length >= maxCount) {
      logMap.remove(keys.last);
      keys.removeLast();
    }
    var key = options.id.toString();
    keys.insert(0, key);
    NetOptions apiInfo = logMap.putIfAbsent(key, () {
      return NetOptions(
        reqOptions: options,
        getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      );
    });

    return apiInfo;
  }

  // error
  void onError(
    ErrOptions err, {
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
    required void Function(NetOptions apiInfo) completeBlock,
  }) {
    NetOptions apiInfo;

    var key = err.id.toString();
    if (logMap.containsKey(key)) {
      apiInfo = logMap.update(key, (value) {
        value.errOptions = err;
        return value;
      });
      apiInfo.getSuccessResponseModelBlock = getSuccessResponseModelBlock;
    } else {
      ReqOptions options = err.requestOptions;
      apiInfo = _addNew(
        options,
        getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      );
      apiInfo.errOptions = err;

      // print("未找到该返回对应的请求，请修复。可能原因有①使用缓存的时候，返回的reponse中，修改了requestOptions");
    }

    completeBlock(apiInfo);
  }

  // response
  void onResponse(
    ResOptions response, {
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
    required void Function(NetOptions apiInfo) completeBlock,
  }) {
    NetOptions apiInfo;
    var key = response.id.toString();
    if (logMap.containsKey(key)) {
      apiInfo = logMap.update(key, (NetOptions value) {
        // response.duration = response.responseTime.millisecondsSinceEpoch -
        //     value.reqOptions.requestTime.millisecondsSinceEpoch;
        value.resOptions = response;
        return value;
      });
      apiInfo.getSuccessResponseModelBlock = getSuccessResponseModelBlock;
    } else {
      ReqOptions options = response.requestOptions;
      apiInfo = _addNew(
        options,
        getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      );
      apiInfo.resOptions = response;

      // debugPrint("未找到该返回对应的请求，请修复。可能原因有①使用缓存的时候，返回的reponse中，修改了requestOptions");
    }

    completeBlock(apiInfo);
  }

  ///日志清除
  void clear() {
    logMap.clear();
    keys.clear();
  }
}
