/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:13
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-03-31 20:51:44
 * @Description: 
 */
import 'package:flutter/material.dart';

class VideoInputPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("解析输入", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 输入框
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "粘贴 TikTok 视频链接...",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.paste, color: Colors.green),
                    onPressed: () {
                      // 这里可以加粘贴功能
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // 按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // 解析视频逻辑
                },
                child: Text("获取视频", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
