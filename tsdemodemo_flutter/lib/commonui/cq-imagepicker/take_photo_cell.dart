import 'package:tsdemodemo_flutter/commonui/base-uikit/bg_border_widget.dart';
import 'package:tsdemodemo_flutter/commonui/cq-imagepicker/imagepicker_util.dart';
import 'package:tsdemodemo_flutter/commonutil/c1440_icon.dart';

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
        C1440Icon.icon_tab_photo_n,
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
        CQImagePickerUtil().pickerImageOrVideo(
          type: 2,
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
