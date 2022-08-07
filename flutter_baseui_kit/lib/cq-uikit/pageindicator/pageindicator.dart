/*
 * @Author: dvlproad
 * @Date: 2022-08-07 16:54:48
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-08 00:24:10
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CQPageIndicator extends StatelessWidget {
  /// The number of pages
  final int count;

  // Page view controller
  final PageController pageController;

  /// on dot clicked callback
  final OnDotClicked? onDotClicked;

  final AlignmentGeometry alignment;

  CQPageIndicator({
    Key? key,
    required this.count,
    required this.pageController,
    this.onDotClicked,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: this.alignment,
      child: Container(
        // color: Colors.red,
        height: 44,
        child: _pageIndicator(),
      ),
    );
  }

  Widget _pageIndicator() {
    return SmoothPageIndicator(
      controller: this.pageController, // PageController
      count: this.count,
      effect: WormEffect(
        dotWidth: 6,
        dotHeight: 6,
        dotColor: Colors.grey,
        activeDotColor: Colors.white,
      ), // your preferred effect
      onDotClicked: this.onDotClicked,
    );
    // return AnimatedSmoothIndicator(
    //   activeIndex: _currentIndex,
    //   count: _images.length,
    //   effect: WormEffect(),
    // );
  }
}
