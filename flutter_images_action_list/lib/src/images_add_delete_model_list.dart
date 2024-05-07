// ignore_for_file: non_constant_identifier_names
// 在不依赖model的基础list上，增加model操作的列表

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_image_process/flutter_image_process.dart';

import './images_add_delete_list.dart';

abstract class ImageAddDeleteModelList<TBean extends ImageChooseBean>
    extends StatefulWidget {
  final double width;
  final double? height;
  final EdgeInsets? padding;
  final Color? color;

  final Axis direction;
  final Axis scrollDirection;
  // NeverScrollableScrollPhysics() \ ClampingScrollPhysics()\ AlwaysScrollableScrollPhysics(),
  final ScrollPhysics? physics; // default is NeverScrollableScrollPhysics()

  final double columnSpacing;
  final double rowSpacing;
  final int cellWidthFromPerRowMaxShowCount;
  final double itemWidthHeightRatio;

  final bool dragEnable;
  final void Function(int oldIndex, int newIndex)? dragCompleteBlock;

  final List<TBean>? imageChooseModels;
  final bool showCenterIconIfVideo;

  // final Widget Function(dynamic imageChooseModel) badgeWidgetSetupBlock; // 可以返回为'删除'按钮 或者 '选中'按钮等任意

  final int maxAddCount; // 默认null,null时候默认9个

  // 视频帧
  final bool needVideoFrames;

  final Function(ImageChooseBean? bean)? onChangeCover;
  final GlobalKey? placeHolderKey;
  final List<String>? wishTags;

  const ImageAddDeleteModelList({
    Key? key,
    required this.width,
    this.height,
    this.padding,
    this.color,
    this.direction = Axis.horizontal,
    this.scrollDirection = Axis.vertical,
    this.physics,
    required this.columnSpacing, //水平列间距
    required this.rowSpacing, // 竖直行间距
    // 通过每行可显示的最多列数来设置每个cell的宽度
    required this.cellWidthFromPerRowMaxShowCount,
    // 宽高比(默认1:1,即1/1.0，请确保除数有小数点，否则1/2会变成0，而不是0.5)
    required this.itemWidthHeightRatio,
    this.dragEnable = false, // 是否可以拖动

    this.dragCompleteBlock,
    this.imageChooseModels,
    this.showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标,
    required this.maxAddCount, // 最大选择数(未设置则图片9张，视频1张，互斥)
    this.needVideoFrames = false,
    this.onChangeCover,
    this.placeHolderKey,
    this.wishTags,
  }) : super(key: key);

  // @override
  // ImageAddDeletePickListState createState() => ImageAddDeletePickListState();
}

// 重点：将 <ImageAddDeleteModelList<TBean> 抽象为 TList
abstract class ImageAddDeleteModelListState<TBean extends ImageChooseBean,
    TList extends ImageAddDeleteModelList<TBean>> extends State<TList> {
// abstract class ImageAddDeleteModelListState<TBean extends ImageChooseBean>
//     extends State<ImageAddDeleteModelList<TBean>> {
  List<TBean> _imageChooseModels = [];
  late int _maxAddCount;

  List<TBean> get imageChooseModels => _imageChooseModels;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _imageChooseModels = widget.imageChooseModels ?? [];
    _maxAddCount = widget.maxAddCount;
  }

  @override
  Widget build(BuildContext context) {
    // print("list === path111====================");
    // int count = _imageChooseModels.length ?? 0;
    // for (var i = 0; i < count; i++) {
    //   TBean item = _imageChooseModels[i];

    //   String path = item.localPath;
    //   print("list path111=$i:$path");
    // }
    return CQImagesAddDeleteList(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      color: widget.color,
      direction: widget.direction,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      columnSpacing: widget.columnSpacing,
      rowSpacing: widget.rowSpacing,
      cellWidthFromPerRowMaxShowCount: widget.cellWidthFromPerRowMaxShowCount,
      itemWidthHeightRatio: widget.itemWidthHeightRatio,
      dragEnable: widget.dragEnable,
      hideDeleteIcon: shouldHideDeleteIcon(),
      dragCompleteBlock: (int oldIndex, int newIndex) {
        if (widget.dragCompleteBlock != null) {
          widget.dragCompleteBlock!(oldIndex, newIndex);
        } else {
          TBean bean = _imageChooseModels.removeAt(oldIndex);
          _imageChooseModels.insert(newIndex, bean);

          setState(() {});
        }
      },
      maxAddCount: _maxAddCount,
      imageCount: _imageChooseModels.length,
      itemImageContentBuilder: ({
        required BuildContext context,
        required int imageIndex,
        required double itemHeight,
        required double itemWidth,
      }) {
        return imageContentWidget(context, imageIndex, itemWidth, itemHeight);
        /*
        TBean imageChooseModel = _imageChooseModels[imageIndex];
        // print("list path111=$imageIndex:${imageChooseModel.localPath}");

        String? flagText;
        if (widget.flagTextBuilder != null) {
          flagText = widget.flagTextBuilder!(
            imageChooseModel: imageChooseModel,
            imageIndex: imageIndex,
          );
        }

        return CJImageBlockGridCell(
          width: itemWidth,
          height: itemHeight,
          imageChooseModel: imageChooseModel,
          showCenterIconIfVideo: widget.showCenterIconIfVideo,
          index: imageIndex,
          flagText: flagText,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            logImageActionList('点击imageIndex=$imageIndex的图片');
            // _focusNode.unfocus();
            image_onPressed(context, _imageChooseModels, imageIndex);
          },
          networkVideoWidgetBuilder: (context) =>
              cell_networkVideoWidget(context, imageChooseModel),
          shouldRerenderCustomImageWidgetBuilder: (context) =>
              cell_shouldRerenderCustomImageWidget(context, imageChooseModel),
          renderPositionedInfoWidgetBuilder: (context) =>
              cell_renderPositionedInfoWidget(context, imageChooseModel),
          renderPositionedStatusWidgetBuilder: (context) =>
              cell_renderPositionedStatusWidget(context, imageChooseModel),
        );
        */
      },
      onPressedDelete: (imageIndex) {
        TBean imageChooseModel = _imageChooseModels[imageIndex];
        _imageChooseModels.remove(imageChooseModel);

        imageChooseModelsChange(isUpdateAction: false);
      },
      renderAddCellBuilder: () {
        return addWidgetRerender(context);
      },
      onPressedAdd: () {
        addCellOnPressed(context);
      },
    );
  }

  Widget imageContentWidget(BuildContext context, int imageIndex,
      double itemHeight, double itemWidth);

  /// 添加按钮
  Widget? addWidgetRerender(BuildContext context) {
    return null;
  }

  void addCellOnPressed(BuildContext context); // 实现时会调用到 valueChangedAfterPick

  // 是否隐藏删除按钮
  bool shouldHideDeleteIcon() {
    return false;
  }
  /*
  Widget? cell_shouldRerenderCustomImageWidget(
      BuildContext context, TBean imageChooseModel);

  Widget? cell_networkVideoWidget(BuildContext context, TBean imageChooseModel);
  
  Widget? cell_renderPositionedInfoWidget(
      BuildContext context, TBean imageChooseModel);

  Widget? cell_renderPositionedStatusWidget(
      BuildContext context, TBean imageChooseModel);

  void image_onPressed(
      BuildContext context, List<TBean> imageChooseModels, int imageIndex);
  */
  // 自定义点击图片的事件(默认是浏览)

  /*
  /// 供子类调用的方法:所选中的值有效，即可以使用(在此之前可能需要先检查是否可进行此操作，所添加的文件是否可以使用(是否太长，是否太大))
  pickedValueVailid({
    List<ImageChooseBean>? newAddedImageChooseModels,
    List<ImageChooseBean>? newCancelImageChooseModels,
    required TBean Function(ImageChooseBean item) createTInstance,
    void Function({required List<TBean> addedMeidaBeans})?
        extraThingToAddedMeidaBeans, // 其他额外需要对所添加媒体处理的事情（图片压缩、视频帧获取等）
  }) async {
    logImageActionList('PickUtil 03');

    // 新取消的图片
    if (newCancelImageChooseModels != null) {
      List<AssetEntity> shouldCancelAssetEntitys = [];
      for (var item in newCancelImageChooseModels) {
        if (item.assetEntity != null) {
          shouldCancelAssetEntitys.add(item.assetEntity!);
        }
      }

      List<TBean> shouldCancelTBeans = [];
      for (TBean item in _imageChooseModels) {
        if (item.assetEntity != null &&
            shouldCancelAssetEntitys.contains(item.assetEntity)) {
          shouldCancelTBeans.add(item);
        }
      }

      _imageChooseModels.removeWhere((element) {
        return shouldCancelTBeans.contains(element);
      });
    }

    // 新添加的图片
    if (newAddedImageChooseModels != null) {
      if (newAddedImageChooseModels.isNotEmpty) {
        List<TBean> addMeidaBeans = [];
        for (ImageChooseBean item in newAddedImageChooseModels) {
          TBean bean = createTInstance(item);
          addMeidaBeans.add(bean);
        }
        extraThingToAddedMeidaBeans?.call(addedMeidaBeans: addMeidaBeans);

        _imageChooseModels.addAll(addMeidaBeans);
      }
    }

    logImageActionList('PickUtil 04');
    imageChooseModelsChange(isUpdateAction: false);
  }

  /// 图片/视频更新自身接口(目前使用于：'更换视频'按钮的点击)
  pickMediaReplaceSelf(
    int mediaIndex, {
    required ImageChooseBean item,
    required TBean Function(ImageChooseBean item) createTInstance,
    void Function({required List<TBean> addedMeidaBeans})?
        extraThingToAddedMeidaBeans, // 其他额外需要对所添加媒体处理的事情（图片压缩、视频帧获取等）
  }) {
    TBean newBean = createTInstance(item);
    extraThingToAddedMeidaBeans?.call(addedMeidaBeans: [newBean]);

    _imageChooseModels[mediaIndex] = newBean;
    imageChooseModelsChange(isUpdateAction: true);
  }
  */

  // 当前选中的相册信息发生变化
  void imageChooseModelsChange({required bool isUpdateAction});

  /*
  Future<bool> _dealAddedImageChooseModels(
      List<TBean> addedImageChooseModels) async {
    logImageActionList('获取所选择的所有图片的宽高开始...');
    int count = addedImageChooseModels.length;

    List<Future<Map<String, dynamic>>> futures = [];
    for (var i = 0; i < count; i++) {
      TBean addedImageChooseModel = addedImageChooseModels[i];

      Image image;
      if (addedImageChooseModel.mediaType == UploadMediaType.image) {
        if (addedImageChooseModel.networkUrl != null) {
          String imageUrl = addedImageChooseModel.networkUrl;
          image = Image.network(imageUrl);
          debugPrint(
              '$imageUrl 图片的宽高如下:\nimageWidth111=${image.width}, imageHeight=${image.height}');
        } else {
          String imageFileLocalPath = addedImageChooseModel.assetEntityPath;
          image = Image.file(File(imageFileLocalPath));
          debugPrint(
              '$imageFileLocalPath 图片的宽高如下:\nimageWidth111=${image.width}, imageHeight=${image.height}');
        }
      } else if (addedImageChooseModel.mediaType == UploadMediaType.image) {
        //
      }

      ImageProvider imageProvider = image.image;

      Future future = getWidthAndHeight(imageProvider);
      futures.add(future);
    }
    
    // 串行
    // Map<String, dynamic> imageWidthHeight =
    //     await getWidthAndHeight(imageProvider);
    // int imageWidth = imageWidthHeight['width'];
    // int imageHeight = imageWidthHeight['height'];
    // debugPrint(
    //     '$imageFileLocalPath 图片的宽高如下:\nimageWidth222=$imageWidth, imageHeight=$imageHeight');

    // addedImageChooseModel.width = imageWidth;
    // addedImageChooseModel.height = imageHeight;

    // 并发
    return Future.wait(futures).then((List<Map<String, dynamic>> results) {
      for (var i = 0; i < count; i++) {
        TBean addedImageChooseModel = addedImageChooseModels[i];
        String imageFileLocalPath = addedImageChooseModel.assetEntityPath;

        Map<String, dynamic> imageWidthHeight = results[i];
        int imageWidth = imageWidthHeight['width'];
        int imageHeight = imageWidthHeight['height'];
        debugPrint(
            '$imageFileLocalPath 图片的宽高如下:\nimageWidth222=$imageWidth, imageHeight=$imageHeight');

        addedImageChooseModel.width = imageWidth;
        addedImageChooseModel.height = imageHeight;
      }

      logImageActionList('获取所选择的所有图片的宽高结束...');

      return true;
    });
  }
  

  Future<Map<String, dynamic>> getWidthAndHeight(
      ImageProvider<Object> imageProvider) async {
    Completer<Map<String, dynamic>> completer = Completer();

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          int imageWidth = info.image.width;
          int imageHeight = info.image.height;
          logImageActionList('imageWidth=$imageWidth, imageHeight=$imageHeight');

          Map<String, dynamic> imageWithHeight = {
            "width": imageWidth,
            "height": imageHeight,
          };
          completer.complete(imageWithHeight);
        },
      ),
    );

    return completer.future;
  }
  */
  logImageActionList(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
