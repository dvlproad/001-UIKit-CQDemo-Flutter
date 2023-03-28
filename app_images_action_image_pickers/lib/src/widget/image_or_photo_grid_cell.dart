// ignore_for_file: unnecessary_brace_in_string_interps

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 10:26:04
 * @Description: 图片选择器的单元视图
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_images_action_list/flutter_images_action_list.dart'
    show CQImageBaseGridCell;
// import 'package:image_pickers/image_pickers.dart';

import 'package:flutter_image_process/flutter_image_process.dart';

import './image_choose_bean_view.dart';

class CQImageOrPhotoGridCell extends StatelessWidget {
  final double? width;
  final double? height;
  final double? cornerRadius;
  final ImageChooseBean imageChooseModel;
  final bool showCenterIconIfVideo;

  final Widget? Function({
    required ImageChooseBean imageChooseModel,
    double? width,
    double? height,
  })? customImageWidgetGetBlock;

  final int index;
  final String? flagText;
  final VoidCallback onPressed;

  CQImageOrPhotoGridCell({
    Key? key,
    this.width,
    this.height,
    this.cornerRadius,
    required this.imageChooseModel, // 类型可为 AssetEntity 或 String
    this.showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
    this.customImageWidgetGetBlock, // 需要对这个model自定义的情况
    required this.index,
    this.flagText,
    required this.onPressed,
  }) : super(key: key);

  String? _lastNetworImagekUrl;
  Widget _getCustomImageWidget(BuildContext context) {
    if (this.customImageWidgetGetBlock != null) {
      Widget? view = this.customImageWidgetGetBlock!(
        imageChooseModel: imageChooseModel,
        width: width,
        height: height,
      );
      if (view != null) {
        return view;
      }
    }

    return ImageChooseBeanView.getImageWidget(
      context: context,
      imageChooseModel: imageChooseModel,
      width: width,
      height: height,
      showCenterIconIfVideo: showCenterIconIfVideo,
      lastImageUrlGetBlock: (String lastImageUrl) {
        _lastNetworImagekUrl = lastImageUrl;
      },
    );
  }

  LinearGradient get imageCellTextGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xff404040).withOpacity(0.0),
        const Color(0xff404040).withOpacity(1.0),
      ],
    );
  }

  Widget _getLastCustomImageWidget(BuildContext context) {
    // bool showFlagView = flagText != null && flagText!.isNotEmpty;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Stack(
          children: [
            _getCustomImageWidget(context),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Visibility(
                visible: flagText != null && flagText!.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: imageCellTextGradient,
                        // borderRadius: BorderRadius.only(
                        //   bottomLeft: Radius.circular(4.w_bj),
                        //   bottomRight: Radius.circular(4.w_bj),
                        // ),
                      ),
                      width: constraints.maxWidth,
                      child: ThemeBGButton(
                        width: 50,
                        height: 20,
                        cornerRadius: 10,
                        // bgColorType: ThemeBGType.theme,
                        bgColor: Colors.transparent,
                        textColor: Colors.white,
                        title: flagText ?? '',
                        titleStyle: RegularTextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget customImageWidget = _getLastCustomImageWidget(context);

    return CQImageBaseGridCell(
      width: width,
      height: height,
      cornerRadius: cornerRadius ?? 8,
      customImageWidget: customImageWidget,
      message: '',
      index: index,
      onTap: onPressed,
      onDoubleTap: () async {
        // 以下代码纯测试，实际生产中没用
        List<String> pathOrUrls = [];

        String? assetEntityFilePath;
        if (imageChooseModel.assetEntity != null) {
          /// 危险！！！！获取相册的文件流，此方法会产生极大的内存开销，请勿连续调用比如在for中
          File? file = await AssetEntityInfoGetter.getAssetEntityFile(
              imageChooseModel.assetEntity!);
          if (file != null) {
            assetEntityFilePath = file.path;
            pathOrUrls.add('本地路径:${assetEntityFilePath}');
          }
        }

        if (_lastNetworImagekUrl != null) {
          pathOrUrls.add('网络路径:${_lastNetworImagekUrl}');
        }

        String? compressPath;
        if (imageChooseModel.compressImageBean != null) {
          compressPath = imageChooseModel.compressImageBean!.compressPath;
          if (compressPath != null) {
            pathOrUrls.add('压缩路径:${compressPath}');
          }
        }

        String pathOrUrlString = pathOrUrls.join('\n');
        Clipboard.setData(ClipboardData(text: pathOrUrlString));
      },
    );

    // if (imageChooseModel is Media) {
    //   Media media = imageChooseModel;

    //   Image image = Image.file(
    //     File(media.thumbPath),
    //     width: 90,
    //     height: 90,
    //     fit: BoxFit.cover,
    //   );
    //   ImageProvider imageProvider = image.image;

    //   return GestureDetector(
    //     onTap: onPressed,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(8),
    //       child: image,
    //     ),
    //   );
    // }
  }
}
