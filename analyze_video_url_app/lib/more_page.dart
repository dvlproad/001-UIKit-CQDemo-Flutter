/*
 * @Author: dvlproad
 * @Date: 2025-03-31 21:22:07
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-03-31 21:45:52
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_analyze_video_url/cq_video_url_analyze_tiktok.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("更多", style: TextStyle(color: Colors.black)),
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
              "设置",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),

          // 打开设置按钮
          InkWell(
            onTap: _openSettings,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: double.infinity,
              color: Colors.white,
              child: Text(
                "打开设置",
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
  void _openSettings() async {
    final shortenedUrl = "https://www.tiktok.com/t/ZT2mkNaFw/";
    CQVideoUrlAnalyzeTiktok.expandShortenedUrl(shortenedUrl);
    return;

    final url = "App-Prefs:root=General";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("无法打开设置");
    }
  }
}
