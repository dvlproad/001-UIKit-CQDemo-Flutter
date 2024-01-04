/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-12 13:05:08
 * @Description: 获取指定的日志
 */

import 'dart:math';

import '../bean/log_data_bean.dart';
import 'dev_log_util.dart';

class DangerousLogModel {
  final String title;
  final String content;

  DangerousLogModel({required this.title, required this.content});
}

class LogGetterUtil {
  // 获取白屏相关的log日志

  static DangerousLogModel getFullLogStringForWhiteScreen({
    int? logMaxCount, // 只取最后几条日志，>0时候才有效，其他默认全取
  }) {
    List<LogModel> logModels = DevLogUtil.logModels;

    // 1、获取日志原始数据
    List<LogModel> resultLogModels = _getLogModelsForWhiteScreen(
      logModels,
      logMaxCount: logMaxCount,
    );

    // 2、获取日志简洁信息
    String fullResultLogString = getFullLogString(resultLogModels);

    // title
    LogModel resultLogModel = resultLogModels.last;
    String resultLogString = resultLogModel.shortMapString;
    String logTitle =
        resultLogString.substring(0, min(12, resultLogString.length));

    return DangerousLogModel(title: logTitle, content: fullResultLogString);
  }

  static List<LogModel> _getLogModelsForWhiteScreen(
    List<LogModel> logModels, {
    int? logMaxCount, // 只取最后几条日志，>0时候才有效，其他默认全取
  }) {
    List<LogModel> resultLogModels = [];

    int logCount = logModels.length;
    for (var i = 0; i < logCount; i++) {
      LogModel logModel = logModels[i];

      if (logModel.logLevel == LogLevel.error ||
          logModel.logLevel == LogLevel.dangerous) {
        resultLogModels.add(logModel);
      } else if (logModel.logLevel == LogLevel.warning) {
        resultLogModels.add(logModel);
      } else {
        if (logModel.logType == LogObjectType.route) {
          resultLogModels.add(logModel);
        } else if (logModel.logType == LogObjectType.h5_route) {
          resultLogModels.add(logModel);
        } else if (logModel.logType == LogObjectType.monitor_network) {
          resultLogModels.add(logModel);
        } else if (logModel.logType == LogObjectType.monitor_lifecycle) {
          resultLogModels.add(logModel);
        }
      }
    }

    int resultLogCount = resultLogModels.length;
    if (logMaxCount != null &&
        logMaxCount > 0 &&
        resultLogCount > logMaxCount) {
      // 获取数组最后几个元素
      int logStartIndex = resultLogCount - logMaxCount;
      resultLogModels = resultLogModels.sublist(logStartIndex);
    }

    return resultLogModels;
  }

  static String getFullLogString(List<LogModel> resultLogModels) {
    String fullResultLogString = "";

    int logMaxCount = resultLogModels.length;
    int logMaxLength = (4096 / logMaxCount - 10).floor();

    List<String> resultLogStrings = [];
    int resultLogCount = resultLogModels.length;
    for (var i = resultLogCount - 1; i >= 0; i--) {
      // 使用倒序方式，让越重要的信息越靠前
      LogModel resultLogModel = resultLogModels[i];
      String resultLogString = resultLogModel.shortMapString;
      resultLogString = resultLogString.substring(
        0,
        min(resultLogString.length, logMaxLength),
      );
      resultLogStrings.add(resultLogString);

      if (i < resultLogCount - 1) {
        fullResultLogString += "\n\n";
      }

      fullResultLogString += "第${i + 1}条日志:\n $resultLogString";
    }

    // String fullResultLogString = resultLogStrings.join('\n');

    return fullResultLogString;
  }
}
