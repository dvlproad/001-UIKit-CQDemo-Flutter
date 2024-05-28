// ignore_for_file: non_constant_identifier_names, camel_case_extensions

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:25:57
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 14:46:43
 * @Description: IM(发送TEXT文本、IMAGE图片地址、VIDEO视频地址、WEBPAGE网页链接)到聊天页面
 */
/*
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_IM on WebViewController {
  cjjs_im({
    required BuildContext? Function() contextGetBlock,
    void Function()? sendIMCompleteBlock,
  }) {
    // WebViewController controller = this;
    /// 根据用户的 userId ，进入用户私聊窗口
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_goChatByUserId',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? userId = h5Params?["userId"];
        if (userId == null || userId.isEmpty) {
          return; // JSResponseModel.error(message: '缺少 userId 参数');
        }

        BuildContext? context = contextGetBlock();
        if (context == null) {
          return;
        }

        ChatPageRouterUtil.openChatByUserId(
          context,
          uid: userId,
          fromPageSource: ChatFromPageSource.h5appoint,
        );
      },
    );

    /// 根据用户的 im 会话 id，进入用户私聊窗口
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_goChatByConversationId',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? conversationId = h5Params?["conversationId"];
        if (conversationId == null || conversationId.isEmpty) {
          return; // JSResponseModel.error(message: '缺少 conversationId 参数');
        }

        BuildContext? context = contextGetBlock();
        if (context == null) {
          return;
        }

        ChatPageRouterUtil.openChatByConversationId(
          context,
          conversationId: conversationId,
          fromPageSource: ChatFromPageSource.h5appoint,
        );
      },
    );
    
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_sendIMText',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? text = h5Params?["text"];
        if (text == null || text.isEmpty) {
          return; // JSResponseModel.error(message: '缺少 text 参数');
        }

        String? dialogSubjectId = h5Params?["dialogSubjectId"];
        if (dialogSubjectId == null || dialogSubjectId.isEmpty) {
          return; // JSResponseModel.error(message: '缺少 dialogSubjectId 参数');
        }

        String? dialogTypeString = h5Params?["dialogType"];
        DialogType dialogType;
        if (dialogTypeString == "user") {
          dialogType = DialogType.user;
        } else {
          dialogType = DialogType.user;
        }

        ChatUtil.sendImMessage(
          text,
          dialogSubjectId: dialogSubjectId,
          dialogType: dialogType,
          completeBlock: () {
            sendIMCompleteBlock?.call();
          },
        );
      },
    );
  }
}
*/