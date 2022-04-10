import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';

class TSPhotoAlbumAddDeletePage extends StatefulWidget {
  const TSPhotoAlbumAddDeletePage({
    Key key,
  }) : super(key: key);

  @override
  _TSPhotoAlbumAddDeletePageState createState() =>
      _TSPhotoAlbumAddDeletePageState();
}

class _TSPhotoAlbumAddDeletePageState extends State<TSPhotoAlbumAddDeletePage> {
  List<dynamic> _imageOrPhotoModels;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // 如果运行点击了发生崩溃，请检查是否info.plist中缺少了设置相册/相机权限
    super.initState();
    _imageOrPhotoModels = [];
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
      title: const Text('Images AddDelete(图片添加)'),
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return CQImagesAddDeleteList(
      imageCount: _imageOrPhotoModels.length,
      itemImageContentBuilder: ({context, imageIndex}) {
        dynamic photoAlbumPath = _imageOrPhotoModels[imageIndex];

        ImageProvider imageProvider;
        if (photoAlbumPath.startsWith(RegExp(r'https?:'))) {
          // Image image = Image.network(photoAlbumPath);
          imageProvider = NetworkImage(photoAlbumPath);
        } else {
          Image image = Image.file(File(photoAlbumPath));
          imageProvider = image.image;
          // imageProvider = AssetImage(photoAlbumPath);
        }

        String message = '';
        return CQImageBaseGridCell(
          imageProvider: imageProvider,
          message: message,
          index: imageIndex,
          onPressed: () {
            print('点击$imageIndex');
          },
        );
      },
      onPressedAdd: () {
        debugPrint('点击添加');
        // _imageOrPhotoModels.add('lib/commonui/cq-uikit/images/pic_搜索为空页面.png');
        _addevent();
      },
    );
  }

  void _addevent() async {
    ImagePicker imagePicker = ImagePicker();
    final XFile pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      CJTSToastUtil.showMessage("获取到的图片地址: pickedFile = $pickedFile");
      _imageOrPhotoModels.add(pickedFile.path);
    } else {
      CJTSToastUtil.showMessage("取消了图片选择");
    }

    setState(() {});
  }
}
