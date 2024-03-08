/*
 * @Author: dvlproad
 * @Date: 2024-01-26 15:29:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-08 17:24:37
 * @Description: 
 */
library flutter_share_kit;

export 'package:fluwx/src/wechat_file.dart' show WeChatImage;

// 分享各个平台的方法
export 'src/share_util/wechat_share_util.dart'; // 微信
export 'src/share_util/poster_share_util.dart'; // 海报
export 'src/share_util/copylink_share_util.dart'; // 复制链接

// 弹出分享面板
export 'src/share_dialog_util.dart';
export 'src/widget/share_action_model.dart';

// 海报
export './src/widget/base_poster_widget.dart';

// test
export './test/ts_share_home_page.dart';
export './test/ts_poster_custompainter.dart';
