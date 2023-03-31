/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-30 14:24:57
 * @Description: 开发工具的各种事件
 */
import 'package:event_bus/event_bus.dart';

EventBus environmentEventBus = EventBus();

/// 环境初始化完成的事件
class EnvironmentInitCompleteEvent {
  EnvironmentInitCompleteEvent();
}
