/*
 * @Author: dvlproad
 * @Date: 2021-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 12:41:29
 * @Description: 页面框架
 */
library flutter_effect;

// pagetype_nodata:无数据视图组件
export './src/pagetype_nodata/empty_imageBGForText_widget.dart';
export './src/pagetype_nodata/empty_imageAboveText_widget.dart';
export './src/pagetype_nodata/nodata_widget.dart';

// pagetype_error:请求成功,但业务错误；或服务器请求失败 的错误视图
export './src/pagetype_error/state_error_widget.dart'; // 错误视图组件

// appbar
export './src/appbar/appbar.dart';

// pagetype_change
export './src/pagetype_change/pagetype_change_widget.dart';
export './src/pagetype_change/pagetype_loadstate_change_widget.dart';

// basepage_combination 组合形式
export './src/basepage_combination/pagetype_loadstate_default_widget.dart';

// basepage_extends 继承形式
export './src/basepage_extends/base_page.dart';
export './src/basepage_extends/default_page.dart';

export 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
export 'package:flutter_effect_kit/flutter_effect_kit.dart';
