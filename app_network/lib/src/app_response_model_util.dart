/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 15:09:01
 * @Description: ResponseModel 的处理方式
 */
import 'package:meta/meta.dart'; // 为了使用 @required
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class CheckResponseModelUtil {
  static late void Function() _needReloginHandle; // 401等需要重新登录时候，执行的操作

  static init(void Function() needReloginHandle) {
    _needReloginHandle = needReloginHandle;
  }

  /// 检查 responseModel 判断 toast 弹出，目前除401是强制弹之外，其他都要外部手动设置 showToastForNoNetwork 参数
  static ResponseModel checkResponseModel(
    ResponseModel responseModel, {
    bool showToastForNoNetwork = false, // 网络code不为0的时候，是否显示toast(默认不toast)
    String? serviceProxyIp,
  }) {
    if (responseModel.isSuccess) {
      return responseModel;
    }

    int errorCode = responseModel.statusCode;
    String? responseMessage = responseModel.message;
    if (errorCode == HttpStatusCode.NoNetwork) {
      responseMessage = '目前无可用网络';
    } else if (errorCode == HttpStatusCode.ErrorTimeout) {
      responseMessage = '请求超时';
    } else if (errorCode == HttpStatusCode.ErrorDioCancel) {
      responseMessage = '请求取消';
    } else if (errorCode == HttpStatusCode.ErrorDioResponse) {
      responseMessage = "非常抱歉！服务器开小差了～";
    } else if (errorCode == 500 || errorCode == 503) {
      // statusCode 200, 但 errorCode 500 网络框架问题
      responseMessage = "非常抱歉！服务器开小差了～";
    } else if (errorCode == 401) {
      if (responseModel.message == '暂未登录或token已经过期') {
        responseMessage = "登录失效，请重新登录";
        if (_needReloginHandle != null) {
          _needReloginHandle();
        }
        showToastForNoNetwork = true;
      } else {
        responseMessage = responseModel.message ?? "Token不能为空或Token过期，请重新登录";
      }
    } else if (errorCode == HttpStatusCode.ErrorTryCatch) {
      responseMessage = "非常抱歉！系统请求发生错误了～";
    } else if (errorCode == HttpStatusCode.Unknow) {
      responseMessage = "非常抱歉！服务器开小差了～";

      if (serviceProxyIp != null) {
        responseMessage = '$responseMessage:建议先关闭代理$serviceProxyIp再检查';
      }
    } else {
      responseMessage = responseModel.message ?? "非常抱歉！业务发生错误了～";
      showToastForNoNetwork = true;
    }

    if (responseModel.isCache != true && showToastForNoNetwork) {
      ToastUtil.showMessage(responseMessage);
    }

    return responseModel;
  }
}
