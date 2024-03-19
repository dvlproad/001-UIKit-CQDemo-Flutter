// ignore_for_file: sized_box_for_whitespace, must_be_immutable

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-19 10:35:23
 * @Description: 图片选择器的单元视图
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_process/flutter_image_process.dart';
import './image_choose_bean_base_view.dart';

class CJImageBlockGridCell<TFromApp extends ImageChooseBean>
    extends CJImageExtendsGridCell {
  Widget? Function(BuildContext context)? networkVideoWidgetBuilder;
  Widget? Function(BuildContext context)?
      shouldRerenderCustomImageWidgetBuilder;
  Widget? Function(BuildContext context)? renderPositionedInfoWidgetBuilder;
  Widget? Function(BuildContext context)? renderPositionedStatusWidgetBuilder;

  CJImageBlockGridCell({
    Key? key,
    double? width,
    double? height,
    double? cornerRadius,
    required TFromApp imageChooseModel,
    bool showCenterIconIfVideo = true,
    required int index,
    String? flagText,
    required VoidCallback onPressed,
    this.networkVideoWidgetBuilder,
    this.shouldRerenderCustomImageWidgetBuilder,
    this.renderPositionedInfoWidgetBuilder,
    this.renderPositionedStatusWidgetBuilder,
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
    return networkVideoWidgetBuilder?.call(context);
  }

  @override
  Widget? shouldRerenderCustomImageWidget(BuildContext context) {
    return shouldRerenderCustomImageWidgetBuilder?.call(context);
  }

  @override
  Widget? renderPositionedInfoWidget(BuildContext context) {
    return renderPositionedInfoWidgetBuilder?.call(context);
  }

  @override
  Widget? renderPositionedStatusWidget(BuildContext context) {
    return renderPositionedStatusWidgetBuilder?.call(context);
  }
}

abstract class CJImageExtendsGridCell<T extends ImageChooseBean>
    extends StatelessWidget {
  final double? width;
  final double? height;
  final double? cornerRadius;
  final T imageChooseModel;
  final bool showCenterIconIfVideo;

  final int index;
  final String? flagText;
  final GestureTapCallback onPressed;
  final GestureLongPressCallback? onLongPress;

  CJImageExtendsGridCell({
    Key? key,
    this.width,
    this.height,
    this.cornerRadius,
    required this.imageChooseModel, // 类型可为 AssetEntity 或 String
    this.showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
    required this.index,
    this.flagText,
    required this.onPressed,
    this.onLongPress,
  }) : super(key: key);

  // 等待子类实现的方法：
  Widget? shouldRerenderNetworkVideoWidget(BuildContext context) {
    return null;
  }

  // 等待子类实现的方法：重写图片视图的绘制（返回空，则会自动使用默认的方式绘制，而不是真的空）
  Widget? shouldRerenderCustomImageWidget(BuildContext context) {
    return null;
  }

  // 子类可重写的方法：图片的其他信息（文本如封面等）
  Widget? renderPositionedInfoWidget(BuildContext context) {
    return null;
  }

  // 子类可重写的方法：图片的状态视图（加载中、加载失败、审核等）
  Widget? renderPositionedStatusWidget(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget? positionedInfoWidget = renderPositionedInfoWidget(context);
    Widget? positionedStatusWidget = renderPositionedStatusWidget(context);

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(this.cornerRadius ?? 0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        onDoubleTap: () {
          _copyImagePathOrUrl();
        },
        onLongPress: onLongPress,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: width ?? constraints.maxWidth,
            height: height ?? constraints.maxHeight,
            // decoration: BoxDecoration(
            //   color: Colors.red,
            // ),
            child: Stack(
              children: [
                // 图片本身信息
                _getCustomImageWidget(context),
                // 图片的其他信息
                if (positionedInfoWidget != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: positionedInfoWidget,
                  ),
                // 图片的状态信息
                if (positionedStatusWidget != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: positionedStatusWidget,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // 1、图片
  String? _lastNetworImagekUrl;
  Widget _getCustomImageWidget(BuildContext context) {
    Widget? view = shouldRerenderCustomImageWidget(context);
    if (view != null) {
      return view;
    }

    return ImageChooseBeanBaseView(
      imageChooseModel: imageChooseModel,
      width: width,
      height: height,
      showCenterIconIfVideo: showCenterIconIfVideo,
      networkVideoWidgetBuilder: (context) {
        Widget? networkVideoView = shouldRerenderNetworkVideoWidget(context);
        if (networkVideoView != null) {
          return networkVideoView;
        }
        return Container(
          color: Colors.red,
          child: const Text(
            "提示:此为视频文件，但未绘制图片信息，请实现 networkVideoWidget ",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        );
      },
      lastImageUrlGetBlock: (String lastImageUrl) {
        _lastNetworImagekUrl = lastImageUrl;
      },
    );
  }

  /// 测试的方法
  void _copyImagePathOrUrl() async {
    // 以下代码纯测试，实际生产中没用
    List<String> pathOrUrls = [];

    String? assetEntityFilePath;
    if (imageChooseModel.assetEntity != null) {
      /// 危险！！！！获取相册的文件流，此方法会产生极大的内存开销，请勿连续调用比如在for中
      File? file = await AssetEntityInfoGetter.getAssetEntityFile(
          imageChooseModel.assetEntity!);
      if (file != null) {
        assetEntityFilePath = file.path;
        pathOrUrls.add('本地路径:$assetEntityFilePath');
      }
    }

    if (_lastNetworImagekUrl != null) {
      pathOrUrls.add('网络路径:$_lastNetworImagekUrl');
    }

    String? compressPath = await imageChooseModel.lastUploadImagePath();
    if (compressPath != null) {
      pathOrUrls.add('压缩路径:$compressPath');
    }

    String pathOrUrlString = pathOrUrls.join('\n');
    Clipboard.setData(ClipboardData(text: pathOrUrlString));
  }
}
