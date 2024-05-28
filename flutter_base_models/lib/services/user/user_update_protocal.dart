/*
 * @Author: dvlproad
 * @Date: 2024-05-28 11:06:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 11:19:52
 * @Description: 用户数据创建及更新协议
 */
import '../../user/user_base_model.dart';

abstract class UserUpdateProtocal<T extends UserBaseModel> {
  /// 根据登录时候返回的用户信息创建用户模型
  T fromUserLoginJson(Map<String, dynamic> loginJson);

  /// 根据获取的用户详细信息更新用户模型（特别注意：不能无脑进行覆盖, authToken 没必要更新,应保留使用登录接口返回的值，避免详细信息里不返回、返回空、返回异常的不同值)
  void updateUserWithUserDetailJson(Map<String, dynamic> detailJson);
}
