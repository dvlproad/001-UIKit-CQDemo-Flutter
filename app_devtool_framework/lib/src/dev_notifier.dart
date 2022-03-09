import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DevChangeNotifier extends ChangeNotifier {
  void updateUI() {
    notifyListeners();
  }
}
