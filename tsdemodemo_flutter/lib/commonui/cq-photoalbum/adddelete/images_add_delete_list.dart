import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/button/imagebutton.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/adddelete/images_add_delete_base_list.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/image_cell_bean.dart';

typedef ImageCellAddCallBlock = ImageCellBean Function();

class CQPhotoAlbumAddDeleteList extends StatefulWidget {
  final List<ImageCellBean> photoAlbumAssets;
  final ImageCellAddCallBlock imageCellAddCallBlock;

  CQPhotoAlbumAddDeleteList({
    Key key,
    @required this.photoAlbumAssets,
    @required this.imageCellAddCallBlock,
  }) : super(key: key);

  @override
  _CQPhotoAlbumAddDeleteListState createState() =>
      new _CQPhotoAlbumAddDeleteListState();
}

class _CQPhotoAlbumAddDeleteListState extends State<CQPhotoAlbumAddDeleteList> {
  List<ImageCellBean> _photoAlbumAssets;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _photoAlbumAssets = widget.photoAlbumAssets ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return CQImagesAddDeleteBaseList(
      maxAddCount: 6,
      imageModels: _photoAlbumAssets,
      imageCellConfigureBlock: (dynamic dataModel) {
        // ImageProvider image = NetworkImage(
        //       'https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg');
        //   String message = "00:49";
        //   ImageCellBean cellBean = ImageCellBean(image, message);

        // PhotoAlbumAssetEntity entity = dataModel as PhotoAlbumAssetEntity;
        // ImageProvider image = MemoryImage(entity.bytes);
        // String message;
        // if (entity.asset.type == AssetType.video) {
        //   int duration = entity.asset.duration;
        //   final minutes = (duration / 60).floor();
        //   final seconds = duration % 60;
        //   message =
        //       '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        // }
        ImageCellBean entity = dataModel as ImageCellBean;
        ImageProvider image = entity.image;
        String message = entity.message;

        ImageCellBean cellBean = ImageCellBean(image, message);
        return cellBean;
      },
      prefixWidget: CenterIconButton(
        assestName: 'lib/commonui/cq-guide-overlay/Resources/icon_点赞.png',
        iconButtonSize: 40,
        iconImageSize: 40,
        onPressed: () {
          if (widget.imageCellAddCallBlock != null) {
            ImageCellBean cellBean = widget.imageCellAddCallBlock();
            _photoAlbumAssets.add(cellBean);
            setState(() {});
          }
        },
      ),
      // suffixWidget: Container(color: Colors.green),
    );
  }
}
