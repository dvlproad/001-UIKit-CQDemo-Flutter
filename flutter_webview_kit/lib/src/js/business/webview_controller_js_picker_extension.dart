// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-30 10:00:13
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 13:40:26
 * @Description: Picker相关（选择照片等）
 */
/*
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel:Picker相关（选择照片等）
extension AddJSChannel_Pickers on WebViewController {
  void app_js_pickers({
    required BuildContext? Function() contextGetBlock,
  }) {
    WebViewController controller = this;
    cj1_addJavaScriptChannel_callbackResult(
      'h5CallBridgeAction_pickMediasAndUpload',
      callBackWebViewControllerGetBlock: () => controller,
      onMessageReceived: (
        Map<String, dynamic>? h5Params,
        void Function(dynamic jsCallbackResult) callbackHandle,
      ) async {
        BuildContext? context = contextGetBlock();
        // BuildContext? context = MainInit.navigatorKey.currentContext,
        if (context == null) {
          return;
        }

        String? allowMeidaTypeString = h5Params?["allowMeidaType"];
        int maxCount = h5Params?["maxCount"] ?? 1;
        bool showCamera = h5Params?["showCamera"] ?? true;

        PickPhotoAllowType? pickAllowType;
        if (allowMeidaTypeString == "image") {
          pickAllowType = PickPhotoAllowType.imageOnly;
        } else if (allowMeidaTypeString == "video") {
          pickAllowType = PickPhotoAllowType.videoOnly;
        } else if (allowMeidaTypeString == "both") {
          pickAllowType = PickPhotoAllowType.imageOrVideo;
        }
        PickUtil.pickPhoto(
          context,
          imageChooseModels: [],
          pickAllowType: pickAllowType ?? PickPhotoAllowType.imageOnly,
          maxCount: maxCount,
          imagePickerCallBack: ({
            List<ImageChooseBean>? newAddedImageChooseModels,
            List<ImageChooseBean>? newCancelImageChooseModels,
          }) async {
            if (newAddedImageChooseModels == null ||
                newAddedImageChooseModels.isEmpty) {
              return;
            }
            List<String> imageUrls = [];
            LoadingView.singleton.wrap(asyncFunction: () async {
              for (ImageChooseBean imageChooseModel
                  in newAddedImageChooseModels) {
                File? file = await imageChooseModel.assetEntity?.file;
                if (file != null) {
                  String? imgUrl = await UploadApiUtil.channel_uploadQCloud(
                    file.path,
                    mediaType: imageChooseModel.mediaType,
                  );
                  if (imgUrl != null) {
                    imageUrls.add(imgUrl);
                  }
                }
              }
              Map<String, dynamic> jsCallbackMap = {
                "imageUrls": imageUrls,
              };
              callbackHandle(jsCallbackMap);
            });
          },
        );
      },
    );
  }
}
*/