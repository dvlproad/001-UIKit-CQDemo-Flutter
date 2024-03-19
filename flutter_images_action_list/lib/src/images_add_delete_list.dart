// 纯净的列表：model的操作需要自己依赖，自己控制
import 'package:flutter/material.dart';
import './components/images_presuf_badge_list.dart';
import './components/bg_border_widget.dart';

class CQImagesAddDeleteList extends StatelessWidget {
  final double width;
  final double? height;
  final EdgeInsets? padding;
  final Color? color;

  final Axis direction;
  final Axis scrollDirection;
  final ScrollPhysics? physics;

  final bool dragEnable;
  final void Function(int oldIndex, int newIndex)? dragCompleteBlock;

  final int maxAddCount; // 默认null,null时候默认9个
  final int imageCount; // 图片个数(不包括prefixWidget/suffixWidget)
  final double?
      itemWidthHeightRatio; // 宽高比(默认1:1,即1/1.0，请确保除数有小数点，否则1/2会变成0，而不是0.5)
  final Widget Function({
    required BuildContext context,
    required int imageIndex,
    required double itemWidth,
    required double itemHeight,
  }) itemImageContentBuilder; // imageCell 上 content 的视图

  final bool hideDeleteIcon; // 隐藏删除按钮
  final void Function(int imageIndex) onPressedDelete; // "删除"按钮的点击事件
  final Widget Function()? addCellBuilder; // 默认null，null时候使用默认样式
  final VoidCallback onPressedAdd; // "添加"按钮的点击事件

  const CQImagesAddDeleteList({
    Key? key,
    required this.width,
    this.height,
    this.padding,
    this.color,
    this.direction = Axis.horizontal,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.dragEnable = false, // 是否可以拖动
    this.dragCompleteBlock,
    this.maxAddCount = 9,
    required this.imageCount,
    this.itemWidthHeightRatio,
    required this.itemImageContentBuilder,
    this.hideDeleteIcon = false,
    required this.onPressedDelete,
    this.addCellBuilder,
    required this.onPressedAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CQImagesPreSufBadgeList(
      width: width,
      height: height,
      padding: padding,
      color: color,
      direction: direction,
      scrollDirection: scrollDirection,
      physics: physics,
      dragEnable: dragEnable,
      dragCompleteBlock: dragCompleteBlock,
      cellWidthFromPerRowMaxShowCount: 4,
      columnSpacing: 6,
      rowSpacing: 6,
      maxAddCount: maxAddCount,
      imageCount: imageCount,
      suffixWidget: _addCell(),
      itemWidthHeightRatio: itemWidthHeightRatio,
      imageItemBuilder: ({
        required BuildContext context,
        required int imageIndex,
        required double itemHeight,
        required double itemWidth,
      }) {
        return _photoAlbumGridCell(
          context: context,
          imageIndex: imageIndex,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
        );
      },
    );
  }

  /// 相册 cell
  Widget _photoAlbumGridCell({
    required BuildContext context,
    required int imageIndex,
    required double itemWidth,
    required double itemHeight,
  }) {
    return Stack(
      children: [
        itemImageContentBuilder(
          context: context,
          imageIndex: imageIndex,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
        ),
        Visibility(
          visible: !hideDeleteIcon,
          child: Positioned(
            right: 0,
            top: 0,
            child: _deleteIcon(imageIndex),
          ),
        ),
      ],
    );
  }

  Widget _deleteIcon(int imageIndex) {
    double imageWith = 24;
    return GestureDetector(
      onTap: () {
        onPressedDelete(imageIndex);
      },
      // child: Icon(
      //   Icons.close,
      //   size: 30,
      //   color: Colors.white,
      // ),
      child: Container(
        // color: Colors.red,
        width: imageWith + 0,
        height: imageWith + 0,
        child: Center(
          child: Image(
            image: const AssetImage(
              'assets/icon_delete_new.png',
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
    if (addCellBuilder != null) {
      return GestureDetector(
        child: addCellBuilder!(),
        onTap: onPressedAdd,
      );
    }

    return CJBGImageWidget(
      backgroundImage: const AssetImage(
        'assets/icon_images_add.png',
        package: 'flutter_images_action_list',
      ),
      child: Container(),
      onTap: onPressedAdd,
    );
  }
}
