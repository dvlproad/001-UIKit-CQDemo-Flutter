import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photo-add-delete-list/images_add_delete_list.dart';

class TSPhotoAlbumAddDeletePage extends StatefulWidget {
  TSPhotoAlbumAddDeletePage({
    Key key,
  }) : super(key: key);

  @override
  _TSPhotoAlbumAddDeletePageState createState() =>
      new _TSPhotoAlbumAddDeletePageState();
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
      title: Text('图片添加'),
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return CQImagesAddDeleteList(
      imageOrPhotoModels: _imageOrPhotoModels,
      onPressedAdd: () {
        print('点击添加');
        // _imageOrPhotoModels.add('lib/commonui/cq-uikit/images/pic_搜索为空页面.png');
        this._addevent();
      },
    );
  }

  void _addevent() async {
    ImagePicker imagePicker = ImagePicker();
    final PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 70,
    );
    print("获取到的图片地址: pickedFile = $pickedFile");
    _imageOrPhotoModels.add(pickedFile.path);
    setState(() {});
  }
}
