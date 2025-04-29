/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:13
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-29 10:25:16
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_analyze_video_url/cq_video_url_analyze_tiktok.dart';
import './services/download_manager.dart';
import './tab_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import './services/analytics_service.dart';

class VideoInputPage extends StatefulWidget {
  @override
  State<VideoInputPage> createState() => _VideoInputPageState();
}

class _VideoInputPageState extends State<VideoInputPage>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  int _lastClipboardChangeCount = 0;
  bool _isAnalyzing = false;

  // 随机下载链接列表
  final List<String> _randomUrls = [
    "https://www.tiktok.com/t/ZT2mkNaFw/", // nezha2 shengaongbao
    "https://www.tiktok.com/t/ZT2VmD3sP/", // 蜜雪冰城
    "https://www.tiktok.com/t/ZT2VmapkQ/", // 夕阳
    "https://vt.tiktok.com/ZSrtL8exN/", // super idol
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLastClipboardChangeCount();
    _checkClipboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkClipboard();
    }
  }

  Future<void> _loadLastClipboardChangeCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastClipboardChangeCount =
          prefs.getInt('last_clipboard_change_count') ?? 0;
    });
  }

  Future<void> _saveLastClipboardChangeCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_clipboard_change_count', count);
  }

  Future<void> _checkClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null && clipboardData!.text!.isNotEmpty) {
        // Get the current clipboard content hash to detect changes
        final currentContentHash = clipboardData.text.hashCode.toString();
        final prefs = await SharedPreferences.getInstance();
        final lastContentHash = prefs.getString('last_clipboard_content_hash');

        // Only update if the content has changed
        if (lastContentHash != currentContentHash) {
          setState(() {
            _controller.text = clipboardData.text!;
          });
          // Save the new content hash
          await prefs.setString(
              'last_clipboard_content_hash', currentContentHash);
        }
      }
    } catch (e) {
      debugPrint('Error checking clipboard: $e');
    }
  }

  // 显示空输入对话框
  Future<void> _showEmptyInputDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmClear),
          content: Text(
              AppLocalizations.of(context)!.emptyInputRandomDownloadPrompt),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.randomDownload),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
                _useRandomUrl();
              },
            ),
          ],
        );
      },
    );
  }

  // 使用随机URL
  void _useRandomUrl() {
    final random = Random();
    final randomIndex = random.nextInt(_randomUrls.length);
    final randomUrl = _randomUrls[randomIndex];

    setState(() {
      _controller.text = randomUrl;
    });

    // 自动开始分析
    _analyzeVideo();
  }

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
      body: GestureDetector(
        onTap: () {
          // 点击空白区域关闭键盘
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white, // 添加背景色以确保整个区域都能响应点击
          child: Padding(
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
                    maxLines: 10, // 允许多行
                    minLines: 1, // 最小行数
                    //textInputAction: TextInputAction.newline, // 支持换行
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.pasteTiktokLink,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.paste, color: Colors.green),
                        onPressed: () async {
                          await _checkClipboard();
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
                    onPressed: _isAnalyzing ? null : _analyzeVideo,
                    child: Text(
                        _isAnalyzing
                            ? AppLocalizations.of(context)!.waitingForDownload
                            : AppLocalizations.of(context)!.getVideo,
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _analyzeVideo() async {
    final analytics = AnalyticsService();
    await analytics.logStartAnalyze(_controller.text.trim());

    // 关闭键盘
    FocusScope.of(context).unfocus();

    final url = _controller.text.trim();
    if (url.isEmpty) {
      await _showEmptyInputDialog();
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

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

    try {
      await CQVideoUrlAnalyzeTiktok.requestUrlFromShortenedUrl(
        url,
        CQAnalyzeVideoUrlType.videoWithoutWatermark,
        success: (expandedUrl, videoId, resultUrl) {
          analytics.logAnalyzeSuccess(videoId, url);
          // 关闭键盘
          FocusScope.of(context).unfocus();
          // 关闭加载对话框
          Navigator.pop(context);

          debugPrint("expandedUrl: $expandedUrl");
          debugPrint("videoId: $videoId");
          debugPrint("resultUrl: $resultUrl");

          // 添加到下载管理器
          DownloadManager().addDownload(videoId, resultUrl);

          // 切换到已解析tab页面
          AppTabController().switchToTab(1); // 假设ParsedVideosPage是第二个tab（索引为1）
        },
        failure: (errorMessage) {
          analytics.logAnalyzeFailed(errorMessage, url);
          // 关闭加载对话框
          Navigator.pop(context);

          debugPrint("errorMessage: $errorMessage");

          String errorMessage2 = "解析失败";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!
                    .parsingFailed(errorMessage2))),
          );
        },
      );
    } catch (e, stack) {
      analytics.logError(e, stack, url);
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }
}
