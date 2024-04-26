/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-09 11:26:43
 * @Description: Alert弹窗工具类
 */
import 'package:flutter/material.dart';

class OverlayInit {
  static BuildContext? Function()? get contextGetBlock => _contextGetBlock;
  static BuildContext? Function()? _contextGetBlock;

  // 游戏中，不显示APP内的toast，除非该路由本身调用
  static bool Function()? get shouldGiveupToastCheck => _shouldGivupToastCheck;
  static bool Function()? _shouldGivupToastCheck;

  static init({
    required BuildContext? Function() contextGetBlock,
    bool Function()? shouldGiveupToastCheck,
  }) {
    _contextGetBlock = contextGetBlock;
    _shouldGivupToastCheck = shouldGiveupToastCheck;
  }
}
