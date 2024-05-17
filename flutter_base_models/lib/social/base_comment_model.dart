/*
 * @Author: dvlproad
 * @Date: 2024-03-22 16:35:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-16 15:27:13
 * @Description: 
 */

import '../user/user_base_model.dart';
import './social_count_protocal.dart';
import './enum_like_status.dart';

class AppReplyInfoProctocal {
  final String parentId; // 父级id
  final String rootId; // 根级id
  AppReplyInfoProctocal({required this.parentId, required this.rootId});
}

class AppReplyToModle {
  final String userId;
  final int parentId; // 父级id: 回复时候父级id即自身
  final int rootId; // 根级id: 回复时候根级id都一样
  AppReplyToModle({
    required this.userId,
    required this.parentId,
    required this.rootId,
  });
}

class BaseCommentModel<TUser extends UserBaseModel>
    implements SocialLikeProtocal, SocialCommentProtocal {
  final int levelIndex; // 层数索引
  TUser sender; // 发布人 信息(不能final，因为发布时候后台一般不返回数据，所以需要自己补充)
  TUser? receiver; // 接受者 信息(不能final，因为发布时候后台一般不返回数据，所以需要自己补充)
  final String? sendTimeString; // 评论时间
  final String id;
  final AppReplyToModle infoForReply; // 如果点击此条，进行回复的数据
  String content; // 评论内容
  final List<String>? atUserIds;

  @override
  int commentCount;

  @override
  LikeStatus likeType; // 点赞类型
  @override
  int likeCount;

  BaseCommentModel({
    required this.levelIndex,
    required this.sender,
    this.receiver,
    this.sendTimeString,
    required this.id,
    required this.infoForReply,
    required this.content,
    this.atUserIds,
    this.commentCount = 0,
    this.likeType = LikeStatus.unknow,
    this.likeCount = 0,
  });
}
