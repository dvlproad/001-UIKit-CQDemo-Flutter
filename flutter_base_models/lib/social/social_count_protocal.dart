/*
 * @Author: dvlproad
 * @Date: 2024-03-22 10:42:22
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-17 13:10:06
 * @Description: 
 */

// 点赞
import './enum_like_status.dart';

class SocialLikeProtocal {
  // 不加 final ：因为操作的时候需要本地修改
  LikeStatus likeType; // 点赞类型
  int likeCount;
  SocialLikeProtocal({
    required this.likeType,
    required this.likeCount,
  });
}

// 评论
class SocialCommentProtocal {
  // 不加 final ：因为操作的时候需要本地修改
  int commentCount;
  SocialCommentProtocal({
    required this.commentCount,
  });
}

// 分享
class SocialShareProtocal {
  final int shareCount;
  SocialShareProtocal({
    required this.shareCount,
  });
}
