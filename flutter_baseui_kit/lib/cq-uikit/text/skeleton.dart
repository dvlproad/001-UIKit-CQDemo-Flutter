/*
 * @Author: dvlproad
 * @Date: 2022-05-09 17:30:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 14:57:47
 * @Description: 带有闪烁动画Skeleton骨架屏
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class IndicatorSkeleton extends StatelessWidget {
  final double? width;
  final double? height;

  IndicatorSkeleton({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Color(0x1F000000),
      child: CupertinoActivityIndicator(
        radius: 14,
      ),
    );
  }
}

/// 常用于大视图
class BigSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? cornerRadius;
  final Color baseColor;
  final Color highlightColor;
  final Widget? child;

  BigSkeleton({
    Key? key,
    this.width,
    this.height,
    this.cornerRadius, // 默认圆角4，设置0的时候才没有圆角
    this.baseColor = const Color(0x1F000000),
    this.highlightColor = const Color(0x29000000),
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _cornerRadius = cornerRadius ?? 4;

    return Column(
      children: [
        Shimmer.fromColors(
          // baseColor: const Color(0xFFE0E0E0),
          // highlightColor: Colors.lightBlue[300],
          baseColor: baseColor,
          highlightColor: highlightColor,
          direction: ShimmerDirection.ltr,
          period: const Duration(seconds: 2),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _cornerRadius == 0
                  ? null
                  : BorderRadius.circular(_cornerRadius),
            ),
            child: child,
          ),
        )
      ],
    );
  }
}

class Skeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double? cornerRadius;

  Skeleton({
    Key? key,
    this.width,
    this.height,
    this.cornerRadius, // 默认圆角4，设置0的时候才没有圆角
  }) : super(key: key);

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation gradientPosition;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        // print("gradientPosition.value = ${gradientPosition.value}");
        setState(() {});
      });

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    double cornerRadius = widget.cornerRadius ?? 4;
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // begin 和 end 表示渐变的方向
          // Alignment(x, y) , x y 分别表示水平和垂直方向的偏移(初始值均为0,-1:表示图片最左侧,1:表示图片最右侧)
          // x：值-1.0对应于最左侧的边。值1.0对应于最右边的边。数值不限于该范围；小于-1.0的值表示左边缘左侧的位置，大于1.0的值表示右边缘右侧的位置。
          begin: Alignment(gradientPosition.value, 0),
          end: Alignment(-1, 0),
          // colors: [Colors.black12, Colors.black26, Colors.black12],
          colors: [Color(0x1F000000), Color(0x29000000), Color(0x1F000000)],
          // colors: [Colors.green, Colors.red, Colors.green],
        ),
        borderRadius:
            cornerRadius == 0 ? null : BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
