import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_images_browser/src/imagesbrowser_widget.dart';
import './imagesbrowser_changenotifier.dart';
import 'package:extended_image/extended_image.dart';

class TSImagesBrowserPage extends StatefulWidget {
  final List<String> images;
  final int currentIndex;
  final List<Widget> actions;

  TSImagesBrowserPage({
    Key key,
    @required this.images,
    @required this.currentIndex,
    this.actions,
  }) : super(key: key);

  @override
  _TSImagesBrowserPageState createState() => new _TSImagesBrowserPageState();
}

class _TSImagesBrowserPageState extends State<TSImagesBrowserPage> {
  ImagesBrowserChangeNotifier _imagesBrowserChangeNotifier;

  @override
  void dispose() {
    super.dispose();

    _imagesBrowserChangeNotifier.dispose();
  }

  @override
  void initState() {
    super.initState();

    _imagesBrowserChangeNotifier = ImagesBrowserChangeNotifier(
      images: widget.images,
      currentIndex: widget.currentIndex,
    );
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
  PreferredSizeWidget appBar() {
    return AppBar(
      title: ChangeNotifierProvider<ImagesBrowserChangeNotifier>.value(
        value: _imagesBrowserChangeNotifier,
        child: Consumer<ImagesBrowserChangeNotifier>(
          builder: (context, _imagesBrowserChangeNotifier, child) {
            int currentIndex = _imagesBrowserChangeNotifier.currentIndex;
            List<String> images = _imagesBrowserChangeNotifier.images;
            String title =
                (currentIndex + 1).toString() + '/' + images.length.toString();
            return Text(title);
          },
        ),
      ),
      actions: widget.actions,
    );
  }

  /// contentWidget
  Widget contentWidget() {
    return CQImagesBrowserWidget(
      images: _imagesBrowserChangeNotifier.images,
      currentIndex: _imagesBrowserChangeNotifier.currentIndex,
      onPageChanged: (int index) {
        _imagesBrowserChangeNotifier.setCurrentIndex = index;
      },
    );
  }
}
