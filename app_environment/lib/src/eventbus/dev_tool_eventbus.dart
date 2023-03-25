/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 21:25:21
 * @Description: 开发工具的各种事件
 */
import 'package:event_bus/event_bus.dart';

EventBus devtoolEventBus = EventBus();

/// 环境初始化完成的事件
class DevtoolEnvironmentInitCompleteEvent {
  DevtoolEnvironmentInitCompleteEvent();
}
