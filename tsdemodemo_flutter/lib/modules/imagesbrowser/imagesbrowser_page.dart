import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-imagesbrowser/imagesbrowser_widget.dart';

List<String> egImages = <String>[
  'http://pic1.win4000.com/pic/f/04/4f085d0c9b.gif',
  'https://photo.tuchong.com/14649482/f/601672690.jpg',
  'https://photo.tuchong.com/17325605/f/641585173.jpg',
  'https://photo.tuchong.com/3541468/f/256561232.jpg',
  'http://pic1.win4000.com/pic/c/c1/25cbd37070.gif',
  'https://photo.tuchong.com/16709139/f/278778447.jpg',
  'https://photo.tuchong.com/15195571/f/233361383.jpg',
  'https://photo.tuchong.com/5040418/f/43305517.jpg',
  'https://photo.tuchong.com/3019649/f/302699092.jpg',
  'http://z.aisaiya.com/gif/202006/ea08c82cfcc6501f0edec03a3c7b241f.gif',
];

class TSImagesBrowserPage extends StatefulWidget {
  final List<String> images;
  final int currentIndex;

  TSImagesBrowserPage({
    Key key,
    this.images,
    this.currentIndex,
  }) : super(key: key);

  @override
  _TSImagesBrowserPageState createState() => new _TSImagesBrowserPageState();
}

class _TSImagesBrowserPageState extends State<TSImagesBrowserPage> {
  List<String> _images;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    // _images = widget.images;
    // _currentIndex = widget.currentIndex;
    _images = egImages;
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(),
      // body: contentWidget(),
      body: ExtendedImageSlidePage(
        slideType: SlideType.onlyImage,
        child: Container(
          color: Colors.black,
          child: contentWidget(),
        ),
      ),
    );
  }

  /// 导航栏
  PreferredSize appBar() {
    return PreferredSize(
        child: AppBar(
          title: Text('图片浏览', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// contentWidget
  Widget contentWidget() {
    return CQImagesBrowserWidget(
      images: _images,
      currentIndex: _currentIndex,
    );
  }
}
