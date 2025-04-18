/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:13
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-19 01:42:55
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_analyze_video_url/cq_video_url_analyze_tiktok.dart';
import './services/download_manager.dart';
import './tab_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoInputPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.videoInput,
            style: TextStyle(color: Colors.black)),
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
                  hintText: AppLocalizations.of(context)!.pasteTiktokLink,
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
                onPressed: () async {
                  // 显示加载对话框
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // 解析视频逻辑
                  _controller.text =
                      "https://www.tiktok.com/t/ZT2mkNaFw/"; //nezha2 shengaongbao
                  debugPrint("解析视频: ${_controller.text}");
                  String shortenedUrl = _controller.text;
                  CQVideoUrlAnalyzeTiktok.requestUrlFromShortenedUrl(
                    shortenedUrl,
                    CQAnalyzeVideoUrlType.videoWithoutWatermarkHD,
                    success: (expandedUrl, videoId, resultUrl) {
                      // 关闭加载对话框
                      Navigator.pop(context);

                      debugPrint("expandedUrl: $expandedUrl");
                      debugPrint("videoId: $videoId");
                      debugPrint("resultUrl: $resultUrl");

                      // 添加到下载管理器
                      DownloadManager().addDownload(videoId, resultUrl);

                      // 切换到已解析tab页面
                      AppTabController()
                          .switchToTab(1); // 假设ParsedVideosPage是第二个tab（索引为1）
                    },
                    failure: (errorMessage) {
                      // 关闭加载对话框
                      Navigator.pop(context);

                      debugPrint("errorMessage: $errorMessage");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .parsingFailed(errorMessage))),
                      );
                    },
                  );
                  /*
                  final client = HttpClient();
                  client.userAgent =
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64)';

                  try {
                    final request =
                        await client.getUrl(Uri.parse(shortenedUrl));
                    final response = await request.close();
                    if (response.statusCode == 200 &&
                        response.redirects.isNotEmpty) {
                      final redirectUrl =
                          response.redirects.last.location.toString();
                      print('Redirected to: $redirectUrl');
                    } else {
                      print(
                          'No redirects, using original shortenedUrl: $shortenedUrl');
                    }
                  } catch (e) {
                    print('HttpClient error: $e');
                  }
                  */
                  /*
                  try {
                    final response = await Dio(
                      BaseOptions(
                        receiveTimeout: Duration(seconds: 10),
                        headers: {
                          'Origin': 'https://www.tiktok.com',
                          'Referer': 'https://www.tiktok.com/',
                          'Sec-Fetch-Dest': 'empty',
                          'Sec-Fetch-Mode': 'cors',
                          'Sec-Fetch-Site': 'cross-site',
                          'User-Agent':
                              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36',
                        },
                      ),
                    ).post(shortenedUrl);
                    debugPrint("Response headers: ${response.headers}");
                  } catch (e) {
                    debugPrint("Error expanding URL: $e");
                  }
                  */
                },
                child: Text(AppLocalizations.of(context)!.getVideo,
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
