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
      title: const Text('相册'),
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return const PhotoAlbumPage();
  }
}
