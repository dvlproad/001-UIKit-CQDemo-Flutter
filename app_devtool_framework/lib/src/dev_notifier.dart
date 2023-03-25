import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DevChangeNotifier extends ChangeNotifier {
  void updateUI() {
    notifyListeners();
  }
}
