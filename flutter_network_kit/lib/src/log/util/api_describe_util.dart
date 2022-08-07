import 'package:meta/meta.dart';
import '../bean/api_describe_bean.dart';
import '../bean/api_user_bean.dart';

class ApiDescirbeUtil {
  static ApiPeopleBean qian = ApiPeopleBean(pid: 'lichaoqian');
  static ApiPeopleBean linzehua = ApiPeopleBean(pid: 'linzehua');
  static ApiPeopleBean chenmingxi = ApiPeopleBean(pid: 'chenmingxi');
  static ApiPeopleBean xuejingpeng = ApiPeopleBean(pid: 'xuejingpeng');
  static ApiPeopleBean xuyuecheng = ApiPeopleBean(pid: 'xuyuecheng');

  /// 根据 api path 找到对应的接口描述信息(含 接口描述、api负责人、app负责人等)
  static ApiErrorDesBean apiDescriptionBeanByApiPath(String apiPath) {
    if (apiPath.startsWith("/") == false) {
      apiPath = "/$apiPath"; // 先加斜杠，为了方便后面的计算
    }

    String specialApiPath = apiPath;
    String moduleDes = '';
    List<String> apiMentioned = [];
    List<ApiPeopleBean> appMentionedBeans = [];
    if (specialApiPath.startsWith('/login')) {
      moduleDes = '登录';
      apiMentioned = ['linweifeng', 'zhengkaifa', 'wuxiangxin', 'huaronghao'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/aa')) {
      moduleDes = 'AA送礼相关接口 Wish Gift Controller';
      apiMentioned = ['zhengzihong', 'chenlongcheng'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/member/')) {
      moduleDes = '会员模块 Member Controller';
      apiMentioned = ['liujiepeng'];
      appMentionedBeans = [xuejingpeng];
    } else if (specialApiPath.startsWith('/new/member/')) {
      moduleDes = '会员模块-新会员 New Member Controller';
      apiMentioned = ['zhouxusheng', 'zhengzihong'];
      appMentionedBeans = [xuejingpeng];
    } else if (specialApiPath.startsWith('/category/')) {
      moduleDes = '分类商品接口 Category Goods Controller';
      apiMentioned = ['zhengzihong'];
      appMentionedBeans = [xuyuecheng];
    } else if (specialApiPath.startsWith('/product/')) {
      moduleDes = '分类相关接口 Category Controller、商品相关类 Goods Info Controller';
      apiMentioned = ['zhengzihong', 'chenlongcheng'];
      appMentionedBeans = [chenmingxi];
    } else if (specialApiPath.startsWith('/user/')) {
      if (specialApiPath.startsWith('/user/activityCollect/')) {
        moduleDes = '活动收藏模块 User Activity Collect Controller';
        apiMentioned = ['zhengzihong'];
        appMentionedBeans = [chenmingxi];
      } else if (specialApiPath.startsWith('/user/account/')) {
        moduleDes = '用户账户模块 Account Info Controller';
        apiMentioned = ['wangxiaobin'];
        appMentionedBeans = [linzehua];
      } else {
        moduleDes =
            '商品收藏、店铺收藏关注相关接口 User Collect Controller、用户足迹相关接口 User Controller';
        apiMentioned = ['zhouxusheng'];
        appMentionedBeans = [chenmingxi];
      }
    } else if (specialApiPath.startsWith('/marketing/')) {
      moduleDes = '大转盘 Lottery Controller、活动相关接口 Marketing Controller';
      apiMentioned = ['zhuangjianhui', 'huaronghao'];
      appMentionedBeans = [xuyuecheng];
    } else if (specialApiPath.startsWith('/wechat/')) {
      moduleDes = '微信相关接口 Wechat Controller';
      apiMentioned = ['huaronghao'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/wish/') ||
        specialApiPath.startsWith('/wishGiftOrder/')) {
      moduleDes =
          '心愿相关接口 One Wish Controller、愿望单 Wish Controller、愿望标签W ish Tag Controller、愿望礼物订单相关接口 Wish Gift Order Controller';
      apiMentioned = ['chenmingxi', 'liujiepeng'];
      appMentionedBeans = [xuejingpeng];
    } else if (specialApiPath.startsWith('/recommend/')) {
      moduleDes = '推荐接口 Recommend Controller';
      apiMentioned = ['liujiepeng'];
      appMentionedBeans = [chenmingxi];
    } else if (specialApiPath.startsWith('/search/')) {
      moduleDes = '搜索接口 Search Controller';
      apiMentioned = ['zhengzihong', 'linweiping'];
      appMentionedBeans = [chenmingxi];
    } else if (specialApiPath.startsWith('/pay/')) {
      moduleDes = '支付相关接口 Pay Controller';
      apiMentioned = ['huaronghao'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/billboard/')) {
      moduleDes = '榜单接口 Billboard Controller';
      apiMentioned = ['zhengzihong'];
      appMentionedBeans = [chenmingxi];
    } else if (specialApiPath.startsWith('/order/')) {
      moduleDes = '正向订单，下单 订单查询等 Order Controller';
      apiMentioned = ['linweifeng']; //??
      appMentionedBeans = [xuejingpeng];
    } else if (specialApiPath.startsWith('/message/')) {
      moduleDes = '消息服务 Message Controller';
      apiMentioned = ['huaronghao'];
      appMentionedBeans = [linzehua, chenmingxi];
    } else if (specialApiPath.startsWith('/guessWish/')) {
      moduleDes = '猜愿望 Guess Game Controller';
      apiMentioned = ['zhengzihong'];
      appMentionedBeans = [chenmingxi, xuejingpeng];
    } else if (specialApiPath.startsWith('/userUpDraw/')) {
      moduleDes = '用户升级会员抽奖相关接口 User Up Draw Controller';
      apiMentioned = ['xujinbiao'];
      appMentionedBeans = [xuejingpeng];
    } else if (specialApiPath.startsWith('/userInvite/')) {
      moduleDes = '用户邀请相关接口 User Invite Controller';
      apiMentioned = ['xujinbiao'];
      appMentionedBeans = [chenmingxi, xuejingpeng]; // search
    } else if (specialApiPath.startsWith('/wishLotteryActivity/')) {
      moduleDes = '百愿清单活动 Wish Lottery Activity Controller';
      apiMentioned = ['zhuangjianhui'];
      appMentionedBeans = [xuyuecheng];
    } else if (specialApiPath.startsWith('/gift/')) {
      moduleDes = '礼物相关接口 Gift Info Controller';
      apiMentioned = ['zhuangjianhui'];
      appMentionedBeans = [chenmingxi, linzehua];
    } else if (specialApiPath.startsWith('/social/')) {
      moduleDes = '社交好友相关接口 Social Controller';
      apiMentioned = ['liujiepeng'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/login/')) {
      moduleDes = '统一登录相关接口 Login Controller';
      apiMentioned = ['zhouxusheng', 'wangxiaobin'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/home/')) {
      moduleDes = '获取缓存版本信息，首页信息，首页爆品列表信息 Home Controller';
      apiMentioned = ['zhengzihong'];
      appMentionedBeans = [chenmingxi];
    } else if (specialApiPath.startsWith('/goodsComment/')) {
      moduleDes = '订单商品评论 Goods Comment Controller';
      apiMentioned = ['xujinbiao'];
      appMentionedBeans = [xuejingpeng];
    } else if (specialApiPath.startsWith('/account/')) {
      moduleDes = '账户服务 Account Wallet Controller';
      apiMentioned = ['tangqiaojian', 'zhuangjianhui', 'zhengkaifa'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/give/')) {
      moduleDes = '送TA礼物 Give Controller';
      apiMentioned = ['liujiepeng'];
      appMentionedBeans = [linzehua];
    } else if (specialApiPath.startsWith('/letter/')) {
      moduleDes = '邀请函相关接口 Letter Info Controller';
      apiMentioned = ['zhengzihong', 'zhuangjianhui'];
      appMentionedBeans = [chenmingxi];
    } else if (specialApiPath.startsWith('/config/')) {
      moduleDes = '首页';
      apiMentioned = ['zhengzihong'];
      appMentionedBeans = [chenmingxi];
    } else {
      moduleDes = '其他';
      apiMentioned = [];
      appMentionedBeans = [];
    }

    ApiErrorDesBean apiErrorDesBean = ApiErrorDesBean(
      des: moduleDes,
      apiApiPeoples: apiMentioned,
      appApiPeoples: appMentionedBeans,
    );
    return apiErrorDesBean;
  }
}
