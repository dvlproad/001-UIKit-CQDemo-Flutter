/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 01:31:22
 * @Description: ResponseModel 的处理方式
 */
import 'package:flutter_network_base/flutter_network_base.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

/*
/// 特殊code的toast使用
enum SpecialCodeToastRule {
  keepDefault, // 使用默认规则
  forceToast, // 强制弹出 toast
  forceNoToast, // 强制不弹出 toast
}

/// 特殊code的toast使用规则
class SpecialCodeRuleBean {
  int code;
  SpecialCodeToastRule toastRule;

  SpecialCodeBean({
    required this.code,
    required this.toastRule,
  });
}
*/

class CheckResponseModelUtil {
  static late void Function() _needReloginHandle; // 401等需要重新登录时候，执行的操作
  static List<int>? Function()? _forceNoToastStatusCodesGetFunction;

  static init({
    required void Function() needReloginHandle,
    List<int>? Function()?
        forceNoToastStatusCodesGetFunction, // 获取哪些真正的statusCode药强制不弹 toast
  }) {
    _needReloginHandle = needReloginHandle;
    _forceNoToastStatusCodesGetFunction = forceNoToastStatusCodesGetFunction;
  }

  /// 检查 responseModel 判断 toast 弹出，目前除401是强制弹之外，其他都要外部手动设置 showToastForNoNetwork 参数
  static ResponseModel checkResponseModel(
    ResponseModel responseModel, {
    bool?
        toastIfMayNeed, // 应该弹出toast的地方是否要弹出toast(如网络code为500的时候),必须可为空是,不为空的时候无法实现修改
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
      // toastIfMayNeed = true; // 先强制弹出toast,需要关闭的时候，再由后台通过全局网络配置处理成不弹
    } else if (errorCode == 401) {
      if (responseModel.message == '暂未登录或token已经过期') {
        responseMessage = "登录失效，请重新登录";
        if (responseModel.isCache != true) {
          _needReloginHandle();
        }
        toastIfMayNeed = true;
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
      toastIfMayNeed ??= true;
    }
    responseModel.message = responseMessage; //强制转成想要的文案，避免外部的业务方拿该值去显示

    // 不为空的时候不能/无法实现修改
    if (toastIfMayNeed == null && _forceNoToastStatusCodesGetFunction != null) {
      /*
      List<SpecialCodeRuleBean>? specialCodeRuleBeans =
          _forceNoToastStatusCodesGetFunction!();
      if (specialCodeRuleBeans != null) {
        List<SpecialCodeRuleBean>? specialCodeRuleBeans_match =
            specialCodeRuleBeans.where((element) => element.code == errorCode);
        if (specialCodeRuleBeans_match != null &&
            specialCodeRuleBeans_match.isNotEmpty) {
          showToastForNoNetwork = specialCodeRuleBeans_match[0];
        }
      }
      */
      List<int>? forceNoToastStatusCodes =
          _forceNoToastStatusCodesGetFunction!();
      if (forceNoToastStatusCodes != null &&
          forceNoToastStatusCodes.contains(errorCode)) {
        toastIfMayNeed = false;
      }
    }

    if (responseModel.isCache != true && toastIfMayNeed == true) {
      ToastUtil.showMessageOnlyOnce(responseMessage); // 避免无网络时候，每个接口都弹一遍
    }

    return responseModel;
  }
}
