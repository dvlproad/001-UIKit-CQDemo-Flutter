/*
 * @Author: dvlproad
 * @Date: 2022-06-20 18:46:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-06 12:44:43
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/src/services/system_chrome.dart';
import '../preview/widget/network_video_widget.dart';

class NetworkVideoPage extends StatefulWidget {
  final String? fileUrl;
  final String? networkUrl;

  NetworkVideoPage({
    Key? key,
    this.fileUrl,
    this.networkUrl,
  }) : super(key: key);

  @override
  _NetworkVideoPageState createState() => _NetworkVideoPageState();
}

class _NetworkVideoPageState extends State<NetworkVideoPage> {
  GlobalKey<NetworkVideoWidgetState> _videoWidgetKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('播放器2'),
      //   systemOverlayStyle: SystemUiOverlayStyle.dark,
      // ),
      body: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      color: Colors.black,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: NetworkVideoWidget(
                key: _videoWidgetKey,
                fileUrl: widget.fileUrl,
                networkUrl: widget.networkUrl,
                shouldDirectPlay: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playOrPause() {
    if (_videoWidgetKey.currentState != null) {
      _videoWidgetKey.currentState!.playOrPause();
    }
  }
}
