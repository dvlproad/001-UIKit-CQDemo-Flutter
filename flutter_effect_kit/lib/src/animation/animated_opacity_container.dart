/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-22 16:54:03
 * @Description: 初始化完后，渐变显示的视图
 */
import 'package:flutter/material.dart';

class AnimatedOpacityContainer extends StatefulWidget {
  final Widget child;
  final Duration? duration;

  const AnimatedOpacityContainer({
    Key? key,
    required this.child,
    this.duration,
  }) : super(key: key);

  @override
  State<AnimatedOpacityContainer> createState() =>
      _AnimatedOpacityContainerState();
}

class _AnimatedOpacityContainerState extends State<AnimatedOpacityContainer> {
  bool _isViewDidLayoutSubviews = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isViewDidLayoutSubviews = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration ?? const Duration(seconds: 1),
      opacity: _isViewDidLayoutSubviews == false ? 0 : 1.0,
      child: widget.child,
      curve: Curves.ease,
    );
  }
}
