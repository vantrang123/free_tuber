import 'package:flutter/material.dart';

class AudioControlProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void setPlayStatus(bool value) {
    _isPlaying = value;
    notifyListeners();
  }
}
