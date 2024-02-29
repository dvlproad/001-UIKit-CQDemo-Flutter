import 'dart:ui';

class BaseActionModel {
  final String imageName;
  final String? imagePackage;
  final String title;
  final Color titleColor;
  final void Function() handle;

  BaseActionModel({
    required this.imageName,
    this.imagePackage,
    required this.title,
    this.titleColor = const Color(0xff333333),
    required this.handle,
  });
}


