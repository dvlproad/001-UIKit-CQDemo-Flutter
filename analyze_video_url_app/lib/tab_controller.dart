import 'package:flutter/foundation.dart';

class AppTabController extends ChangeNotifier {
  static final AppTabController _instance = AppTabController._internal();
  factory AppTabController() => _instance;
  AppTabController._internal();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void switchToTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
