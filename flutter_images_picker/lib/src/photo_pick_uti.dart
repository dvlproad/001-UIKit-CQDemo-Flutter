import 'package:image_picker/image_picker.dart';
import './permission_manager.dart';

class PhotoPickUtil {
  static Future<void> pickPhoto({
    ImagePicker imagePicker,
    void Function(String path) imagePickerCallBack,
  }) async {
    bool allow = await PermissionsManager.checkPhotoPermissions();
    if (allow == false) {
      return;
    }

    if (imagePicker == null) {
      imagePicker = ImagePicker();
    }
    final XFile pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 70,
    );
    print("获取到的图片地址: pickedFile = $pickedFile");

    if (pickedFile != null && imagePickerCallBack != null) {
      imagePickerCallBack(pickedFile.path); //获取到图片地址
    }
  }
}
