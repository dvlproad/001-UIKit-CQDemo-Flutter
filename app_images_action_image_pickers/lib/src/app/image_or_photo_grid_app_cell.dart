// ignore_for_file: unnecessary_brace_in_string_interps

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-29 15:04:39
 * @Description: 图片选择器的单元视图
 */
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_player_ui/flutter_player_ui.dart';

import './app_image_choose_bean.dart';

class PositionedImageChooseStatus {
  static const String success = 'success';
  static const String fail = 'fail';
}

class CQImageGridCell<TFromApp extends AppImageChooseBean>
    extends CJImageExtendsGridCell {
  final Widget? Function({
    required TFromApp imageChooseModel,
    double? width,
    double? height,
  })? customImageWidgetGetBlock;

  CQImageOrPhotoGridCell({
    Key? key,
    double? width,
    double? height,
    double? cornerRadius,
    required TFromApp imageChooseModel,
    bool showCenterIconIfVideo = true,
    this.customImageWidgetGetBlock,
    required int index,
    String? flagText,
    required VoidCallback onPressed,
  }) : super(
          key: key, width: width,
          height: height,
          cornerRadius: cornerRadius,
          imageChooseModel: imageChooseModel, // 类型可为 AssetEntity 或 String
          showCenterIconIfVideo: showCenterIconIfVideo =
              true, // 是视频文件的时候是否在中间显示icon播放图标
          index: index,
          flagText: flagText,
          onPressed: onPressed,
        );

  @override
  Widget? shouldRerenderNetworkVideoWidget(BuildContext context) {
    String imageUrl = imageChooseModel.networkUrl!;
    return NetworkVideoWidget(
      networkUrl: imageUrl,
      showCenterIcon: showCenterIconIfVideo,
    );
  }

  @override
  Widget? shouldRerenderCustomImageWidget(BuildContext context) {
    Widget? view = customImageWidgetGetBlock?.call(
      imageChooseModel: imageChooseModel as TFromApp,
      width: width,
      height: height,
    );

    return view;
  }

  @override
  Widget? renderPositionedInfoWidget(BuildContext context) {
    return PositionedImageChooseText(flagText: flagText);
  }

  /*
  @override
  Widget? renderPositionedStatusWidget(BuildContext context) {
    return PositionedImageChooseStatusWidget(
      imageProvider: null,
      flagText: "flagText2",
      onPressed: () {
        //
      },
    );
  }
  */
}
