import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/image_or_photo_grid_cell.dart';
import 'package:tsdemodemo_flutter/commonutil/c1440_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CQImageDeleteList extends StatefulWidget {
  final List<dynamic> imageOrPhotoModels;
  final int maxAddCount;
  final Widget prefixWidget;
  final Widget suffixWidget;

  CQImageDeleteList({
    Key key,
    @required this.imageOrPhotoModels,
    this.maxAddCount = 100000,
    this.prefixWidget,
    this.suffixWidget,
  }) : super(key: key);

  @override
  _CQImageDeleteListState createState() => _CQImageDeleteListState();
}

class _CQImageDeleteListState extends State<CQImageDeleteList> {
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
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              widget.imageOrPhotoModels.remove(imageOrPhotoModel);
              setState(() {});
            },
            child: Icon(
              C1440Icon.icon_error,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
