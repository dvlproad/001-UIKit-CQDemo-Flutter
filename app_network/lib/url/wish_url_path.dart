/*
 * @Author: dvlproad
 * @Date: 2022-04-22 17:42:09
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-20 18:57:38
 * @Description: 愿望单接口
 */
// import './app_url_path.dart';

class WishUrlPath {
// extension Wish on AppUrlPath {

  static String wishCreatedPermissions = "wish/wishPermissions";

  static String wishCreate = "wish/create"; //创建清单
  static String wishUpdate = "wish/update"; //更新清单
  static String wishGetDetail = "wish/getDetail"; //清单详情
  static String getWishDetail = "wish/getWishDetail"; //获取愿望单详情（无商品信息）
  static String getWishItems = "wish/getWishItems"; //获取愿望单商品
  static String showOtherWishGoods = "wish/showOtherWishGoods"; //是否展示其他愿望单商品

  static String getTagListAll = "wish/tag/listTagsWithTree"; //获取所有标签

  // 愿望单创建增删改
  static String wishClear = "wish/clear"; //愿望屋-清空愿望单
  static String wishDeleteWish = "/wish/deleteWish"; //删除愿望单
  static String wishAddWishItems = "wish/addWishItems"; //愿望屋-添加商品
  static String wishDeleteWishItems = "/wish/deleteWishItems"; //删除商品

  // 愿望单详情操作
  static String wishTop = "/wish/wishTop"; //心愿置顶
  static String wishLike = "/wish/like"; //心愿点赞
  static String wishCancelLike = "/wish/cancelLike"; //心愿取消点赞

  static String wishUpdateWishSort = "wish/updateWishSort"; //愿望屋-更新心愿单排序
  static String wishChangeShowProgress =
      "wish/changeShowProgress"; //愿望屋-隐藏/公开助力榜单
  static String wishChangeShowType = "wish/changeShowType"; //愿望屋-修改展示状态

  static String listRecommendWish = "/wish/recommendWishList"; //获取推荐心愿列表
  static String listWishSelectionInfo = "wish/listWishSelectionInfo"; //获取百愿精选

  static String listWatchWish = "wish/listWatchWish"; //获取好友愿望清单

  static String newRecommendWishList =
      "/wish/newRecommendWishList"; //推荐愿望单列表(新)

  //愿望单详情评论
  static String commentList = "front-node/comment/list"; //愿望单评论列表
  static String wishComment = "front-node/comment/do-comment"; //愿望单评论
  static String wishCommentDelete = "front-node/comment/do-delete"; //愿望单删除
  static String wishCommentCollect = "front-node/comment/do-collect"; //愿望单收藏
  static String wishCommentUpDown =
      "front-node/comment/do-up-or-down"; //愿望单点赞点踩
  static String wishReplyList = "front-node/comment/reply-list"; //愿望回复列表
  static String commentAnchorPoint = "front-node/comment/anchor-point"; //获取评论所在位置
  static String wishCostSendMsg = "imCustomer/sendMsg"; //打赏后给用户发im消息

}
