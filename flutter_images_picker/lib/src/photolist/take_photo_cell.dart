import 'package:flutter_baseui_kit/base-uikit/bg_border_widget.dart';
import '../photo_permission_pick_take_util.dart';

/// 拍照的 cell
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CQTakePhotoCell extends StatelessWidget {
  final BuildContext context;
  final ImagePicker imagePicker;
  final CQTakePhotoCallBack takePhotoCallBack;

  CQTakePhotoCell({
    Key key,
    @required this.context,
    this.imagePicker,
    this.takePhotoCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CJBGBorderWidget(
      backgroundColor: Color(0xff2C2C2E),
      child: Icon(
        Icons.photo_camera,
        size: 30,
        color: Colors.white,
      ),
      onPressed: () {
        // String path =
        //     'https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg';
        // if (takePhotoCallBack != null) {
        //   takePhotoCallBack(path);
        // }
        // return;

        ImagePicker imagePicker = this.imagePicker ?? ImagePicker();
        CQImagePickerUtil().takePhoto(
          context: context,
          imagePicker: imagePicker,
          imagePickerCallBack: (String path) {
            print('媒体路径为' + path);
            if (takePhotoCallBack != null) {
              takePhotoCallBack(path);
            }
          },
        );
      },
    );
  }
}
