import 'dart:convert';

import 'package:flutter/cupertino.dart';

class I18nUtils {
  static I18nUtils? _instance;
  I18nUtils._internal(BuildContext context) {
    _init(context);
  }
  factory I18nUtils(BuildContext context) {
    _instance ??= I18nUtils._internal(context);
    return _instance!;
  }
  Map<String, dynamic> zhMap = {};
  Map zhMapRevert = {};
  RegExp expForParameterOut = RegExp(r"{{[^]+}}");
  RegExp expForParameter = RegExp(r"(?<=\{{)[^}]*(?=\}})");
  late final t;

  void _init(BuildContext context) {
    // try {
    //   t = getI18NBuild(context);
    // } catch (e) {
    //   t = AppLocale.zh.build();
    //   print("errorInLanguage ${e.toString()}");
    // }
    // zhMap = jsonDecode(zhJson);
    // zhMapRevert = revertMap(zhMap);
  }

  String imt(String value) {
    String translatedValue = value;
    return translatedValue;
  }

  final zhJson =
      '''{"k_1yemzyd":"收到一条消息","k_0ylosxn":"自定义消息","k_13sajrj":"表情消息","k_13sjeb7":"文件消息","k_0yd2ft8":"群提示消息","k_13s7mxn":"图片消息","k_13satlt":"位置消息","k_00bbtsx":"合并转发消息","k_13sqwu4":"语音消息","k_13sqjjp":"视频消息","k_1fdhj9g":"该版本不支持此消息","k_06pujtm":"同意任何用户添加好友","k_0gyhkp5":"需要验证","k_121ruco":"拒绝任何人加好友","k_05nspni":"自定义字段","k_03fchyy":"群头像","k_03i9mfe":"群简介","k_03agq58":"群名称","k_039xqny":"群通知","k_003tr0a":"群主","k_03iqsh4":"\$s为 ","k_191t5n4":"\$opUserNickName修改","k_1pg6aoj":"\$opUserNickName退出群聊","k_1f6zt3v":"邀请\$invitedMemberString加入群组","k_0y7zd07":"将\$invitedMemberString踢出群组","k_1d5mshh":"用户\$joinedMemberString加入了群聊","k_002wddw":"禁言","k_0got6f7":"解除禁言","k_0yenqf0":"\$userName 被","k_0spotql":"将 \$adminMember 设置为管理员","k_0pg5zzj":"系统消息 \$operationType","k_0ohzb9l":"通话时间：\$callTime","k_1uaqed6":"[自定义]","k_0z2z7rx":"[语音]","k_0y39ngu":"[表情]","k_1c7z88n":"[文件] \$fileName","k_0y1a2my":"[图片]","k_0z4fib8":"[视频]","k_0y24mcg":"[位置]","k_0pewpd1":"[聊天记录]","k_13s8d9p":"未知消息","k_1c3us5n":"当前群组不支持@全体成员","k_11k579v":"发言中有非法语句","k_003qkx2":"日历","k_003n2pz":"相机","k_03idjo0":"联系人","k_003ltgm":"位置","k_02k3k86":"麦克风","k_003pm7l":"相册","k_15ao57x":"相册写入","k_164m3jd":"本地存储","k_0qba4ns":"想访问您的\$yoursItem","k_03r6qyx":"我们需要您的同意才能获取信息","k_02noktt":"不允许","k_00043x4":"好","k_003qzac":"昨天","k_003r39d":"前天","k_03fqp9o":"星期天","k_03ibg5h":"星期一","k_03i7hu1":"星期二","k_03iaiks":"星期三","k_03el9pa":"星期四","k_03i7ok1":"星期五","k_03efxyg":"星期六","k_0oozw9x":"\$diffMinutes 分钟前","k_003q7ba":"下午","k_003q7bb":"上午","k_003pu3h":"现在","k_13hzn00":"昨天 \$yesterday","k_0n9pyxz":"用户不存在","k_1bjwemh":"搜索用户 ID","k_003kv3v":"搜索","k_02owlq8":"我的用户ID: \$userID","k_1wu8h4x":"我是: \$showName","k_16758qw":"添加好友","k_1shx4d9":"个性签名: \$selfSignature","k_0i553x0":"填写验证信息","k_031ocwx":"请填写备注和分组","k_003ojje":"备注","k_003lsav":"分组","k_167bdvq":"我的好友","k_156b4ut":"好友申请已发送","k_002r305":"发送","k_03gu05e":"聊天室","k_03b4f3p":"会议群","k_03avj1p":"公开群","k_03asq2g":"工作群","k_03b3hbi":"未知群","k_1loix7s":"群类型: \$groupType","k_1lqbsib":"该群聊不存在","k_03h153m":"搜索群ID","k_0oxak3r":"群申请已发送","k_002rflt":"删除","k_1don84v":"无法定位到原消息","k_003q5fi":"复制","k_003prq0":"转发","k_002r1h2":"多选","k_003j708":"引用","k_003pqpr":"撤回","k_03ezhho":"已复制","k_11ctfsz":"暂未实现","k_1hbjg5g":"[群系统消息]","k_03tvswb":"[未知消息]","k_155cj23":"您撤回了一条消息，","k_0gapun3":"重新编辑","k_1uh417q":"\$displayName撤回了一条消息","k_1aszp2k":"您确定要重发这条消息么？","k_003rzap":"确定","k_003nevv":"取消","k_0003z7x":"您","k_002wfe4":"已读","k_002wjlg":"未读","k_0h1ygf8":"发起通话","k_0h169j0":"取消通话","k_0h13jjk":"接受通话","k_0h19hfx":"拒绝通话","k_0obi9lh":"超时未接听","k_0y9u662":"“\$appName”暂不可以打开此类文件，你可以使用其他应用打开并预览","k_001nmhu":"用其他应用打开","k_1ht1b80":"正在接收中","k_105682d":"图片加载失败","k_0pytyeu":"图片保存成功","k_0akceel":"图片保存失败","k_003rk1s":"保存","k_04a0awq":"[语音消息]","k_105c3y3":"视频加载失败","k_176rzr7":"聊天记录","k_0d5z4m5":"选择提醒人","k_003ngex":"完成","k_1665ltg":"发起呼叫","k_003n8b0":"拍摄","k_003kthh":"照片","k_003tnp0":"文件","k_0jhdhtp":"发送失败,视频不能大于100MB","k_119ucng":"图片不能为空","k_0w9x8gw":"选择成功\$successPath","k_13dsw4l":"松开取消","k_0am7r68":"手指上滑，取消发送","k_15jl6qw":"说话时间太短!","k_0gx7vl6":"按住说话","k_15dlafd":"逐条转发","k_15dryxy":"合并转发","k_1eyhieh":"确定删除已选消息","k_17fmlyf":"清除聊天","k_0dhesoz":"取消置顶","k_002sk7x":"置顶","k_003ll77":"草稿","k_03icaxo":"自定义","k_1969986":"[语音通话]：\$callingLastMsgShow","k_1960dlr":"[视频通话]：\$callingLastMsgShow","k_1np495n":"\$messageString[有人@我]","k_1m797yi":"\$messageString[@所有人]","k_1uaov41":"查找聊天内容","k_003kfai":"未知","k_13dq4an":"自动审批","k_0l13cde":"管理员审批","k_11y8c6a":"禁止加群","k_1kvyskd":"无网络连接，无法修改","k_16payqf":"加群方式","k_0vzvn8r":"修改群名称","k_038lh6u":"群管理","k_0k5wyiy":"设置管理员","k_0goiuwk":"全员禁言","k_1g889xx":"全员禁言开启后，只允许群主和管理员发言。","k_0wlrefq":"添加需要禁言的群成员","k_0goox5g":"设置禁言","k_08daijh":"成功取消管理员身份","k_0bxm97s":"管理员 (\$adminNum/10)","k_0k5u935":"添加管理员","k_03enyx5":"群成员","k_0jayw3z":"群成员(\$groupMemberNum人)","k_0h1svv1":"删除群成员","k_0h1g636":"添加群成员","k_0uj7208":"无网络连接，无法查看群成员","k_01yfa4o":"\$memberCount人","k_0hpukyx":"查看更多群成员","k_0qtsar0":"消息免打扰","k_0ef2a12":"修改我的群昵称","k_1aajych":"仅限中文、字母、数字和下划线，2-20个字","k_137pab5":"我的群昵称","k_0ivim6d":"暂无群公告","k_03eq6cn":"群公告","k_002vxya":"编辑","k_17fpl3y":"置顶聊天","k_03es1ox":"群类型","k_003mz1i":"同意","k_003lpre":"拒绝","k_003qk66":"头像","k_003lhvk":"昵称","k_003ps50":"账号","k_15lx52z":"个性签名","k_003qgkp":"性别","k_003m6hr":"生日","k_0003v6a":"男","k_00043x2":"女","k_03bcjkv":"未设置","k_11s0gdz":"修改昵称","k_0p3j4sd":"仅限中字、字母、数字和下划线","k_15lyvdt":"修改签名","k_0vylzjp":"这个人很懒，什么也没写","k_1hs7ese":"等上线再改这个","k_03exjk7":"备注名","k_0s3skfd":"加入黑名单","k_0p3b31s":"修改备注名","k_0003y9x":"无","k_11zgnfs":"个人资料","k_03xd79d":"个性签名: \$signature","k_1tez2xl":"暂无个性签名","k_118prbn":"全局搜索","k_1m9dftc":"全部联系人","k_0em4gyz":"全部群聊","k_002twmj":"群聊","k_09kga0d":"更多聊天记录","k_1ui5lzi":"\$count条相关聊天记录","k_09khmso":"相关聊天记录","k_1kevf4k":"与\$receiver的聊天记录","k_0vjj2kp":"群聊的聊天记录","k_003n2rp":"选择","k_03ignw6":"所有人","k_03erpei":"管理员","k_0qi9tno":"群主、管理员","k_1m9exwh":"最近联系人","k_119nwqr":"输入不能为空","k_0pzwbmg":"视频保存成功","k_0aktupv":"视频保存失败"}''';
}
