/*
 * @Author: dvlproad
 * @Date: 2024-05-28 11:05:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 11:08:16
 * @Description: 用户缓存协议
 */
import '../../user/user_base_model.dart';

abstract class UserCacheProtocal<T extends UserBaseModel> {
  /// 缓存数据的编解码
  T fromUserCacheJson(Map<String, dynamic> cacheJson);
  Map<String, dynamic> toCacheJson(T model);
}
