import 'package:flutter/material.dart';

class VideoDurationChange extends ChangeNotifier {
  void onChange() {
    notifyListeners();
  }
}
