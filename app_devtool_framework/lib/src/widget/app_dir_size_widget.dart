/*
 * @Author: dvlproad
 * @Date: 2022-05-07 10:54:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-30 18:08:18
 * @Description: app几个环境的下载页罗列
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:app_environment/src/init/main_diff_util.dart';

import './clear_cache_util.dart';

enum AppDirOrFileType {
  libraryCaches,
  documents,
}

class AppDirSizeWidget extends StatefulWidget {
  AppDirSizeWidget({Key key}) : super(key: key);

  @override
  State<AppDirSizeWidget> createState() => _AppDirSizeWidgetState();
}

class _AppDirSizeWidgetState extends State<AppDirSizeWidget> {
  @override
  void initState() {
    super.initState();

    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff0f0f0),
      child: Column(
        children: [
          ImageTitleTextValueCell(
            height: 40,
            title: "app各文件大小",
            textValue: '',
            arrowImageType: TableViewCellArrowImageType.none,
          ),
          ImageTitleTextValueCell(
            leftMaxWidth: 120,
            title: 'app沙盒目录',
            textValue: _appPath,
            textValueFontSize: 13,
            textValueMaxLines: 10,
            onTap: () async {
              Clipboard.setData(ClipboardData(text: "$_appPath"));
              ToastUtil.showMessage('app目录拷贝成功');
            },
          ),
          _file_cell("library Caches", _libraryCachesSizeString),
          _file_cell("documents", _documentsSizeString),
          _file_cell("documents DioCache.db", _documentDioCacheFileSizeString),
        ],
      ),
    );
  }

  String _appPath = '';

  String _libraryCachesSizeString = '0';
  String _documentsSizeString = '0';
  String _documentDioCacheFileSizeString = '0';
  void getCount() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    _appPath = tempDir.path;

    _libraryCachesSizeString = await DirSizeUtil.loadLibraryCachesSize();
    // print('=== library Caches 大小：${_libraryCachesSizeString}');
    _documentsSizeString = await DirSizeUtil.loadDocumentsSize();
    // print('=== documents 大小：${_documentsSizeString}');
    _documentDioCacheFileSizeString =
        await DirSizeUtil.getDocumentDioCacheFileSize();
    // print('=== documents DioCache.db 大小：${_documentsSizeString}');
    if (mounted) {
      setState(() {});
    }
  }

  Widget _file_cell(
    String title,
    String textValue, {
    void Function() onLongPress,
  }) {
    return ImageTitleTextValueCell(
      height: 40,
      rightMaxWidth: 100,
      title: title,
      textValue: textValue,
      textValueFontSize: 13,
      onTap: () async {
        Clipboard.setData(ClipboardData(text: "$title:$textValue"));
        ToastUtil.showMessage('app文件大小拷贝成功');
      },
      onLongPress: onLongPress,
    );
  }
}
