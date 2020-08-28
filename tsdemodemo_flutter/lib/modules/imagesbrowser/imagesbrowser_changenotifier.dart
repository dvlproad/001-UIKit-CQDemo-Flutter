import 'package:flutter/material.dart';

class ImagesBrowserChangeNotifier extends ChangeNotifier {
  List<String> images;
  int currentIndex;
  ImagesBrowserChangeNotifier({
    @required this.images,
    @required this.currentIndex,
  });

  List<String> get getImages => images;

  set setImages(List<String> images) => this.images = images;

  int get getCurrentIndex => currentIndex;

  set setCurrentIndex(int currentIndex) {
    this.currentIndex = currentIndex;

    notifyListeners();
  }
}
