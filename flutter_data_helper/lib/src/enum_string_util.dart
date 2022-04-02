import 'dart:math' show min;
import 'package:flutter/material.dart';

class EnumStringUtil {
  ///枚举类型转string
  static String enumToString(o) => o.toString().split('.').last;

  ///string转枚举类型
  static T enumFromString<T>(Iterable<T> values, String value) {
    // return values.firstWhere((type) => type.toString().split('.').last == value, orElse: () => null);
    return values.firstWhere((type) {
      return type.toString().split('.').last == value;
    }, orElse: () {
      return null;
    });
  }
}

// 使用示例：
/*
enum OrderRealType {
  unknow, // 位置
  send_all, //我送出的全部
  send_to_be_pay, //我送出的待付款
  send_to_be_ship, //我送出的待发货
  send_shipping, //我送出的已发货
  send_arrived, //我送出的已送达
  receive_all, //我收到的全部
  receive_to_be_ship, //我收到的待发货
  receive_shipping, //我收到的已发货
  receive_arrived, //我收到的已送达
}

///string转枚举类型
OrderRealType orderRealTypeFromString(String value) {
  Iterable<OrderRealType> values = [
    OrderRealType.unknow, // 位置
    OrderRealType.send_all, //我送出的全部
    OrderRealType.send_to_be_pay, //我送出的待付款
    OrderRealType.send_to_be_ship, //我送出的待发货
    OrderRealType.send_shipping, //我送出的已发货
    OrderRealType.send_arrived, //我送出的已送达
    OrderRealType.receive_all, //我收到的全部
    OrderRealType.receive_to_be_ship, //我收到的待发货
    OrderRealType.receive_shipping, //我收到的已发货
    OrderRealType.receive_arrived, //我收到的已送达
  ];
  return EnumStringUtil.enumFromString(values, value);
}

///枚举类型转string
String orderRealTypeStringFromEnum(o) {
  return EnumStringUtil.enumToString(o);
}
*/