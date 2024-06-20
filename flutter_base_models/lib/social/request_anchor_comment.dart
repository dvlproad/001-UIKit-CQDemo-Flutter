import 'dart:math';

import '../user/user_base_model.dart';
import './base_comment_model.dart';

class CommentAnchorModel {
  final int index;
  final int count;

  CommentAnchorModel({
    required this.index, // 评论所在的列表索引页
    this.count = 0, // 该种类评论的条数
  });
}

class CommentsResultInfo<TComment> {
  final int totalCommentCount;
  final List<TComment> commentModels;
  final int hopeCommentPageSize;

  final List<CommentAnchorModel>? targetCommentAnchorModels;

  CommentsResultInfo({
    required this.totalCommentCount,
    required this.commentModels,
    required this.hopeCommentPageSize, // 此次请求希望获取的评论数
    this.targetCommentAnchorModels,
  });
}

/// 获取指定范围的所有 comments ，
/// 请求锚点 获取到指定评论锚点的所有评论和回复（如果找到的评论有回复）
abstract class CommentRequestAnchorInstance<TUser extends UserBaseModel,
    TComment extends BaseCommentModel<TUser, TComment>> {
  /// 根据指定评论id 获取其所在的位置（常用于：定位滚到到指定评论）
  Future<List<CommentAnchorModel>?> requestCommentAnchorPoint(String commentId);

  /// 从头请求指定个数的一层评论（常用于：定位滚到到指定评论）
  Future<CommentsResultInfo<TComment>?> requestCommentModels_untilCommentSize({
    required String bizId,
    required int commentPageSize,
  });

  /// 请求指定评论下的回复（常用于：定位滚到到指定评论）
  Future<List<TComment>?> requestReplyModelsForComment({
    required TComment comment,
    required int replyPageSize,
  });

  // ignore: non_constant_identifier_names
  /// 获取指定范围的所有 comments ，
  Future<CommentsResultInfo<TComment>?> requestCommentModels_untilCommentId({
    required String bizId,
    required String commentId,
  }) async {
    // commentId = "test"; // CQTODO: 测试代码
    List<CommentAnchorModel>? targetCommentAnchorModels;
    int _commentIdInRootIndex = -1; // 该评论在第一层的位置
    int _commentIdInReplyIndex = -1; // 该评论在第二层的位置
    if (commentId.isNotEmpty) {
      targetCommentAnchorModels = await requestCommentAnchorPoint(commentId);
      if (targetCommentAnchorModels != null) {
        if (targetCommentAnchorModels.isNotEmpty) {
          _commentIdInRootIndex = targetCommentAnchorModels[0].index;
        }
        if (targetCommentAnchorModels.length >= 2) {
          _commentIdInReplyIndex = targetCommentAnchorModels[1].index;
        }
      }
    }
    int commentPageSize = max(_commentIdInRootIndex + 1, 20);

    CommentsResultInfo<TComment>? commentsResultInfo =
        await requestCommentModels_untilCommentSize(
      bizId: bizId,
      commentPageSize: commentPageSize,
    );
    if (commentsResultInfo == null) {
      return null;
    }

    List<TComment> commentModels = commentsResultInfo.commentModels;
    for (int i = 0; i < commentModels.length; i++) {
      TComment comment = commentModels[i];
      if (commentId == comment.id) {
        _prefectCommentWithReplies(
          comment,
          commentIdInReplyIndex: _commentIdInReplyIndex,
        );
      }

      commentModels.add(comment);
    }

    return CommentsResultInfo(
      totalCommentCount: commentsResultInfo.totalCommentCount,
      commentModels: commentModels,
      hopeCommentPageSize: commentPageSize,
      targetCommentAnchorModels: targetCommentAnchorModels,
    );
  }

  void _prefectCommentWithReplies(
    // 通过评论列表的请求得到：传入 commentId => 得到 comments
    TComment maybeIncompleteComment, {
    // 通过 commentId 的锚点请求得到：传入 commentId => 得到 commentIdInReplyIndex 等
    required int commentIdInReplyIndex,
  }) async {
    if (commentIdInReplyIndex == -1) {
      maybeIncompleteComment.replyPageIndex = 0;
      // maybeIncompleteComment.replyHasMore = false;
      return;
    }

    int hasGetCommentReplyCount = 0;
    if (maybeIncompleteComment.replyModels != null) {
      hasGetCommentReplyCount = maybeIncompleteComment.replyModels!.length;
    }

    if (hasGetCommentReplyCount >= commentIdInReplyIndex + 1) {
      maybeIncompleteComment.replyPageIndex = 1;
      // maybeIncompleteComment.replyHasMore = false;
      return;
    }

    // 如果不够，🈶需要跳转的话，则需要补充请求到至少 reply 的那条
    List<TComment>? newReplyArray = await requestReplyModelsForComment(
      comment: maybeIncompleteComment,
      replyPageSize: max(commentIdInReplyIndex + 1, 20),
    );
    if (newReplyArray == null) {
      maybeIncompleteComment.replyPageIndex = 1;
      // maybeIncompleteComment.replyHasMore = true; // 请求失败，表示还有更多信息
      return;
    }
    maybeIncompleteComment.replyPageIndex = 2;
    // maybeIncompleteComment.replyHasMore = false;
    maybeIncompleteComment.replyModels = newReplyArray;
  }
}
