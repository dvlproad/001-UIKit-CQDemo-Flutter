// ignore_for_file: non_constant_identifier_names
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';

import './app/app_image_choose_bean.dart';
import 'app/image_or_photo_grid_app_cell.dart';
import 'images_picker_model_base_util.dart';

class NormalImageAddDeletePickList
    extends ImageAddDeleteModelList<AppImageChooseBean> {
  final void Function(List<AppImageChooseBean> imageChooseModels)
      imageChooseModelsChangeBlock;
  final PickPhotoAllowType Function(
      List<AppImageChooseBean> currentImageChooseModels)? pickAllowTypeGetBlock;

  final String? Function(
      {required AppImageChooseBean imageChooseModel,
      required int imageIndex})? flagTextBuilder;

  final void Function(
          List<AppImageChooseBean> imageChooseModels, int imageIndex)?
      onPressedImage;
  final List<String>? wishTags;

  final Widget? Function({
    required ImageChooseBean imageChooseModel,
    double? width,
    double? height,
  })? customImageWidgetGetBlock;

  NormalImageAddDeletePickList({
    Key? key,
    required double width,
    double? height,
    EdgeInsets? padding,
    Color? color,
    Axis direction = Axis.horizontal,
    Axis scrollDirection = Axis.vertical,
    ScrollPhysics? physics,
    bool dragEnable = false, // 是否可以拖动
    void Function(int oldIndex, int newIndex)? dragCompleteBlock,
    List<AppImageChooseBean>? imageChooseModels,
    bool showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标,
    this.customImageWidgetGetBlock,
    required this.imageChooseModelsChangeBlock, // 当前选中的相册信
    this.onPressedImage,
    AddCellType addCellType = AddCellType.defalut_add,
    // int Function(PickPhotoAllowType pickPhotoAllowType)? maxAddCountGetBlock,
    this.flagTextBuilder,
    this.pickAllowTypeGetBlock,
    bool needVideoFrames = false,
    Function(ImageChooseBean? bean)? onChangeCover,
    GlobalKey? placeHolderKey,
    this.wishTags,
  }) : super(
          key: key,
          width: width,
          height: height,
          padding: padding,
          color: color,
          direction: direction,
          scrollDirection: scrollDirection,
          physics: physics,
          dragEnable: dragEnable,
          dragCompleteBlock: dragCompleteBlock,
          imageChooseModels: imageChooseModels,
          showCenterIconIfVideo: showCenterIconIfVideo,
          maxAddCount: 9,
          needVideoFrames: needVideoFrames,
          onChangeCover: onChangeCover,
          placeHolderKey: placeHolderKey,
        ) {
    //
  }

  @override
  NormalImageAddDeletePickListState createState() =>
      NormalImageAddDeletePickListState();
}

class NormalImageAddDeletePickListState extends ImageAddDeleteModelListState<
    AppImageChooseBean, NormalImageAddDeletePickList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget imageContentWidget(
    BuildContext context,
    int imageIndex,
    double itemHeight,
    double itemWidth,
  ) {
    AppImageChooseBean imageChooseModel = imageChooseModels[imageIndex];

    String? flagText;
    if (widget.flagTextBuilder != null) {
      flagText = widget.flagTextBuilder!(
        imageChooseModel: imageChooseModel,
        imageIndex: imageIndex,
      );
    }

    return CQImageOrPhotoGridCell(
      width: itemWidth,
      height: itemHeight,
      imageChooseModel: imageChooseModel,
      showCenterIconIfVideo: widget.showCenterIconIfVideo,
      customImageWidgetGetBlock: widget.customImageWidgetGetBlock,
      index: imageIndex,
      flagText: flagText,
      onPressed: () {
        _imageCellOnPressed(imageIndex);
      },
    );
  }

  // 是否隐藏删除按钮
  @override
  bool shouldHideDeleteIcon() {
    PickPhotoAllowType pickAllowType =
        AppPickModelUtil.pickAllowTypeByImageChooseModels(imageChooseModels);
    if (pickAllowType == PickPhotoAllowType.videoOnly) {
      return true;
    }
    return false;
  }

  @override
  void imageChooseModelsChange({required bool isUpdateAction}) {
    logImageActionList('PickUtil 05}');
    widget.imageChooseModelsChangeBlock(imageChooseModels);
    logImageActionList('PickUtil 06');
    setState(() {});
  }

  @override
  void addCellOnPressed(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    dealAvatar(0);
    // ActionSheetUtil.chooseItem(
    //   context,
    //   title: '选择图片',
    //   itemTitles: ['拍照上传', '从相册选择'],
    //   onConfirm: (int selectedIndex) {
    //     dealAvatar(selectedIndex);
    //   },
    // );
  }

  void dealAvatar(int selectedIndex) async {
    // if (selectedIndex == 0) {
    //   PhotoTakeUtil.takePhoto(
    //     imagePickerCallBack: (path) {
    //       _imageChooseModels.add(path);

    //       if (widget.imageOrPhotoModelsChangeBlock != null) {
    //         // print('当前最新的图片数目为${_imageChooseModels.length}');
    //         widget.imageOrPhotoModelsChangeBlock(_imageChooseModels);
    //       }
    //     },
    //   );
    // } else {
    AppPickModelUtil.addMedia(
      context,
      imageChooseModels,
      createTInstance: createTInstance,
      completeBlock: (newCurImageChooseModels) {
        imageChooseModelsChange(isUpdateAction: false);
      },
    );
    // }
  }

  void _imageCellOnPressed(int imageIndex) {
    FocusScope.of(context).requestFocus(FocusNode());
    logImageActionList('点击imageIndex=$imageIndex的图片');
    // _focusNode.unfocus();

    if (widget.onPressedImage != null) {
      widget.onPressedImage!(imageChooseModels, imageIndex);
    } else {
      PreviewUtil.preview(
        context,
        imageChooseModels: imageChooseModels,
        imageIndex: imageIndex,
      );
    }
  }

  AppImageChooseBean createTInstance(ImageChooseBean item) {
    AppImageChooseBean bean = AppImageChooseBean(
      assetEntity: item.assetEntity,
      networkUrl: item.networkUrl,
      width: item.width,
      height: item.height,
    );
    return bean;
  }

  logImageActionList(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
