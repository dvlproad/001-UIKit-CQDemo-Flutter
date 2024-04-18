/*
 * @Author: dvlproad
 * @Date: 2024-01-26 15:29:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-13 16:23:10
 * @Description: 
 */
library flutter_share_kit;

export 'package:fluwx/src/wechat_file.dart' show WeChatImage;
export 'package:fluwx/src/wechat_enums.dart' show WeChatScene;

// 分享各个平台的方法
export 'src/base_share_singleton.dart';
export 'src/share_util/wechat_share_util.dart'; // 微信
export 'src/share_util/poster_share_util.dart'; // 海报
export 'src/share_util/copylink_share_util.dart'; // 复制链接

// 弹出分享面板
export 'src/widget/share_dialog_widget.dart';
export 'src/widget/share_action_model.dart';

// 海报
export './src/widget/poster_withbutton_page.dart';
export './src/widget/base_poster_widget.dart';
export './src/widget/poster_content_widget.dart' show PosterDataModel;

// test
export './test/ts_share_home_page.dart';
export './test/ts_share_home_buttons.dart';
export './test/ts_poster_custompainter.dart';
