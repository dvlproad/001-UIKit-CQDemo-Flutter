import 'package:flutter/material.dart';
import './components/images_presuf_badge_list.dart';
import './components/bg_border_widget.dart';

class CQImagesAddDeleteList extends StatefulWidget {
  final List<dynamic> imageOrPhotoModels; // 数据类型 只能为 AssetEntity、String、File
  final VoidCallback onPressedAdd; // "添加"按钮的点击事件

  CQImagesAddDeleteList({
    Key key,
    this.imageOrPhotoModels,
    @required this.onPressedAdd,
  }) : super(key: key);

  @override
  _CQImagesAddDeleteListState createState() =>
      new _CQImagesAddDeleteListState();
}

class _CQImagesAddDeleteListState extends State<CQImagesAddDeleteList> {
  List<dynamic> _imageOrPhotoModels;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageOrPhotoModels = widget.imageOrPhotoModels ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return CQImagesPreSufBadgeList(
      maxAddCount: 9,
      imageOrPhotoModels: _imageOrPhotoModels,
      suffixWidget: _addCell(),
      badgeWidgetSetupBlock: (imageOrPhotoModel) {
        return Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              widget.imageOrPhotoModels.remove(imageOrPhotoModel);
              setState(() {});
            },
            child: Icon(
              Icons.close,
              size: 30,
              color: Colors.white,
            ),
          ),
        );
      },
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
