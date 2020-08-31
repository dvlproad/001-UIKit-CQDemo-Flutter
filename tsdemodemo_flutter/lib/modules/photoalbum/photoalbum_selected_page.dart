import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/select/photo_album_select_page.dart';

class TSPhotoAlbumSelectPage extends StatefulWidget {
  TSPhotoAlbumSelectPage({
    Key key,
  }) : super(key: key);

  @override
  _TSPhotoAlbumSelectPageState createState() =>
      new _TSPhotoAlbumSelectPageState();
}

class _TSPhotoAlbumSelectPageState extends State<TSPhotoAlbumSelectPage> {
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
      title: Text('相册'),
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return PhotoAlbumPage();
  }
}
