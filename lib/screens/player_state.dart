import 'package:flutter/material.dart';

class PlayerState with ChangeNotifier {
  bool _isMinimized = false;

  bool get isMinimized => _isMinimized;

  void setMinimized(bool value) {
    _isMinimized = value;
    notifyListeners();
  }
}
