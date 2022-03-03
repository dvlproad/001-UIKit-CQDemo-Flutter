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
      title: const Text('图片添加'),
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return CQImagesAddDeleteList(
      imageOrPhotoModels: _imageOrPhotoModels,
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
