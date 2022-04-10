import 'package:flutter/material.dart';
import './components/images_presuf_badge_list.dart';
import './components/bg_border_widget.dart';

class CQImagesAddDeleteList extends StatefulWidget {
  final int imageCount; // 图片个数(不包括prefixWidget/suffixWidget)
  final Widget Function({BuildContext context, int imageIndex})
      itemImageContentBuilder; // imageCell 上 content 的视图
  final void Function(int imageIndex) onPressedDelete; // "删除"按钮的点击事件
  final VoidCallback onPressedAdd; // "添加"按钮的点击事件

  CQImagesAddDeleteList({
    Key key,
    @required this.imageCount,
    @required this.itemImageContentBuilder,
    @required this.onPressedDelete,
    @required this.onPressedAdd,
  }) : super(key: key);

  @override
  _CQImagesAddDeleteListState createState() =>
      new _CQImagesAddDeleteListState();
}

class _CQImagesAddDeleteListState extends State<CQImagesAddDeleteList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CQImagesPreSufBadgeList(
      maxAddCount: 9,
      imageCount: widget.imageCount,
      suffixWidget: _addCell(),
      imageItemBuilder: ({context, imageIndex}) {
        return _photoAlbumGridCell(context: context, imageIndex: imageIndex);
      },
    );
  }

  /// 相册 cell
  Widget _photoAlbumGridCell({
    @required BuildContext context,
    @required int imageIndex,
  }) {
    return Stack(
      children: [
        widget.itemImageContentBuilder(
          context: context,
          imageIndex: imageIndex,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: _deleteIcon(imageIndex),
        ),
      ],
    );
  }

  Widget _deleteIcon(int imageIndex) {
    return GestureDetector(
      onTap: () {
        widget.onPressedDelete(imageIndex);
      },
      child: Icon(
        Icons.close,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  /// 添加图片的 cell
  Widget _addCell() {
    return CJBGImageWidget(
      backgroundImage: AssetImage(
        'assets/icon_images_add.png',
        package: 'flutter_images_action_list',
      ),
      child: Container(),
      onPressed: widget.onPressedAdd,
    );
  }
}
