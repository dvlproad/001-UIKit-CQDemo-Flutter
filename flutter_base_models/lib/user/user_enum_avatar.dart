/*
 * @Author: dvlproad
 * @Date: 2024-05-16 14:24:30
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-17 13:13:13
 * @Description: 
 */
// 头像认证状态 1: 初始化 2: 人脸检测不通过 4: 人脸通过 16: 活体通过
enum AvatarStatus {
  init,
  notPass,
  facePass,
  livePass,
}

bool isAvatarPass(AvatarStatus avatarStatus) {
  return [AvatarStatus.init, AvatarStatus.notPass].contains(avatarStatus);
}

// 请在子类实现 int 转 枚举
/*
extension ToEnumDemoExtension on num {
  RealNameStatus get toRealNameStatus {
    switch (this) {
      case 1:
        return RealNameStatus.success;
      default:
        return RealNameStatus.none;
    }
  }
}


Map<int, AvatarStatus> avatarStatusMap = {
  1: AvatarStatus.init, // 初始化
  2: AvatarStatus.notPass, // 人脸检测不通过
  4: AvatarStatus.facePass, // 人脸通过
  16: AvatarStatus.livePass, // 活体通过
};

num avatarNumber(AvatarStatus? avatarStatus) {
  for (int key in avatarStatusMap.keys) {
    if (avatarStatusMap[key] == avatarStatus) {
      return key;
    }
  }
  return 2;
}

AvatarStatus? avatarEnum(num avatarNumber) {
  for (int key in avatarStatusMap.keys) {
    if (key == avatarNumber) {
      return avatarStatusMap[key];
    }
  }
  return null;
}

*/