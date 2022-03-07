import 'package:image_picker/image_picker.dart';
import './permission_manager.dart';

class PhotoTakeUtil {
  static Future<void> takePhoto({
    ImagePicker imagePicker,
    void Function(String path) imagePickerCallBack,
  }) async {
    bool allow = await PermissionsManager.checkCarmePermissions();
    if (allow == false) {
      return;
    }

    if (imagePicker == null) {
      imagePicker = ImagePicker();
    }
    final XFile pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 70,
    );
    print("拍摄到的图片地址: pickedFile = $pickedFile");

    if (pickedFile != null && imagePickerCallBack != null) {
      imagePickerCallBack(pickedFile.path); //获取到图片地址
    }
  }
}
