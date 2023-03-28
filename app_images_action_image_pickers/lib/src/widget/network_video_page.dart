/*
 * @Author: dvlproad
 * @Date: 2022-06-20 18:46:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 10:28:04
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:flutter_player_ui/flutter_player_ui.dart';

class NetworkVideoPage extends StatefulWidget {
  final String? fileUrl;
  final String? networkUrl;

  const NetworkVideoPage({
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
            Center(
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

  // ignore: unused_element
  void _playOrPause() {
    if (_videoWidgetKey.currentState != null) {
      _videoWidgetKey.currentState!.playOrPause();
    }
  }
}
