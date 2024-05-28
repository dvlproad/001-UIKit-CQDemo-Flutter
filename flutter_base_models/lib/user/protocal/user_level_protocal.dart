/*
 * @Author: dvlproad
 * @Date: 2024-05-16 14:45:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 13:46:10
 * @Description: 用户等级
 */
class UserLevelProtocal {
  int? level;
  String? levelName;
  String? levelImageUrl;

  UserLevelProtocal({
    this.level,
    this.levelName, // 该等级的名称（如黄金、钻石💎)
    this.levelImageUrl,
  });
}
