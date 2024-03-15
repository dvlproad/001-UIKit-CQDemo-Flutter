import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';

class EnvChangeNotifier extends ChangeNotifier {
  void updateUI() {
    notifyListeners();
  }
}
