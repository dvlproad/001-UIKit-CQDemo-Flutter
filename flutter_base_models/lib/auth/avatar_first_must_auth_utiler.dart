/*
 * @Author: dvlproad
 * @Date: 2024-04-19 18:08:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 10:18:18
 * @Description: 第一张头像必须是认证过。头像的更新
 * 不同于第一张头像可以待认证。头像的更新，如果已认证，则新头像也要是头像。
 */
import 'avatar_auth_service_info.dart';

abstract class AvatarFirstMustAuthUtiler {
  // 检测真人头像
  // 上传图片(图片不一定是人像，可能为风景等)到cos，将得到的图片url传给后端进行图片是否是人像的处理。
  // 如果不是人像，则退出页面；如果是人像，则通过上传后端返回的裁剪信息，进行裁剪
  authAvatarPath({
    required String anyImagePath,
    required Function() onFailure,
    required Function(AvatarAuthResultServiceInfo avatarAuthServiceInfo)
        onSuccess,
  }) async {
    String? avatarUrl =
        await uploadImageToAvatarCos(anyImagePath, isSelfie: false);
    if (avatarUrl == null) {
      onFailure();
      return;
    }

    return _authAvatarUrl(
      avatarUrl: avatarUrl,
      onFailure: onFailure,
      onSuccess: onSuccess,
    );
  }

  _authAvatarUrl({
    required String avatarUrl,
    required Function() onFailure,
    required Function(AvatarAuthResultServiceInfo avatarAuthServiceInfo)
        onSuccess,
  }) async {
    String? startAuthToken = await requestStartAuthAvatar(avatarUrl);
    if (startAuthToken == null || startAuthToken.isEmpty) {
      onFailure();
      return;
    }

    initNum = 0;
    _checkUpdateAvatarComplete(
      startAuthToken: startAuthToken,
      onSuccess: (AvatarAuthResultServiceInfo authResultModel) {
        onSuccess(authResultModel);
      },
      onFailure: onFailure,
    );
  }

  // 检测真人头像，是否有效
  static int initNum = 0; //当前轮询计数
  static int totalNum = 40; //最大可轮询次数
  void _checkUpdateAvatarComplete({
    required String startAuthToken,
    required Function(AvatarAuthResultServiceInfo authResultModel) onSuccess,
    required Function() onFailure,
  }) async {
    AvatarAuthResultServiceInfo? authResultModel =
        await requestAvatarAuthResult(startAuthToken);
    if (authResultModel == null) {
      if (initNum >= totalNum) {
        onFailure(); // "认证超时，请重试"
        return;
      }

      initNum += 1;
      Future.delayed(const Duration(milliseconds: 200), () {
        _checkUpdateAvatarComplete(
          startAuthToken: startAuthToken,
          onSuccess: onSuccess,
          onFailure: onFailure,
        );
      });
      return;
    }

    /// 认证成功
    onSuccess(authResultModel);
  }

  /// 需要子类重写的方法
  /// 0、上传本地头像文件到cos桶，并返回图片的网络地址
  Future<String?> uploadImageToAvatarCos(
    String anyImagePath, {
    required bool isSelfie, // 注意：自拍用于活体检测的头像，不会作为最后的头像，需要传到不同桶来限制用户访问
  });

  /// 1、请求开始认证头像，并返回认证的token，用于轮询(因为没有通知)认证的结果
  Future<String?> requestStartAuthAvatar(String avatarUrl);

  /// 2、请求认证结果
  Future<AvatarAuthResultServiceInfo?> requestAvatarAuthResult(
      String startAuthToken);

  /// 3、使用【前面认证通过的头像】作为头像，并在成功下返回头像(通常有个确认页面，点击确认按钮的时候调用)
  Future<String?> requestUseAuthedImageAsAvatar(
      AvatarAuthResultServiceInfo authResultModel);
}
