import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/adddelete/cq-imagechoose-list.dart';

class TSPhotoAlbumAddDeletePage extends StatefulWidget {
  TSPhotoAlbumAddDeletePage({
    Key key,
  }) : super(key: key);

  @override
  _TSPhotoAlbumAddDeletePageState createState() =>
      new _TSPhotoAlbumAddDeletePageState();
}

class _TSPhotoAlbumAddDeletePageState extends State<TSPhotoAlbumAddDeletePage> {
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
    return CQImagesChooseList(
      maxAddCount: 6,
      photoAlbumAssets: null,
      prefixWidget: Container(color: Colors.red),
      // suffixWidget: Container(color: Colors.green),
    );
  }
}
