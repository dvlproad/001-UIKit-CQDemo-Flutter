/*
 * @Author: dvlproad
 * @Date: 2024-05-22 17:21:48
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 10:06:38
 * @Description: 
 */

// 将本地图片上传到服务器时候，服务器返回的信息
abstract class AvatarAuthBaseServiceInfo {
  final String avatarUrl;
  final String resultToken;

  AvatarAuthBaseServiceInfo({
    // 上传给服务器要进行人脸验证的头像地址
    required this.avatarUrl,
    // 人脸验证时候，返回的token(耗时长，所以异步，所以用此token查询处理结果；验证通过的话进行更新的时候也需要使用此token，保证用的头像是之前认证过的，而不是又拿其他图片来糊弄)
    required this.resultToken,
  });
}

// 人脸验证通过后，返回的裁剪信息（有时候会为了精修图片）
class AvatarClipConfig {
  final dynamic rotate; //旋转度
  final dynamic widthScale; //宽比
  final dynamic heightScale; //高比
  final dynamic xscale; //x比
  final dynamic yscale; //y比

  AvatarClipConfig({
    this.rotate,
    this.widthScale,
    this.heightScale,
    this.xscale,
    this.yscale,
  });
}

// 人脸验证通过后，返回的裁剪信息（有时候会为了精修图片）
class AvatarAuthResultServiceInfo extends AvatarAuthBaseServiceInfo {
  final AvatarClipConfig? resultClipConfig;

  AvatarAuthResultServiceInfo({
    required String avatarUrl,
    required String resultToken,
    this.resultClipConfig,
  }) : super(
          avatarUrl: avatarUrl,
          resultToken: resultToken,
        );

  static AvatarAuthResultServiceInfo fromJson(Map<String, dynamic> json) {
    AvatarClipConfig? resultClipConfig = AvatarClipConfig(
      rotate: json["rotate"],
      widthScale: json["widthScale"],
      heightScale: json["heightScale"],
      xscale: json["xscale"],
      yscale: json["yscale"],
    );

    return AvatarAuthResultServiceInfo(
      avatarUrl: json["avatar"],
      resultToken: json["token"],
      resultClipConfig: resultClipConfig,
    );
  }
}
