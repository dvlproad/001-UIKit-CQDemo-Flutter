/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-03-31 21:38:02
 * @Description: 
 */
import 'package:flutter/material.dart';

class ParsedVideosPage extends StatefulWidget {
  @override
  _ParsedVideosPageState createState() => _ParsedVideosPageState();
}

class _ParsedVideosPageState extends State<ParsedVideosPage> {
  List<VideoItem> videos = [
    VideoItem(url: "video1.mp4", size: "6.91M"),
    VideoItem(url: "video2.mp4", size: "142.61M"),
    VideoItem(url: "video3.mp4", size: "14.77M"),
    VideoItem(url: "video4.mp4", size: "7.69M"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("已解析", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => setState(() => videos.clear()),
            child: Text("清空", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return VideoCard(
              video: videos[index],
              onDelete: () {
                setState(() {
                  videos.removeAt(index);
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class VideoItem {
  String url;
  String size;
  double progress; // 0.0 ~ 1.0
  bool isDownloading;

  VideoItem(
      {required this.url,
      required this.size,
      this.progress = 0.0,
      this.isDownloading = false});
}

class VideoCard extends StatefulWidget {
  final VideoItem video;
  final VoidCallback onDelete;

  VideoCard({required this.video, required this.onDelete});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoItem video;

  @override
  void initState() {
    super.initState();
    video = widget.video;
  }

  void _toggleDownload() {
    setState(() {
      video.isDownloading = !video.isDownloading;
    });

    if (video.isDownloading) {
      _startDownloading();
    }
  }

  void _startDownloading() async {
    while (video.isDownloading && video.progress < 1.0) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        video.progress += 0.1;
        if (video.progress >= 1.0) {
          video.progress = 1.0;
          video.isDownloading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container(color: Colors.black12)), // 假设是视频封面
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(video.size, style: TextStyle(color: Colors.white)),
              ),
              if (video.progress > 0 && video.progress < 1.0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: LinearProgressIndicator(value: video.progress),
                ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: widget.onDelete,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("删除", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        if (video.progress > 0 && video.progress < 1.0)
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton(
              mini: true,
              onPressed: _toggleDownload,
              child: Icon(video.isDownloading ? Icons.pause : Icons.play_arrow),
            ),
          ),
      ],
    );
  }
}
