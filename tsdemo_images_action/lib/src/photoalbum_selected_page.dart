import 'package:flutter/material.dart';
import 'package:flutter_photoalbum/flutter_photoalbum.dart';

class TSPhotoAlbumSelectPage extends StatefulWidget {
  const TSPhotoAlbumSelectPage({
    Key key,
  }) : super(key: key);

  @override
  _TSPhotoAlbumSelectPageState createState() => _TSPhotoAlbumSelectPageState();
}

class _TSPhotoAlbumSelectPageState extends State<TSPhotoAlbumSelectPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 如果运行点击了发生崩溃，请检查是否info.plist中缺少了设置相册/相机权限
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
      title: const Text('PhotoAlbum Select(相册选择)'),
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return const PhotoAlbumPage();
  }
}
