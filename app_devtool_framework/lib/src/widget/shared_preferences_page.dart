/*
 * @Author: dvlproad
 * @Date: 2022-05-07 10:54:27
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-16 15:39:15
 * @Description: app几个环境的下载页罗列
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class SharedPreferencesPage extends StatefulWidget {
  SharedPreferencesPage({Key? key}) : super(key: key);

  @override
  State<SharedPreferencesPage> createState() => _SharedPreferencesPageState();
}

class _SharedPreferencesPageState extends State<SharedPreferencesPage> {
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();

    getCount();
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = [];
    if (_prefs != null) {
      Set<String> keySet = _prefs!.getKeys();
      for (String key in keySet) {
        keys.add(key);
      }
    }

    int keyCount = keys.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences'),
      ),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: Column(
          children: [
            ImageTitleTextValueCell(
              height: 40,
              title: "SharedPreferences缓存",
              textValue: '',
              arrowImageType: TableViewCellArrowImageType.none,
            ),
            ImageTitleTextValueCell(
              height: 40,
              rightMaxWidth: 100,
              title: '全部清空',
              textValue: '',
              textValueFontSize: 13,
              onTap: () async {
                //
              },
              onLongPress: () async {
                if (_prefs == null) {
                  return;
                }
                bool clearSuccess = await _prefs!.clear();
                ToastUtil.showMessage("清除数据缓存${clearSuccess ? '成功' : '失败'}");
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: keyCount,
                itemBuilder: (context, index) {
                  String key = keys[index];
                  String keyValue = '清理'; // _prefs.get(key);
                  return ImageTitleTextValueCell(
                    height: 40,
                    rightMaxWidth: 30,
                    title: key,
                    textValue: keyValue,
                    textValueFontSize: 13,
                    onTap: () async {
                      List<String> unableClearKeys = [];
                      if (unableClearKeys.contains(key)) {
                        ToastUtil.showMessage("$key不允许清除，会影响使用");
                        return;
                      }

                      if (_prefs == null) {
                        return;
                      }
                      bool clearSuccess = await _prefs!.remove(key);
                      ToastUtil.showMessage(
                          "清除$key缓存${clearSuccess ? '成功' : '失败'}");
                      setState(() {});
                    },
                    onLongPress: () async {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCount() async {
    _prefs = await SharedPreferences.getInstance();

    // print('=== documents DioCache.db 大小：${_documentsSizeString}');
    if (mounted) {
      setState(() {});
    }
  }
}
