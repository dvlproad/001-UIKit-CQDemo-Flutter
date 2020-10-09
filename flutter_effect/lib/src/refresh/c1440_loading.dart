import 'package:flutter/material.dart';

class C1440Loading extends StatelessWidget {
  final double size;

  final int interval;

  C1440Loading({this.size, this.interval});

  @override
  Widget build(BuildContext context) {
    List<String> images = [];

    for (int i = 0; i < 37; ++i) {
      images.add("assets/loading/loading_$i.png");
    }

    return C1440FrameAnimationImage(
      images,
      width: size ?? 40,
      height: size ?? 40,
      interval: interval ?? 50,
    );
  }
}

class C1440FrameAnimationImage extends StatefulWidget {
  final List<String> _assetList;
  final double width;
  final double height;
  final int interval;

  C1440FrameAnimationImage(this._assetList,
      {this.width, this.height, this.interval = 200});

  @override
  State<StatefulWidget> createState() {
    return _FrameAnimationImageState();
  }
}

class _FrameAnimationImageState extends State<C1440FrameAnimationImage>
    with SingleTickerProviderStateMixin {
  /// 动画控制
  Animation<double> _animation;
  AnimationController _controller;
  int interval = 200;

  @override
  void initState() {
    super.initState();

    if (widget.interval != null) {
      interval = widget.interval;
    }
    final int imageCount = widget._assetList.length;
    final int maxTime = interval * imageCount;

    /// 启动动画controller
    _controller = AnimationController(
        duration: Duration(milliseconds: maxTime), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        /// 完成后重新开始
        _controller.forward(from: 0.0);
      }
    });

    _animation =
        Tween<double>(begin: 0, end: imageCount.toDouble()).animate(_controller)
          ..addListener(() {
            setState(() {
              // the state that has changed here is the animation object’s value
            });
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int ix = _animation.value.floor() % widget._assetList.length;

    List<Widget> images = [];

    for (int i = 0; i < widget._assetList.length; ++i) {
      if (i != ix) {
        images.add(Image.asset(
          widget._assetList[i],
          package: 'flutter_effect',
          width: 0,
          height: 0,
        ));
      }
    }

    images.add(Image.asset(
      widget._assetList[ix],
      package: 'flutter_effect',
      width: widget.width,
      height: widget.height,
    ));

    return Stack(alignment: AlignmentDirectional.center, children: images);
  }
}
