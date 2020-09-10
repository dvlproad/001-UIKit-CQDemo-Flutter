import 'package:flutter/material.dart';
import 'package:photo/photo.dart';

import 'package:photo/src/entity/options.dart';
// export 'package:photo/src/entity/options.dart' show PickType;

// import 'package:photo/src/provider/i18n_provider.dart';
// export 'package:photo/src/provider/i18n_provider.dart'
//     show I18NCustomProvider, I18nProvider, CNProvider, ENProvider;

import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:photo/src/provider/config_provider.dart';
import 'package:photo/src/ui/page/photo_main_page.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photo-choose-util/photolist/take_photo_cell.dart';

typedef CQTakePhotoCallBack = void Function(String imagePath);

class CQPhotoAlbumList extends StatelessWidget {
  final I18nProvider provider;
  final List<AssetPathEntity> photoList;
  final List<AssetEntity> pickedAssetList;
  final CQTakePhotoCallBack takePhotoCallBack;
  final PickType pickType;
  final int maxSelected;

  CQPhotoAlbumList({
    Key key,
    this.provider,
    this.photoList,
    this.pickedAssetList,
    @required this.takePhotoCallBack,
    @required this.pickType,
    @required final this.maxSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var options = Options(
      rowCount: 4,
      dividerColor: Colors.black,
      maxSelected: this.maxSelected,
      itemRadio: 1.00,
      padding: 5.0,
      disableColor: Colors.grey.shade300,
      textColor: Colors.white,
      themeColor: Colors.black,

      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        checkColor: Colors.green,
        unselectedColor: Colors.white,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

      loadingDelegate: DefaultLoadingDelegate(),
      // if you want to build custom loading widget,extends LoadingDelegate, [see example/lib/main.dart]

      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget
      pickType: pickType,
    );

    final pickerProvider = PhotoPickerProvider(
      provider: this.provider,
      options: options,
      pickedAssetList: pickedAssetList,
      child: PhotoMainPage(
        prefixWidget: _takePhotoCell(
          context: context,
          takePhotoCallBack: this.takePhotoCallBack,
        ),
        onClose: (List<AssetEntity> value) {
          Navigator.pop(context, value);
        },
        options: options,
        photoList: photoList,
      ),
    );

    return pickerProvider;
  }

  /// 拍照的 cell
  Widget _takePhotoCell({
    @required BuildContext context,
    @required CQTakePhotoCallBack takePhotoCallBack,
  }) {
    ImagePicker imagePicker = ImagePicker();
    return CQTakePhotoCell(
      context: context,
      imagePicker: imagePicker,
      takePhotoCallBack: (String path) {
        Navigator.pop(context);

        if (takePhotoCallBack != null) {
          takePhotoCallBack(path);
        }
      },
    );
  }
}
