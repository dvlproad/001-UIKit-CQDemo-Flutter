/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:48:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 14:05:00
 * @Description: 支付相关
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
/*
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../js_add_check_run/h5_call_bridge_response_model.dart';

extension AddJSChannel_Pay on WebViewController {
  void app_js_pay() {
    WebViewController controller = this;
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_pay',
      callBackWebViewControllerGetBlock: () => controller,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        if (h5Params == null) {
          return JSResponseModel.error(message: '缺少 h5Params 参数');
        }

        String? payType = h5Params['payType'];
        // if (payType == null || payType.isEmpty) {
        //   return JSResponseModel.error(message: '缺少 payType 参数');
        // }

        Map<String, dynamic> argsFromH5 = h5Params;
        MiniProgramPayBean payParams = MiniProgramPayBean.fromJson(argsFromH5);
        bool isSuccess = false;
        if (payType == 'wx_mp') {
          isSuccess = await WXMPPay.jumpWechatMP2Pay(payParams);
        } else {
          isSuccess = await WXMPPay.jumpWechatMP2Pay(payParams);
        }
        return JSResponseModel.success(isSuccess: isSuccess);
      },
    );
  }
}
*/
