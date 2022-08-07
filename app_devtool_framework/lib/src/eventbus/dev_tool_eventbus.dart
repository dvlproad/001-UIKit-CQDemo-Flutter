/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-29 11:02:20
 * @Description: 开发工具的各种事件
 */
import 'package:event_bus/event_bus.dart';

EventBus devtoolEventBus = new EventBus();

/// 环境初始化完成的事件
class DevtoolEnvironmentInitCompleteEvent {
  DevtoolEnvironmentInitCompleteEvent();
}
