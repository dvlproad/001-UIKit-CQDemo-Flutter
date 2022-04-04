import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network/flutter_network.dart'
    show NetworkManager, ResponseModel;
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class CheckResponseModelUtil {
  static void Function() needReloginHandle; // 401等需要重新登录时候，执行的操作

  static ResponseModel checkResponseModel(
    ResponseModel responseModel, {
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) {
    int errorCode = responseModel.statusCode;
    if (errorCode != 0) {
      String errorMessage = _responseErrorMessage(
        responseModel,
        showToastForNoNetwork: showToastForNoNetwork,
      );
    }

    return responseModel;
  }

  static String _responseErrorMessage(
    ResponseModel responseModel, {
    bool showToastForNoNetwork = false, // 网络开小差的时候，是否显示toast(默认不toast)
  }) {
    int errorCode = responseModel.statusCode;
    if (errorCode == 0) {
      return null;
    }

    String errorMessage;
    if (errorCode == -1) {
      errorMessage = "非常抱歉！服务器开小差了～";

      String proxyIp = NetworkManager.serviceValidProxyIp; // 存在请求已开始，代理还没设置的情况
      if (proxyIp != null) {
        errorMessage = '$errorMessage:建议先关闭代理$proxyIp再检查';
      }
      if (showToastForNoNetwork == null || showToastForNoNetwork == false) {
        errorMessage = null;
      }
    } else if (errorCode == 500) {
      // statusCode 200, 但 errorCode 500 网络框架问题
      errorMessage = "非常抱歉！服务器开小差了～";
      if (showToastForNoNetwork == null || showToastForNoNetwork == false) {
        errorMessage = null;
      }
    } else if (errorCode == 401) {
      errorMessage = responseModel.message ?? "Token不能为空或Token过期，请重新登录";
      bool needRelogin = errorMessage == '暂未登录或token已经过期';
      if (needRelogin) {
        needReloginHandle();
      }
    } else if (errorCode == -500) {
      errorMessage = responseModel.message ?? "非常抱歉！请求发生错误了～";
    } else {
      errorMessage = responseModel.message ?? "非常抱歉！业务发生错误了～";
    }

    if (errorMessage != null && errorMessage.isNotEmpty) {
      ToastUtil.showMessage(errorMessage);
    }

    return errorMessage;
  }
}
