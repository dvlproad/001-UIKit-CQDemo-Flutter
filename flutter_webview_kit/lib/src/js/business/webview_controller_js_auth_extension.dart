// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:12:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 13:17:58
 * @Description: 认证相关（实人认证、头像认证）
 */
/*
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

extension AddJSChannel_Auth on WebViewController {
  void app_js_auth({
    required WebViewController controller,
    required BuildContext? Function() contextGetBlock,
    required Function(String message) showPermissionDialog,
  }) {
    WebViewController controller = this;
    cj1_addJavaScriptChannel_callbackResult(
      'h5CallBridgeAction_go_auth_realname',
      callBackWebViewControllerGetBlock: () => controller,
      onMessageReceived: (
        Map<String, dynamic>? h5Params,
        void Function(dynamic jsCallbackResult) callbackHandle,
      ) {
        BuildContext? context = contextGetBlock();
        if (context == null) {
          return;
        }

        UserAuthRouterUtil.goAuthName(
          context: context,
          authPassCompleteBlock: () {
            Map<String, dynamic> jsCallbackMap = {
              // "newAvatarUrl": newAvatarUrl,
              // "newAvatarStatus": avatarNumber(newAvatarStatus),
            };

            callbackHandle(jsCallbackMap);
          },
        );
      },
    );
    cj1_addJavaScriptChannel_callbackResult(
      'h5CallBridgeAction_go_auth_avatar',
      callBackWebViewControllerGetBlock: () => controller,
      onMessageReceived: (
        Map<String, dynamic>? h5Params,
        void Function(dynamic jsCallbackResult) callbackHandle,
      ) async {
        BuildContext? context = contextGetBlock();
        if (context == null) {
          return;
        }
        UserAuthRouterUtil.checkAndShowAvatarAuthGuide(
          context: context,
          successResultTitle: "头像认证成功",
          onValueChangeAvatarStatus:
              (String newAvatarUrl, AvatarStatus newAvatarStatus) {
            Map<String, dynamic> jsCallbackMap = {
              "newAvatarUrl": newAvatarUrl,
              "newAvatarStatus": avatarNumber(newAvatarStatus),
            };
            callbackHandle(jsCallbackMap);
          },
        );
      },
    );

    ///实人认证(实名通过后，也要进行活体通过)
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_auth_realPerson',
      callBackWebViewControllerGetBlock: () => controller,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String certName = h5Params?['certName'] ?? "";
        String certNo = h5Params?['certNo'] ?? "";

        FacePluginBaseVerifyResult? resultInfo = await AuthUtil.authRealName(
          // useAliYun: type == 1, // 0 腾讯  1 阿里云
          certNo: certNo, certName: certName,
          grantedFailure: () {
            showPermissionDialog("无法使用摄像头，请在手机应用权限管理中打开摄像头权限");
          },
        );
        Map<String, dynamic>? callbackMap = {
          "resultInfo": resultInfo?.toJson()
        };

        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }

  // cjjs_authRealPerson({
  //   required Future<Map<String, dynamic>?> Function({
  //     required String certName,
  //     required String certNo,
  //   })
  //       resultMapGetHandle,
  //   required WebViewController? Function() webViewControllerGetBlock,
  // }) {
  //   cj2_addJavaScriptChannel_asyncReceived(
  //     'h5CallBridgeAction_auth_realPerson',
  //     callBackWebViewControllerGetBlock: webViewControllerGetBlock,
  //     onMessageReceived: (Map<String, dynamic>? h5Params) async {
  //       String certName = h5Params?['certName'] ?? "";
  //       String certNo = h5Params?['certNo'] ?? "";
  //       Map<String, dynamic>? callbackMap = await resultMapGetHandle(
  //         certNo: certNo,
  //         certName: certName,
  //       );
  //       return JSResponseModel.success(
  //         isSuccess: true,
  //         result: callbackMap,
  //       );
  //     },
  //   );
  // }
}
*/