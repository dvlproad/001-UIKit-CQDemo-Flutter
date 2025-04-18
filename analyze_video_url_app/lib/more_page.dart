/*
 * @Author: dvlproad
 * @Date: 2025-03-31 21:22:07
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-19 01:46:53
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_analyze_video_url/cq_video_url_analyze_tiktok.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_settings/app_settings.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.more,
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分组标题
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              AppLocalizations.of(context)!.settings,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),

          // 打开设置按钮
          InkWell(
            onTap: () => _openSettings(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: double.infinity,
              color: Colors.white,
              child: Text(
                AppLocalizations.of(context)!.openSettings,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200], // 背景颜色
    );
  }

  // 打开系统设置
  void _openSettings(BuildContext context) async {
    try {
      await AppSettings.openAppSettings();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.cannotOpenSettings)),
        );
      }
    }
  }
}
