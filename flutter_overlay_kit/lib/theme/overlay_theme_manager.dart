/*
 * @Author: dvlproad
 * @Date: 2024-04-27 00:06:28
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-27 01:29:03
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit_adapt.dart';

import './overlay_alert_theme_model.dart';
import 'overlay_sheet_theme_model.dart';

class CJBaseOverlayThemeManager {
  // 属性
  late CJOverlayAlertThemeModel alertThemeModel;
  late CJOverlaySheetThemeModel sheetThemeModel;

  // 单例
  CJBaseOverlayThemeManager._() {
    useThemeDefault();
  }
  static final CJBaseOverlayThemeManager _instance =
      CJBaseOverlayThemeManager._();
  factory CJBaseOverlayThemeManager() => _instance;

  // 使用示例
  void useThemeDefault() {
    alertThemeModel = CJOverlayAlertThemeModel(
      actionButtonHeight: 45,
      actionButtonCornerRadius: 18.w_pt_cj,
      cancelButtonConfig: CJButtonConfigModel(
        // bgColorType: ThemeBGType.theme,
        bgColor: Colors.white,
        textColor: Colors.black,
        borderWidth: 1.0.w_pt_cj,
        borderColor: Colors.black,
      ),
      okButtonConfig: CJButtonConfigModel(
        // bgColorType: ThemeBGType.theme,
        bgColor: Colors.black,
        textColor: Colors.white,
        borderWidth: null,
        borderColor: null,
      ),
      iKnowButtonConfig: CJButtonConfigModel(
        // bgColorType: ThemeBGType.theme,
        bgColor: Colors.black,
        textColor: Colors.white,
        borderWidth: null,
        borderColor: null,
      ),
    );

    sheetThemeModel = CJOverlaySheetThemeModel(
      cellRowHeight: 44.h_pt_cj,
      itemButtonConfig: CJButtonConfigModel(
        // bgColorType: ThemeBGType.theme,
        bgColor: Colors.white,
        textColor: Colors.black,
        borderWidth: null,
        borderColor: null,
      ),
    );
  }
}
