import 'package:flutter/material.dart';

class SearchChangeNotifier extends ChangeNotifier {
  String _searchText;

  String get searchText => _searchText;

  searchTextChange(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }
}
