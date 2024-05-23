/*
 * @Author: dvlproad
 * @Date: 2022-07-13 11:30:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 10:32:54
 * @Description: 可见范围/权限
 */
enum JurisdictionType {
  all, //所有人可见
  self, //我自己可见
  partSee, //部分人可见
  partNoSee, //部分人不可见
}

class JurisdictionBean {
  // final JurisdictionType type;
  final String text;

  JurisdictionBean({
    // required this.type,
    required this.text,
  });
}
