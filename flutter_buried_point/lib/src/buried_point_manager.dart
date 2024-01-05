// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-05 15:43:48
 * @Description: 埋点数据上报管理器
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_kit/flutter_cache_kit.dart';
import 'package:flutter_log_with_env/flutter_log_with_env.dart';
import 'package:flutter_foundation_base/flutter_foundation_base.dart';

import './position_enum.dart';

class BuriedPointManager {
  final String _saveRemainBuriedPointsKey = "saveRemainBuriedPointsKey";
  final String _appEndBuriedPointIntervalKey = "appEndBuriedPointIntervalKey";
  final String _appEndBuriedExtraBodyParamsKey =
      "appEndBuriedExtraBodyParamsKey";

  /// ---------- iOS appEnd埋点恢复 -------》
  final String _iOSAppStartTimeKey = "iOSAppStartTimeKey";
  final String _iOSAppEndTimeKey = "iOSAppEndTimeKey";

  /// ---------- iOS appEnd埋点恢复 -------《

  bool hasStart = false;
  Completer initCompleter = Completer<String>();

  // 单例
  factory BuriedPointManager() => _getInstance();

  static BuriedPointManager get instance => _getInstance();

  static BuriedPointManager? _instance;

  BuriedPointManager._internal() {
    _init();
  }

  static BuriedPointManager _getInstance() {
    _instance ??= BuriedPointManager._internal();
    return _instance!;
  }

  // ignore: unused_field
  Timer? _uploadTimer;
  final List<Map<String, dynamic>> _buriedPointModels = [];

  List<Map<String, dynamic>> get buriedPointModels => _buriedPointModels;

  _init() {
    // print('BuriedPointManager _init');

    _uploadTimer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      _uploadBuriedPoints();
    });
  }

  Future<Map<String, dynamic>> Function() _bodyCommonChangeParamsGetBlock =
      () => Future.value({});
  bool Function(List<Map<String, dynamic>> eventMaps)? _eventUploadHandle;

  /// 初始化设置
  /// bodyCommonChangeParamsGetBlock  埋点数据额外的参数
  /// eventUploadHandle               埋点上报的请求方法
  setup({
    required Future<Map<String, dynamic>> Function()
        bodyCommonChangeParamsGetBlock,
    required bool Function(List<Map<String, dynamic>> eventMaps)
        eventUploadHandle,
  }) {
    _bodyCommonChangeParamsGetBlock = bodyCommonChangeParamsGetBlock;
    _eventUploadHandle = eventUploadHandle;
  }

  addExposureEventAttr(Map<String, dynamic> eventAttr) {
    addEvent("exposure", eventAttr);
  }

  static add_click_photo_change(BPPosition postion,
      {required int old_index, required int cur_index, required int count}) {
    Map<String, dynamic> extrAttr = {
      "old_index": old_index,
      "cur_index": cur_index,
      "count": count,
    };

    addBP(postion, "click_photo_change", extrAttr: extrAttr);
  }

  static add_click_photo_browse(BPPosition postion,
      {required int index, required int count}) {
    Map<String, dynamic> extrAttr = {
      "index": index,
      "count": count,
    };

    addBP(postion, "click_photo_browse", extrAttr: extrAttr);
  }

  static add_click_avtar(BPPosition postion, String accountId) {
    Map<String, dynamic> extrAttr = {"accountId": accountId};

    addBP(postion, "click_avtar", extrAttr: extrAttr);
  }

  static add_click_tab(BPPosition postion, String tabName) {
    Map<String, dynamic> extrAttr = {"tab_name": tabName};

    addBP(postion, "click_tab", extrAttr: extrAttr);
  }

  static addBP(
    BPPosition postion,
    String eventName, {
    Map<String, dynamic>? extrAttr,
  }) {
    Map<String, dynamic> eventAttr = {"position": postion.name};

    if (extrAttr != null) {
      eventAttr.addAll(extrAttr);
    }
    BuriedPointManager().addEvent(eventName, eventAttr);
  }

  addEvent(String eventName, Map<String, dynamic> eventAttr) async {
    Map<String, dynamic> eventMap = {};

    Map<String, dynamic> extraBodyParams =
        await _bodyCommonChangeParamsGetBlock();
    if (extraBodyParams.isNotEmpty) {
      eventMap.addAll(extraBodyParams);
    }

    eventMap.addAll({
      "event_name": eventName,
      "event_attr": eventAttr,
      "request_time": DateTime.now().millisecondsSinceEpoch, // 单条记录生成时间，精确到毫秒
    });

    _buriedPointModels.add(eventMap);
  }

  addEventWithExtraBodyParams(String eventName, Map<String, dynamic> eventAttr,
      Map<String, dynamic>? extraBodyParams) async {
    Map<String, dynamic> eventMap = {
      "event_name": eventName,
      "event_attr": eventAttr,
    };

    extraBodyParams ??= await _bodyCommonChangeParamsGetBlock();
    if (extraBodyParams.isNotEmpty) {
      eventMap.addAll(extraBodyParams);
    }
    _buriedPointModels.add(eventMap);
  }

  _uploadBuriedPoints() {
    if (_buriedPointModels.isEmpty) {
      // tempLog("======================所有埋点数据已上报");
      return;
    }

    // tempLog("======================");

    if (_eventUploadHandle != null) {
      String eventsStringUpload = MapsIntercept2StringUtil.maps2String(
        buriedPointModels,
        maxLength: 40,
      );
      tempLog("正要请求上报的埋点数据为\n$eventsStringUpload");

      _eventUploadHandle?.call(_buriedPointModels);
    }
    _buriedPointModels
        .removeWhere((element) => buriedPointModels.contains(element));
    // String eventsString_remain = _getIdsString(_buriedPointModels);
    // tempLog("剩余未上报的曝光数据为${eventsString_remain}");
  }

  // ignore: unused_element
  String _getEventsString(List<Map<String, dynamic>> buriedPointModels) {
    List<String> ids = [];
    for (Map<String, dynamic> item in buriedPointModels) {
      ids.add(item.toString());
    }
    String eventsString = buriedPointModels.join('\n');
    return eventsString;
  }

  tempLog(String message) {
    String prefix = DateTime.now().toString().substring(5, 19);
    AppLogUtil.logMessage(
      title: "$prefix:$message",
      logType: LogObjectType.buriedPoint_other,
      logLevel: LogLevel.normal,
      shortMap: {"message": "$prefix:$message"},
      detailMap: {},
    );
  }

  /// 存储appStart的时间戳，供iOS原生使用
  void saveAppStartTime(DateTime time) async {
    if (Platform.isAndroid) {
      return;
    }
    LocalStorage.save(_iOSAppStartTimeKey, time.millisecondsSinceEpoch);
    var extraBodyParams = await _bodyCommonChangeParamsGetBlock();
    LocalStorage.save(
      _appEndBuriedExtraBodyParamsKey,
      json.encode(extraBodyParams),
    );
  }

  /// 存储被强杀还未上传的埋点, 获取appEnd事件的参数，并保存
  Future<void> saveAppTerminateRemainBuriedPoints(DateTime time) async {
    var interval = DateTime.now().difference(time).inMilliseconds;
    var extraBodyParams = await _bodyCommonChangeParamsGetBlock();
    LocalStorage.save(
        _appEndBuriedExtraBodyParamsKey, json.encode(extraBodyParams));
    LocalStorage.save(_appEndBuriedPointIntervalKey, interval);
    String remainBuriedPoints = json.encode(_buriedPointModels);
    await LocalStorage.save(_saveRemainBuriedPointsKey, remainBuriedPoints);
  }

  /// 恢复被强杀或系统杀掉的埋点数据
  Future<void> recoveryAppTerminateRemainBuriedPoints(
      void Function() callback) async {
    String? buriedPointsString =
        await LocalStorage.get(_saveRemainBuriedPointsKey);
    if (buriedPointsString == null || buriedPointsString.length < 6) {
      if (Platform.isIOS) {
        double appEndTime = await LocalStorage.get(_iOSAppEndTimeKey) ?? 0;
        double appStartTime = await LocalStorage.get(_iOSAppStartTimeKey) ?? 0;
        var extraBodyParams = await _bodyCommonChangeParamsGetBlock();
        extraBodyParams["request_time"] = appEndTime;
        var interval = appEndTime - appStartTime;
        if (interval > 0 && appStartTime != 0 && appEndTime != 0) {
          await addEventWithExtraBodyParams(
              "appEnd", {'duration': interval}, extraBodyParams);
          logMessage(
            shortMap: {
              "message": "强杀埋点恢复：只有appEnd可以恢复，其他的来不及存储，endTime:$appEndTime"
            },
          );
        } else {
          logMessage(
            shortMap: {
              "message":
                  "强杀埋点恢复：没有需要恢复的数据，iOS强杀时间存储异常appEndTime时间早于appStartTime"
            },
          );
        }
      } else {
        logMessage(
          shortMap: {"message": "强杀埋点恢复：没有需要恢复的数据"},
        );
      }
      return;
    }
    try {
      List<dynamic>? buriedPoints = json.decode(buriedPointsString);
      var recoveryDataShortMap = {
        "message": "强杀埋点恢复：待恢复的埋点数据",
        "data": buriedPoints ?? []
      };
      logMessage(
          shortMap: recoveryDataShortMap, detailMap: recoveryDataShortMap);
      if (buriedPoints != null && buriedPoints.isNotEmpty) {
        for (var element in buriedPoints) {
          _buriedPointModels.add(element);
        }
        int interval = await LocalStorage.get(_appEndBuriedPointIntervalKey);
        String? extraBodyParamsString =
            await LocalStorage.get(_appEndBuriedExtraBodyParamsKey);
        Map<String, dynamic> extraBodyParams =
            json.decode(extraBodyParamsString ?? "");
        await addEventWithExtraBodyParams(
            "appEnd", {'duration': interval}, extraBodyParams);
        for (var element in _buriedPointModels) {
          if (element["event_name"] == "appEnd") {
            logMessage(
              shortMap: {"message": "appEnd埋点恢复数据", "data": element},
              detailMap: recoveryDataShortMap,
            );
          }
        }

        LocalStorage.remove(_saveRemainBuriedPointsKey);
        LocalStorage.remove(_appEndBuriedPointIntervalKey);
      }
    } catch (error) {
      var map = {"message": error.toString()};
      logMessage(shortMap: map, detailMap: map);
    }
    callback();
  }

  void logMessage(
      {required Map<String, dynamic> shortMap,
      Map<String, dynamic>? detailMap}) {
    AppLogUtil.logMessage(
      logType: LogObjectType.buriedPoint_other,
      logLevel: LogLevel.warning,
      shortMap: shortMap,
      detailMap: detailMap ?? {},
    );
  }
}
