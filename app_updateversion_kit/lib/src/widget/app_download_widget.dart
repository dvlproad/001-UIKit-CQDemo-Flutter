// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-05-07 10:54:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-26 01:23:12
 * @Description: app几个环境的下载页罗列
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

class AppDownloadWidget extends StatefulWidget {
  AppDownloadWidget({Key? key}) : super(key: key);

  @override
  State<AppDownloadWidget> createState() => _AppDownloadWidgetState();
}

class _AppDownloadWidgetState extends State<AppDownloadWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff0f0f0),
      child: Column(
        children: [
          ImageTitleTextValueCell(
            height: 40,
            title: "app下载页(其他发布平台)",
            textValue: '',
            arrowImageType: TableViewCellArrowImageType.none,
          ),
          _app_downloadpage_cell(UpdateAppType.product),
          // 请补充 app 内测版本的下载页
        ],
      ),
    );
  }

  Widget _app_downloadpage_cell(UpdateAppType packageEnvType) {
    String title = '';
    String downloadUrl = '';

    title = '官网';
    downloadUrl = 'http://h5.yuanwangwu.com/pages-h5/share/download-app';

    return ImageTitleTextValueCell(
      height: 40,
      leftMaxWidth: 80,
      title: "$title：",
      textValue: downloadUrl,
      textValueFontSize: 13,
      textValueMaxLines: 2,
      onTap: () async {
        bool goSuccess = await _launcherAppDownloadUrl(downloadUrl);
        if (goSuccess != true) {
          ToastUtil.showMessage("Error:无法打开网页$downloadUrl");
        }
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: downloadUrl));
        ToastUtil.showMessage('app下载页地址拷贝成功');
      },
    );
  }

  static Future<bool> _launcherAppDownloadUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    } else {
      return false;
    }
  }
}
