import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './image_or_photo_grid_cell.dart';

class CQImagesPreSufBadgeList extends StatefulWidget {
  final List<dynamic> imageOrPhotoModels;
  final int maxAddCount;
  final Widget prefixWidget;
  final Widget suffixWidget;
  final Widget Function(dynamic imageOrPhotoModel) badgeWidgetSetupBlock;

  CQImagesPreSufBadgeList({
    Key key,
    @required this.imageOrPhotoModels,
    this.maxAddCount = 100000,
    this.prefixWidget, // 可以为'添加'按钮
    this.suffixWidget, // 可以为'添加'按钮
    this.badgeWidgetSetupBlock, // 可以返回为'删除'按钮 或者 '选中'按钮等任意
  }) : super(key: key);

  @override
  _CQImagesPreSufBadgeListState createState() =>
      _CQImagesPreSufBadgeListState();
}

class _CQImagesPreSufBadgeListState extends State<CQImagesPreSufBadgeList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxShowCount = widget.maxAddCount;
    bool allowAddPrefixWidget = false;
    bool allowAddSuffixWidget = false;

    List<dynamic> _imageOrPhotoModels = widget.imageOrPhotoModels ?? [];
    if (_imageOrPhotoModels.length > maxShowCount) {
      _imageOrPhotoModels = _imageOrPhotoModels.sublist(0, widget.maxAddCount);
    }

    int itemCount = _imageOrPhotoModels.length;
    if (widget.prefixWidget != null && itemCount < maxShowCount) {
      allowAddPrefixWidget = true;
      itemCount++;
    }
    if (widget.suffixWidget != null && itemCount < maxShowCount) {
      allowAddSuffixWidget = true;
      itemCount++;
    }

    return Container(
      color: Colors.transparent,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        padding: EdgeInsets.fromLTRB(10, 10, 80, 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          if (allowAddPrefixWidget == true && index == 0) {
            return widget.prefixWidget;
          }
          if (allowAddSuffixWidget == true && index == itemCount - 1) {
            return widget.suffixWidget;
          }

          int imageOrPhotoModelIndex = index;
          if (allowAddPrefixWidget == true) {
            imageOrPhotoModelIndex = index - 1;
          }

          dynamic imageOrPhotoModel =
              _imageOrPhotoModels[imageOrPhotoModelIndex];
          return _photoAlbumGridCell(
            imageOrPhotoModel: imageOrPhotoModel,
            imageOrPhotoModelIndex: index,
          );
        },
      ),
    );
  }

  /// 相册 cell
  Widget _photoAlbumGridCell({
    @required dynamic imageOrPhotoModel,
    @required int imageOrPhotoModelIndex,
  }) {
    return Stack(
      children: [
        CQImageOrPhotoGridCell(
          imageOrPhotoModel: imageOrPhotoModel,
          index: imageOrPhotoModelIndex,
          onPressed: () {
            print('点击$imageOrPhotoModelIndex');
          },
        ),
        if (widget.badgeWidgetSetupBlock != null)
          widget.badgeWidgetSetupBlock(imageOrPhotoModel)
      ],
    );
  }
}
