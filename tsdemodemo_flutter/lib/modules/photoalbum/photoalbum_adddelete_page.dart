import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/adddelete/images_add_delete_list.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/image_cell_bean.dart';

class TSPhotoAlbumAddDeletePage extends StatefulWidget {
  TSPhotoAlbumAddDeletePage({
    Key key,
  }) : super(key: key);

  @override
  _TSPhotoAlbumAddDeletePageState createState() =>
      new _TSPhotoAlbumAddDeletePageState();
}

class _TSPhotoAlbumAddDeletePageState extends State<TSPhotoAlbumAddDeletePage> {
  List<ImageCellBean> _photoAlbumAssets;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _photoAlbumAssets = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(),
      body: contentWidget(),
    );
  }

  /// 导航栏
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('图片添加'),
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return CQPhotoAlbumAddDeleteList(
      photoAlbumAssets: _photoAlbumAssets,
      imageCellAddCallBlock: () {
        ImageProvider image = NetworkImage(
            'https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg');
        String message = "00:49";
        ImageCellBean cellBean = ImageCellBean(image, message);
        return cellBean;
      },
    );
  }
}
