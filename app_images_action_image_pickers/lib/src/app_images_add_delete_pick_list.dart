import 'dart:io' show Directory, File;
import 'dart:async';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_player_ui/flutter_player_ui.dart';
import 'package:flutter_image_process/flutter_image_process.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;

import './widget/image_or_photo_grid_cell.dart';

import './images_add_cell.dart';
export './images_add_cell.dart' show AddCellType;

import './preview/preview_util.dart';

import 'package:app_network/app_network.dart'
    show AppNetworkManager, UploadApiUtil, UploadMediaResultType;

import './images_add_delete_pick_list.dart';

import './widget/image_choose_bean_view.dart';
import './media_upload_util.dart';

class AppImageAddDeletePickList extends StatefulWidget {
  final double width;
  final double? height;
  final Color? color;
  final bool dragEnable;
  final void Function(int oldIndex, int newIndex)? dragCompleteBlock;

  final ImageChooseBean? coverImageChooseModel; // 封面
  final List<AppImageChooseBean>? imageChooseModels;

  // final Widget Function(dynamic imageChooseModel) badgeWidgetSetupBlock; // 可以返回为'删除'按钮 或者 '选中'按钮等任意
  final void Function(
    List<AppImageChooseBean> imageChooseModels,
    ImageChooseBean? coverImageChooseModel,
  ) mediasOrCoverChangeBlock; // 图片、视频、封面变化
  final void Function(
          List<AppImageChooseBean> imageChooseModels, int imageIndex)?
      onPressedImage;

  final AddCellType addCellType;

  final PickPhotoAllowType Function(
      List<AppImageChooseBean> currentImageChooseModels)? pickAllowTypeGetBlock;
  final int Function(PickPhotoAllowType pickPhotoAllowType)?
      maxAddCountGetBlock;

  // 视频帧
  final bool needVideoFrames;

  // 下载视频回调
  final Future<AppImageChooseBean?> Function(AppImageChooseBean chooseBean)?
      downloadVideoBlock;

  AppImageAddDeletePickList({
    Key? key,
    required this.width,
    this.height,
    this.color,
    this.dragEnable = false, // 是否可以拖动
    this.dragCompleteBlock,
    this.imageChooseModels,
    this.coverImageChooseModel,
    required this.mediasOrCoverChangeBlock,
    this.onPressedImage, // 自定义点击图片的事件(默认是浏览)
    this.addCellType = AddCellType.defalut_add,
    this.pickAllowTypeGetBlock,
    this.maxAddCountGetBlock, // 最大选择数(未设置则图片9张，视频1张，互斥)
    this.needVideoFrames = false,
    this.downloadVideoBlock,
  }) : super(key: key);

  @override
  AppImageAddDeletePickListState createState() =>
      AppImageAddDeletePickListState();
}

class AppImageAddDeletePickListState extends State<AppImageAddDeletePickList> {
  ImageChooseBean? _coverImageChooseModel; // 封面
  List<AppImageChooseBean> _imageChooseModels = [];
  int _maxAddCount = 9;

  GlobalKey<ImageAddDeletePickListState> imagesChooseViewKey = GlobalKey();

  ImageChooseBean? get coverImageChooseModel => _coverImageChooseModel;

  List<AppImageChooseBean> get imageChooseModels => _imageChooseModels;

  PickPhotoAllowType get pickAllowType => _pickAllowType;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _coverImageChooseModel = widget.coverImageChooseModel;
    _imageChooseModels = widget.imageChooseModels ?? [];
  }

  PickPhotoAllowType get _pickAllowType {
    if (imagesChooseViewKey.currentState != null) {
      return imagesChooseViewKey.currentState!.pickAllowType;
    } else {
      return PickPhotoAllowType.imageOnly;
    }
  }

  /// 更新封面并回调给外层
  _updateCoverImageChooseModel(ImageChooseBean? coverBean) {
    _coverImageChooseModel = coverBean;
    setState(() {});
    widget.mediasOrCoverChangeBlock(
      _imageChooseModels,
      _coverImageChooseModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ImageAddDeletePickList(
            key: imagesChooseViewKey,
            needVideoFrames: widget.needVideoFrames,
            width: widget.width,
            height: widget.height,
            color: widget.color,
            direction: Axis.horizontal,
            scrollDirection: Axis.vertical,
            // NeverScrollableScrollPhysics() \ ClampingScrollPhysics()\ AlwaysScrollableScrollPhysics(),
            physics: NeverScrollableScrollPhysics(),
            dragEnable: true,
            hideDeleteIconGetBlock: (PickPhotoAllowType pickAllowType) {
              return pickAllowType == PickPhotoAllowType.videoOnly
                  ? true
                  : false;
            },
            addCellType: AddCellType.image_only_default,
            imageChooseModels: _imageChooseModels,
            showCenterIconIfVideo: false,
            onChangeCover: (ImageChooseBean? bean) {
              _updateCoverImageChooseModel(bean);
            },
            customImageWidgetGetBlock: ({
              required ImageChooseBean imageChooseModel,
              double? width,
              double? height,
            }) {
              // 视频的情况，如果有缩略图，优先显示缩略图，因为封面允许改变
              if (imageChooseModel.mediaType == UploadMediaType.video &&
                  _coverImageChooseModel != null) {
                return ImageChooseBeanView.getImageWidget(
                  context: context,
                  imageChooseModel: _coverImageChooseModel!,
                  width: width,
                  height: height,
                  showCenterIconIfVideo: false,
                );
              } else {
                return null;
              }
            },
            flagTextBuilder: ({
              required AppImageChooseBean imageChooseModel,
              required int imageIndex,
            }) {
              if (imageChooseModel.mediaType == UploadMediaType.image &&
                  imageIndex == 0) {
                return '封面';
              }
              return null;
            },
            onPressedImage:
                (List<AppImageChooseBean> imageChooseModels, int imageIndex) {
              if (_pickAllowType == PickPhotoAllowType.videoOnly) {
                previewVideoThumnailImage();
              } else {
                if (imagesChooseViewKey.currentState != null) {
                  imagesChooseViewKey.currentState!
                      .preview(imageIndex: imageIndex);
                }
              }
            },
            imageChooseModelsChangeBlock: (
              List<AppImageChooseBean> imageOrPhotoModels,
              PickPhotoAllowType bNewPickPhotoAllowType,
            ) {
              _imageChooseModels = imageOrPhotoModels;
              setState(() {
                // 用于更新 mediaButtons
              });
              if (_imageChooseModels.isEmpty) {
                _coverImageChooseModel = null;
              }
              widget.mediasOrCoverChangeBlock(
                _imageChooseModels,
                _coverImageChooseModel,
              );
            },
          ),
          _mediaButtons(context),
        ],
      ),
    );
  }

  /// 清空图片和视频，供外部使用
  clear() {
    if (imagesChooseViewKey.currentState != null) {
      imagesChooseViewKey.currentState!.clear();
      _imageChooseModels = imagesChooseViewKey.currentState!.imageChooseModels;
    }
    // setState(() {
    //   // 用于更新 mediaButtons
    // });
  }

  updateMediasAndCover(
    List<AppImageChooseBean>? imageChooseModels,
    ImageChooseBean? coverImageChooseModel,
  ) {
    if (imagesChooseViewKey.currentState != null) {
      imagesChooseViewKey.currentState!.updateMedias(imageChooseModels);

      _imageChooseModels = imagesChooseViewKey.currentState!.imageChooseModels;
      setState(() {
        _coverImageChooseModel = coverImageChooseModel;
      });
    }
    // setState(() {
    //   // 用于更新 mediaButtons
    // });
  }

  previewVideoThumnailImage() {
    FocusScope.of(context).requestFocus(FocusNode());
    // _focusNode.unfocus();

    if (_pickAllowType != PickPhotoAllowType.videoOnly) {
      return;
    }

    if (_imageChooseModels.isEmpty) {
      return;
    }

    if (_coverImageChooseModel != null) {
      PreviewUtil.preview(
        context,
        imageChooseModels: [_coverImageChooseModel!],
        imageIndex: 0,
      );
      return;
    }

    AppImageChooseBean mediaChooseBean = _imageChooseModels[0];
    if (mediaChooseBean.compressImageBean == null ||
        mediaChooseBean.compressImageBean!.compressPath == null) {
      return;
    }

    String videoThumnailImagePath =
        mediaChooseBean.compressImageBean!.compressPath!;
    ImageCompressBean compressImageBean = ImageCompressBean(
      originPathOrUrl: videoThumnailImagePath,
      compressPath: videoThumnailImagePath,
      compressInfoProcess: CompressInfoProcess.finishAll,
    );

    ImageChooseBean imageChooseBean = ImageChooseBean();
    imageChooseBean.compressImageBean = compressImageBean;

    PreviewUtil.preview(
      context,
      imageChooseModels: [imageChooseBean],
      imageIndex: 0,
    );
  }

  Future<void> updateCoverImage() async {
    var videoModel = _imageChooseModels.first;
    print('videoModel: ${coverImageChooseModel?.toJson()}');
    if (videoModel.assetEntity == null &&
        videoModel.compressVideoBean == null) {
      debugPrint('没有找到视频，从网络下载:${videoModel.networkUrl}');
      if (widget.downloadVideoBlock == null) return;
      if (videoModel.networkUrl!.contains(".m3u8")) {
        ToastUtil.showMessage("不支持m3u8格式视频");
        return;
      }
      var downloadVideoModel = await widget.downloadVideoBlock!(videoModel);
      // 用户取消了下载
      if (downloadVideoModel == null) return;
      videoModel = downloadVideoModel;
      _pushChooseFramePage();
      return;
    } else {
      _pushChooseFramePage();
    }
  }

  void _pushChooseFramePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ChooseFramePage(
          customChooseCover: _coverImageChooseModel,
          video: _imageChooseModels.first,
          onSubmit: (ImageChooseBean? imageChooseBean) {
            if (imageChooseBean != null) {
              _updateCoverImageChooseModel(imageChooseBean);
              ImageCompressUtil.compressMediaBeans(
                  [imageChooseBean]); // 异步压缩所添加的文件
            }
          },
        ),
      ),
    );
  }

  Widget _mediaButtons(BuildContext context) {
    if (imagesChooseViewKey.currentState == null) {
      return Container();
    }

    PickPhotoAllowType pickAllowType =
        imagesChooseViewKey.currentState!.pickAllowType;
    if (pickAllowType != PickPhotoAllowType.videoOnly) {
      return Container();
    }

    return Container(
      height: 60.h_pt_cj,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _mediaButton(
            context,
            buttonImageName: 'assets/icon_video_self_preview.png',
            buttonText: '预览视频',
            onTap: () {
              print('点击预览视频');
              if (imagesChooseViewKey.currentState != null) {
                imagesChooseViewKey.currentState!.preview(imageIndex: 0);
              }
            },
          ),
          Container(width: 10.w_pt_cj),
          _mediaButton(
            context,
            buttonImageName: 'assets/icon_video_thumbnail_update.png',
            buttonText: '修改封面',
            onTap: () {
              print('点击修改封面');
              updateCoverImage();
            },
          ),
          Container(width: 10.w_pt_cj),
          _mediaButton(
            context,
            buttonImageName: 'assets/icon_video_self_update.png',
            buttonText: '更换视频',
            onTap: () {
              print('点击更换视频');
              if (imagesChooseViewKey.currentState != null) {
                imagesChooseViewKey.currentState!.updateMediaSelf(
                  0,
                  pickAllowType: PickPhotoAllowType.imageOrVideo,
                  updateCompleteBlock: () {
                    _updateCoverImageChooseModel(null); // 确认是更换视频后，上次封面才删除
                  },
                );
              }
            },
          ),
          /*
          Container(width: 10.w_pt_cj),
          _isDebug()
              ? _mediaButton(
                  context,
                  buttonImageName: 'assets/icon_video_self_update.png',
                  buttonText: '视频帧列表',
                  onTap: () {
                    AppImageChooseBean imageChooseModel = _imageChooseModels[0];
                    List<ImageCompressBean>? videoFrameBeans =
                        imageChooseModel.videoFrameBeans;
                    if (imageChooseModel.isGettingVideoFrames == true) {
                      ToastUtil.showMessage('正在获取视频帧列表中...');
                    }
                    if (videoFrameBeans == null) {
                      _log('视频帧获取失败');
                      return;
                    }

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        List<AppImageChooseBean> imageChooseModels = [];
                        for (var videoFrameBean in videoFrameBeans) {
                          AppImageChooseBean imageChooseModel =
                              AppImageChooseBean();
                          imageChooseModel.compressImageBean = videoFrameBean;
                          imageChooseModels.add(imageChooseModel);
                        }
                        return TSImagesPage(
                            imageChooseModels: imageChooseModels);
                      },
                    ));
                  },
                )
              : Container(),
          */
        ],
      ),
    );
    return Container(
      color: Colors.red,
      height: 50.h_pt_cj,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return LeftImageButton(
            width: 65.w_pt_cj,
            height: 50.h_pt_cj,
            buttonText: '预览视频',
            buttonImageView: Image(
              image: AssetImage('images/goods_detail/bg.png'),
              fit: BoxFit.cover,
            ),
            onTap: () {
              print('点击$index');
            },
          );
        },
        itemCount: 3,
      ),
    );
  }

  /// 判断是否为Debug模式
  bool _isDebug() {
    bool inDebug = false;
    assert(inDebug =
        true); // 根据模式的介绍，可以知道Release模式关闭了所有的断言，assert的代码在打包时不会打包到二进制包中。因此我们可以借助断言，写出只在Debug模式下生效的代码
    return inDebug;
  }

  Widget _mediaButton(
    BuildContext context, {
    required String buttonImageName,
    required String buttonText,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65.w_pt_cj,
        height: 18.h_pt_cj,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.all(Radius.circular(4.w_pt_cj)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 12,
              height: 12,
              image: AssetImage(
                buttonImageName,
                package: 'app_images_action_image_pickers',
              ),
              fit: BoxFit.cover,
            ),
            Container(width: 2.w_pt_cj),
            Text(
              buttonText,
              style: RegularTextStyle(
                fontSize: 10.h_pt_cj,
                color: const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
    return LeftImageButton(
      width: 65.w_pt_cj,
      height: 50.h_pt_cj,
      buttonText: buttonText,
      buttonImageView: Image(
        image: AssetImage(buttonImageName),
        fit: BoxFit.cover,
      ),
      onTap: onTap,
    );
  }

  _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
