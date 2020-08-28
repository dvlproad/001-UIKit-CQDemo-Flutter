import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CQPageIndicator extends StatelessWidget {
  /// The number of pages
  final int count;

  // Page view controller
  final PageController pageController;

  /// on dot clicked callback
  final OnDotClicked onDotClicked;

  CQPageIndicator({
    Key key,
    this.count,
    this.pageController,
    this.onDotClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _pageIndicator();
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
