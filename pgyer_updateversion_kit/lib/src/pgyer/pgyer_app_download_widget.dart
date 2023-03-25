// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-05-07 10:54:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 20:38:39
 * @Description: app几个环境的下载页罗列
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import './pgyer_env_util.dart';

class PgyerAppDownloadWidget extends StatefulWidget {
  const PgyerAppDownloadWidget({Key? key}) : super(key: key);

  @override
  State<PgyerAppDownloadWidget> createState() => _PgyerAppDownloadWidgetState();
}

class _PgyerAppDownloadWidgetState extends State<PgyerAppDownloadWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff0f0f0),
      child: Column(
        children: [
          ImageTitleTextValueCell(
            height: 40,
            title: "app下载页(内测)",
            textValue: '',
            arrowImageType: TableViewCellArrowImageType.none,
          ),
          _app_downloadpage_cell(UpdateAppType.develop1),
          _app_downloadpage_cell(UpdateAppType.preproduct),
          _app_downloadpage_cell(UpdateAppType.product),
        ],
      ),
    );
  }

  Widget _app_downloadpage_cell(UpdateAppType pgyerAppType) {
    PgyerAppBean pgyerAppBean =
        PgyerEnvUtil.diffPackageBeanByType(pgyerAppType);

    String downloadUrl = pgyerAppBean.downloadUrl;
    return ImageTitleTextValueCell(
      height: 40,
      leftMaxWidth: 80,
      title: "${pgyerAppBean.des}：",
      textValue: downloadUrl,
      textValueFontSize: 13,
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
