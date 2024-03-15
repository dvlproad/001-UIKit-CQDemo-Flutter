/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-16 00:01:19
 * @Description: 开发工具的各种事件
 */
import 'package:event_bus/event_bus.dart';

EventBus environmentEventBus = EventBus();

/// 环境初始化完成的事件
class EnvironmentInitCompleteEvent {
  SpendDateModel networkPageDataSpendModel;
  SpendDateModel proxyPageDataSpendModel;
  SpendDateModel targetPageDataSpendModel;
  EnvironmentInitCompleteEvent({
    required this.networkPageDataSpendModel,
    required this.proxyPageDataSpendModel,
    required this.targetPageDataSpendModel,
  });
}

class SpendDateModel {
  final DateTime startTime;
  final DateTime endTime; //ms

  SpendDateModel({
    required this.startTime, // 请求开始的时间
    required this.endTime, // 请求结束的时间
  });

  static String getSpendTime(List<SpendDateModel> dateModels) {
    SpendDateModel firstDateModel = dateModels.first;
    SpendDateModel lastDateModel = dateModels.last;

    String allItemSpendTime = "";
    int count = dateModels.length;

    DateTime? lastEndTime;
    for (int i = 0; i < count; i++) {
      SpendDateModel dateModel = dateModels[i];

      String spendTime = "${i + 1}";
      spendTime += "、${dateModel.spendTimeString}";
      spendTime +=
          "${dateModel.startTime.toString().substring(11)}--${dateModel.endTime.toString().substring(11)}";
      if (i > 0) {
        allItemSpendTime += "====";

        if (lastEndTime != null) {
          Duration skipDuration = dateModel.startTime.difference(lastEndTime);
          allItemSpendTime += "${skipDuration.inMilliseconds}毫秒====";
        }
      }
      allItemSpendTime += spendTime;

      lastEndTime = dateModel.endTime;
    }

    Duration totalDuration =
        lastDateModel.endTime.difference(firstDateModel.startTime);
    // int seconds = totalDuration.inSeconds;
    int milliseconds = totalDuration.inMilliseconds;
    // return apiDuration.toString();
    String spendTime = "$milliseconds毫秒($allItemSpendTime)";

    return spendTime;
  }

  String get spendTimeString {
    Duration duration = endTime.difference(startTime);

    // int seconds = duration.inSeconds;
    int milliseconds = duration.inMilliseconds;
    if (milliseconds > 0) {
      return "$milliseconds毫秒";
    } else {
      int microseconds = duration.inMicroseconds;
      return "0毫秒$microseconds微秒";
    }
  }
}
