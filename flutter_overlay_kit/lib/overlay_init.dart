/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-09 11:26:43
 * @Description: Alert弹窗工具类
 */
import 'package:flutter/material.dart';

class OverlayInit {
  static BuildContext Function()? overlayContextNullHandle;
  static init(BuildContext Function() tOverlayContextNullHandle) {
    overlayContextNullHandle = tOverlayContextNullHandle;
  }
}
