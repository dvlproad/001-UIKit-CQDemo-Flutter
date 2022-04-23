import 'package:flutter/material.dart';
import './components/images_presuf_badge_list.dart';
import './components/bg_border_widget.dart';

class CQImagesAddDeleteList extends StatefulWidget {
  final double width;
  final double height;
  final bool dragEnable;
  final void Function(int oldIndex, int newIndex) dragCompleteBlock;

  final int maxAddCount; // 默认null,null时候默认9个
  final int imageCount; // 图片个数(不包括prefixWidget/suffixWidget)
  final Widget Function({BuildContext context, int imageIndex})
      itemImageContentBuilder; // imageCell 上 content 的视图
  final void Function(int imageIndex) onPressedDelete; // "删除"按钮的点击事件
  final Widget Function() addCellBuilder; // 默认null，null时候使用默认样式
  final VoidCallback onPressedAdd; // "添加"按钮的点击事件

  CQImagesAddDeleteList({
    Key key,
    this.width,
    this.height,
    this.dragEnable, // 是否可以拖动
    this.dragCompleteBlock,
    this.maxAddCount,
    @required this.imageCount,
    @required this.itemImageContentBuilder,
    @required this.onPressedDelete,
    this.addCellBuilder,
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
      width: widget.width,
      height: widget.height,
      dragEnable: widget.dragEnable,
      dragCompleteBlock: widget.dragCompleteBlock,
      cellWidthFromPerRowMaxShowCount: 4,
      columnSpacing: 6,
      rowSpacing: 6,
      maxAddCount: widget.maxAddCount ?? 9,
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
    double imageWith = 24;
    return GestureDetector(
      onTap: () {
        widget.onPressedDelete(imageIndex);
      },
      // child: Icon(
      //   Icons.close,
      //   size: 30,
      //   color: Colors.white,
      // ),
      child: Container(
        // color: Colors.red,
        width: imageWith + 4,
        height: imageWith + 4,
        child: Center(
          child: Image(
            image: AssetImage(
              'assets/icon_delete.png',
              package: 'flutter_images_action_list',
            ),
            width: imageWith,
            height: imageWith,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// 添加图片的 cell
  Widget _addCell() {
    if (widget.addCellBuilder != null) {
      return GestureDetector(
        child: widget.addCellBuilder(),
        onTap: widget.onPressedAdd,
      );
    }

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
