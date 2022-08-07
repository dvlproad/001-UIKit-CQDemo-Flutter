/*
 * @Author: dvlproad
 * @Date: 2022-05-07 10:54:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 20:39:01
 * @Description: app几个环境的下载页罗列
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import 'package:pgyer_updateversion_kit/pgyer_updateversion_kit.dart';

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
            title: "app下载页(外测)",
            textValue: '',
            arrowImageType: TableViewCellArrowImageType.none,
          ),
          _app_downloadpage_cell(UpdateAppType.product),
          PgyerAppDownloadWidget(),
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
      title: "${title}：",
      textValue: downloadUrl,
      textValueFontSize: 13,
      textValueMaxLines: 2,
      onTap: () async {
        bool goSuccess = await _launcherAppDownloadUrl(downloadUrl);
        if (goSuccess != true) {
          ToastUtil.showMsg("Error:无法打开网页$downloadUrl", context);
        }
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: downloadUrl));
        ToastUtil.showMessage('app下载页地址拷贝成功');
      },
    );
  }

  static Future<bool> _launcherAppDownloadUrl(String url) async {
    if (url == null) {
      return false;
    }
    if (await canLaunch(url)) {
      return launch(url);
    } else {
      return false;
    }
  }
}
