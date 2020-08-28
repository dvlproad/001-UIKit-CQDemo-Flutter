import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  CQImagesBrowserWidget({
    Key key,
    @required this.images,
    @required this.currentIndex,
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
          bottom: 80,
          child: Center(
            child: Container(
              child: _pageIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  /// 图片浏览页面
  Widget _pageView() {
    return ExtendedImageGesturePageView.builder(
      itemBuilder: (BuildContext context, int index) {
        var item = _images[index];
        Widget image = ExtendedImage.network(
          item,
          enableSlideOutPage: true,


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
        _currentIndex = index;
        // rebuild.add(index);
        setState(() {});
      },
      controller: _pageController,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _pageIndicator() {
    return SmoothPageIndicator(
      controller: _pageController, // PageController
      count: _images.length,
      effect: WormEffect(
        dotWidth: 6,
        dotHeight: 6,
        dotColor: Colors.grey,
        activeDotColor: Colors.white,
      ), // your preferred effect
      onDotClicked: (index) {},
    );
    // return AnimatedSmoothIndicator(
    //   activeIndex: _currentIndex,
    //   count: _images.length,
    //   effect: WormEffect(),
    // );
  }
}
