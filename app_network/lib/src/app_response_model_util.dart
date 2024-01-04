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
  static late void Function(ResponseModel responseModel) _needReloginHandle; // 401等需要重新登录时候，执行的操作
  static List<int>? Function()? _forceNoToastStatusCodesGetFunction;

  static init({
    required void Function(ResponseModel responseModel) needReloginHandle,
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
    bool needToast = false;
    // 1、http 的 toast 设置与修改
    if (responseModel.isErrorResponse) {
      bool shouldShowHttpError = toastIfMayNeed ?? true;
      int errorCode = responseModel.statusCode;
      String? responseMessage = responseModel.message;
      responseMessage =
          showErrorMessageToast(errorCode, responseMessage, needToast: false);
      if (errorCode == 401) {
        if (responseModel.message == '暂未登录或token已经过期') {
          if (responseModel.isCache != true) {
            _needReloginHandle(responseModel);
          }
          shouldShowHttpError = true;
        }
      } else if (errorCode == 20030) {
        toastIfMayNeed = false;
        if (responseModel.isCache != true) {
          _needReloginHandle(responseModel);
        }
      } else if (errorCode == HttpStatusCode.Unknow) {
        if (serviceProxyIp != null) {
          responseMessage = '$responseMessage:建议先关闭代理$serviceProxyIp再检查';
        }
      }
      if (_forceNoToastStatusCodesGetFunction != null) {
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
          shouldShowHttpError = false;
        }
      }

      needToast = shouldShowHttpError;
      responseModel.message = responseMessage ?? "非常抱歉！服务器开小差了～";
    } else {
      // 2、业务失败 code 处理
      // 2.②、业务失败，未设置默认都要toast，如创建失败
      if (responseModel.isSuccess != true) {
        bool errorBusinessShouldToast = toastIfMayNeed ?? true;

        needToast = errorBusinessShouldToast;
        responseModel.message ??= "非常抱歉！业务发生错误了～";
      }
    }

    // 3、toast的信息整合
    if (responseModel.isCache != true && needToast == true) {
      ToastUtil.showMessage(responseModel.message ?? ''); // 避免无网络时候，每个接口都弹一遍
    }

    return responseModel;
  }

  ///请求失败toast提示
  static String showErrorMessageToast(int errorCode, String? message,
      {bool needToast = true}) {
    String errorMessage = '';
    if (errorCode == HttpStatusCode.NoNetwork) {
      errorMessage = '目前无可用网络';
    } else if (errorCode == HttpStatusCode.ErrorDioOther) {
      errorMessage = '目前无可用网络';
    } else if (errorCode == HttpStatusCode.ErrorTimeout) {
      errorMessage = '请求超时';
    } else if (errorCode == HttpStatusCode.ErrorDioCancel) {
      errorMessage = '请求取消';
    } else if (errorCode == HttpStatusCode.ErrorDioResponse) {
      errorMessage = "非常抱歉！服务器开小差了～";
    } else if (errorCode == 500 || errorCode == 503) {
      errorMessage = "非常抱歉！服务器开小差了～";
    } else if (errorCode == 401) {
      errorMessage = "登录失效，请重新登录";
      if (message == '暂未登录或token已经过期') {
        errorMessage = "登录失效，请重新登录";
      } else {
        errorMessage = message ?? "Token不能为空或Token过期，请重新登录";
      }
    } else if (errorCode == 20030) {
      errorMessage = "";
    } else if (errorCode == HttpStatusCode.ErrorTryCatch) {
      errorMessage = "非常抱歉！系统请求发生错误了～";
    } else if (errorCode == HttpStatusCode.Unknow) {
      errorMessage = "非常抱歉！服务器开小差了～";
    } else {
      errorMessage = "非常抱歉！服务器开小差了～";
    }
    if (needToast == true) {
      ToastUtil.showMessage(errorMessage); // 避免无网络时候，每个接口都弹一遍
    }
    return errorMessage;
  }
}
