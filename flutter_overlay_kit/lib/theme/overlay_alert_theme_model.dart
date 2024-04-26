/*
 * @Author: dvlproad
 * @Date: 2024-04-27 00:14:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-27 00:40:45
 * @Description: 
 */
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

class CJOverlayAlertThemeModel {
  final double actionButtonHeight;
  final double actionButtonCornerRadius;

  final CJButtonConfigModel cancelButtonConfig;
  final CJButtonConfigModel okButtonConfig;

  final CJButtonConfigModel iKnowButtonConfig;

  CJOverlayAlertThemeModel({
    required this.actionButtonHeight,
    this.actionButtonCornerRadius = 0,
    required this.cancelButtonConfig,
    required this.okButtonConfig,
    required this.iKnowButtonConfig,
  });
}
