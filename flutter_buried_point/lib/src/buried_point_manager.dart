/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-14 15:49:50
 * @Description: 埋点数据上报管理器
 */
import 'dart:async';
import 'package:flutter/foundation.dart'; // debugPrint

class BuriedPointManager {
  // class method

  // -------------------------
  bool hasStart = false;
  Completer initCompleter = Completer<String>();

  // 单例
  factory BuriedPointManager() => _getInstance();
  static BuriedPointManager get instance => _getInstance();

  static BuriedPointManager? _instance;
  BuriedPointManager._internal() {
    //debugPrint('这个单例里的初始化方法只会执行一次');
    _init();
  }

  static BuriedPointManager _getInstance() {
    if (_instance == null) {
      _instance = new BuriedPointManager._internal();
    }
    return _instance!;
  }

  Timer? _uploadTimer;
  List<Map<String, dynamic>> _buriedpointModels = [];
  List<Map<String, dynamic>> get buriedpointModels => _buriedpointModels;
  _init() {
    // print('BuriedPointManager _init');

    _uploadTimer = Timer.periodic(Duration(milliseconds: 5000), (timer) {
      _uploadBuriedpoints();
    });
  }

  Future<Map<String, dynamic>> Function() _extraBodyParamsBlock =
      () => Future.value({});
  bool Function(List<Map<String, dynamic>> eventMaps) _eventUploadHandle =
      (eventMaps) => true;

  /// 初始化设置
  /// extraBodyParamsBlock  埋点数据额外的参数
  /// eventUploadHandle     埋点上报的请求方法
  setup({
    required Future<Map<String, dynamic>> Function() extraBodyParamsBlock,
    required bool Function(List<Map<String, dynamic>> eventMaps)
        eventUploadHandle,
  }) {
    // assert(extraBodyParamsBlock != null);
    // assert(eventUploadHandle != null);
    _extraBodyParamsBlock = extraBodyParamsBlock;
    _eventUploadHandle = eventUploadHandle;
  }

  addExposureEventAttr(Map<String, dynamic> eventAttr) {
    addEvent("exposure", eventAttr);
  }

  addEvent(String eventName, Map<String, dynamic> eventAttr) async {
    Map<String, dynamic> eventMap = {
      "event_name": eventName,
      "event_attr": eventAttr,
    };

    Map<String, dynamic> extraBodyParams = await _extraBodyParamsBlock();
    if (extraBodyParams.isNotEmpty) {
      eventMap.addAll(extraBodyParams);
    }

    _buriedpointModels.add(eventMap);
  }

  _uploadBuriedpoints() {
    if (_buriedpointModels.isEmpty) {
      // tempLog("======================所有埋点数据已上报");
      return;
    }

    // tempLog("======================");

    String eventsString_upload = _getEventsString(_buriedpointModels);
    tempLog("新上报的埋点数据为\n${eventsString_upload}");

    bool uploadSuccess = _eventUploadHandle(_buriedpointModels);

    _buriedpointModels
        .removeWhere((element) => buriedpointModels.contains(element));
    // String eventsString_remain = _getIdsString(_buriedpointModels);
    // tempLog("剩余未上报的曝光数据为${eventsString_remain}");
  }

  String _getEventsString(List<Map<String, dynamic>> buriedpointModels) {
    List<String> ids = [];
    for (Map<String, dynamic> item in buriedpointModels) {
      ids.add(item.toString());
    }
    String eventsString = buriedpointModels.join('\n');
    return eventsString;
  }

  tempLog(String message) {
    String prifix = DateTime.now().toString().substring(5, 19);
    debugPrint("$prifix:$message");
  }
}
