/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-10 16:43:45
 * @Description: 开发工具的各种事件
 */
import 'package:event_bus/event_bus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
export 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;

EventBus networkEventBus = new EventBus();

/// Connection status check result.
enum NetworkType {
  /// unknow
  unknow,

  /// Bluetooth: Device connected via bluetooth
  bluetooth,

  /// WiFi: Device connected via Wi-Fi
  wifi,

  /// Ethernet: Device connected to ethernet network
  ethernet,

  /// Mobile: Device connected to cellular network
  mobile,

  /// None: Device not connected to any network
  none
}

/// 环境初始化完成的事件
class NetworkTypeChangeEvent {
  NetworkType connectionStatus;
  NetworkTypeChangeEvent(this.connectionStatus);
}
