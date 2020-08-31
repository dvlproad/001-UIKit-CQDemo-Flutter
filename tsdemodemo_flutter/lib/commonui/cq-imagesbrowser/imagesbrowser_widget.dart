import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:tsdemodemo_flutter/commonui/cq-pageindicator/pageindicator.dart';

// List<String> egImages = <String>[
//   'http://pic1.win4000.com/pic/f/04/4f085d0c9b.gif',
//   'https://photo.tuchong.com/14649482/f/601672690.jpg',
//   'https://photo.tuchong.com/17325605/f/641585173.jpg',
//   'https://photo.tuchong.com/3541468/f/256561232.jpg',
//   'http://pic1.win4000.com/pic/c/c1/25cbd37070.gif',
//   'https://photo.tuchong.com/16709139/f/278778447.jpg',
//   'https://photo.tuchong.com/15195571/f/233361383.jpg',
//   'https://photo.tuchong.com/5040418/f/43305517.jpg',
//   'https://photo.tuchong.com/3019649/f/302699092.jpg',
//   'http://z.aisaiya.com/gif/202006/ea08c82cfcc6501f0edec03a3c7b241f.gif',
// ];

class CQImagesBrowserWidget extends StatefulWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  CQImagesBrowserWidget({
    Key key,
    @required this.images,
    @required this.currentIndex,
    this.onPageChanged,
  })  : assert(images != null),
        assert(currentIndex != null),
        super(key: key);

  @override
  _CQImagesBrowserWidgetState createState() =>
      new _CQImagesBrowserWidgetState();
}

class _CQImagesBrowserWidgetState extends State<CQImagesBrowserWidget> {
  List<String> _images;
  int _currentIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _images = widget.images;
    _currentIndex = widget.currentIndex;
    _pageController = PageController(
      initialPage: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _pageView(),
        Positioned(
          left: 20,
          right: 20,
          bottom: 60,
          child: _pageIndicator(),
        ),
      ],
    );
  }

  /// 更新页面切换到第几页
  _pageChange(int index) {
    _currentIndex = index;
    // rebuild.add(index);
    setState(() {});
    if (widget.onPageChanged != null) {
      widget.onPageChanged(index);
    }
  }

  /// 图片浏览页面
  Widget _pageView() {
    return ExtendedImageGesturePageView.builder(
      itemBuilder: (BuildContext context, int index) {
        var item = _images[index];
        Widget image = ExtendedImage.network(
          item,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (ExtendedImageState state) {
            return GestureConfig(
              inPageView: true,
              initialScale: 1.0,
              //you can cache gesture state even though page view page change.
              //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
              cacheGesture: false,
            );
          },
        );
        image = Container(
          child: image,
          padding: EdgeInsets.all(5.0),
        );
        if (index == _currentIndex) {
          return Hero(
            tag: item + index.toString(),
            child: image,
          );
        } else {
          return image;
        }
      },
      itemCount: _images.length,
      onPageChanged: (int index) {
        this._pageChange(index);
      },
      controller: _pageController,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _pageIndicator() {
    return CQPageIndicator(
      alignment: Alignment.center,
      pageController: _pageController,
      count: _images.length,
      onDotClicked: (index) {
        //print('点击切换到第$index页');
        _pageController.jumpToPage(index);
      },
    );
  }
}
