/*
 * @Author: dvlproad
 * @Date: 2022-03-01 11:49:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 13:47:17
 * @Description: 用户信息相关api
 */
import 'package:app_devtool_framework/app_devtool_framework.dart';

import '../user_manager.dart';

// import 'package:wish/http/Network/UrlPath.dart';
// import 'package:wish/ui/class/mine/member/model/member_info_model.dart';

class UserApi {
  /// 获取用户详情信息
  static Future<bool> getUserDetailInfo() async {
    if (await UserInfoManager().isLogin != true) {
      return Future.value(false);
    }

    return AppNetworkKit.get('UrlPath.userInfo')
        .then((ResponseModel responseModel) {
      if (responseModel.isSuccess) {
        // 此接口返回的 userId 没用，要用登录时候返回的 id 才是 userId，鬼知道后台怎么这样
        responseModel.result['id'] = UserInfoManager().userModel?.id;
        responseModel.result['userId'] = UserInfoManager().userModel?.id;

        UserInfoManager().getDetailSuccessWithUserMap(responseModel.result);
        return true;
      } else {
        return false;
      }
    });
  }
  /*
  /// 获取用户会员信息
  static void getUserMemberInfo({
    required void Function(Member_info_model memberInfoModel) success,
    required void Function() failure,
  }) async {
    if (await UserInfoManager().isLogin != true) {
      return failure();
    }

    AppNetworkKit.postWithCallback(
      UrlPath.newMemberGetMemberInfo,
      cacheLevel: AppNetworkCacheLevel.one,
      completeCallBack: (ResponseModel responseModel) {
        if (responseModel.isSuccess) {
          Member_info_model memberInfoModel =
              Member_info_model.fromJson(responseModel.result);
          UserInfoManager().userModel.memberModel = memberInfoModel;

          success(memberInfoModel);
        } else {
          failure();
        }
      },
    );
  }
  */
}
