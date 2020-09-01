import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/image_cell_bean.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/adddelete/images_add_delete_grid_cell.dart';

typedef ImageCellConfigureBlock = ImageCellBean Function(dynamic dataModel);

class CQImagesAddDeleteBaseList extends StatefulWidget {
  final List<dynamic> imageModels;
  final int maxAddCount;
  final Widget prefixWidget;
  final Widget suffixWidget;

  final ImageCellConfigureBlock imageCellConfigureBlock;

  CQImagesAddDeleteBaseList({
    Key key,
    @required this.imageModels,
    this.maxAddCount = 100000,
    this.prefixWidget,
    this.suffixWidget,
    this.imageCellConfigureBlock,
  }) : super(key: key);

  @override
  _CQImagesAddDeleteBaseListState createState() =>
      _CQImagesAddDeleteBaseListState();
}

class _CQImagesAddDeleteBaseListState extends State<CQImagesAddDeleteBaseList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxShowCount = widget.maxAddCount;
    bool allowAddPrefixWidget = false;
    bool allowAddSuffixWidget = false;

    List<dynamic> _photoAlbumAssets = widget.imageModels ?? [];
    if (_photoAlbumAssets.length > maxShowCount) {
      _photoAlbumAssets = _photoAlbumAssets.sublist(0, widget.maxAddCount);
    }

    int itemCount = _photoAlbumAssets.length;
    if (widget.prefixWidget != null && itemCount < maxShowCount) {
      allowAddPrefixWidget = true;
      itemCount++;
    }
    if (widget.suffixWidget != null && itemCount < maxShowCount) {
      allowAddSuffixWidget = true;
      itemCount++;
    }

    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        padding: EdgeInsets.only(bottom: 5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          if (allowAddPrefixWidget == true && index == 0) {
            return widget.prefixWidget;
          }
          if (allowAddSuffixWidget == true && index == itemCount - 1) {
            return widget.suffixWidget;
          }

          int photoAlbumAssetIndex = index;
          if (allowAddPrefixWidget == true) {
            photoAlbumAssetIndex = index - 1;
          }
          return _photoAlbumGridCell(
            imageModel: _photoAlbumAssets[photoAlbumAssetIndex],
            photoAlbumAssetIndex: photoAlbumAssetIndex,
          );
        },
      ),
    );
  }

  /// 相册 cell
  Widget _photoAlbumGridCell({
    @required dynamic imageModel,
    @required int photoAlbumAssetIndex,
  }) {
    ImageCellBean cellBean = widget.imageCellConfigureBlock(imageModel);
    ImageProvider image = cellBean.image;
    String message = cellBean.message;

    return CQImageDeleteGridCell(
      image: image,
      message: message,
      index: photoAlbumAssetIndex,
      onPressed: () {
        print('点击$photoAlbumAssetIndex');
      },
      onPressedDelete: () {
        widget.imageModels.remove(imageModel);
        setState(() {});
      },
    );
  }
}
