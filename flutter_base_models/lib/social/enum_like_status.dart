/*
 * @Author: dvlproad
 * @Date: 2024-05-16 14:36:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-17 13:09:32
 * @Description: 
 */

// 点赞类型
enum LikeStatus {
  unknow, // 无操作
  like, // 点赞
  unlike, // 点踩
}

/*
Map<int, LikeStatus> likeStatusMap = {
  0: LikeStatus.unknow, // 无操作
  1: LikeStatus.like, // 点赞
  2: LikeStatus.unlike, // 点踩
};

num likeNumber(LikeStatus? avatarStatus) {
  for (int key in likeStatusMap.keys) {
    if (likeStatusMap[key] == avatarStatus) {
      return key;
    }
  }
  return 2;
}

LikeStatus? likeEnum(num avatarNumber) {
  for (int key in likeStatusMap.keys) {
    if (key == avatarNumber) {
      return likeStatusMap[key];
    }
  }
  return null;
}
*/