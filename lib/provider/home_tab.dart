
import 'package:flutter/material.dart';

enum HomeScreenTab { All, Music, Entertainment, Sport, Game }

class HomeTabProvider extends ChangeNotifier {
  late HomeScreenTab _currentHomeTab;

  HomeTabProvider() {
    currentHomeTab = HomeScreenTab.Entertainment;
  }

  HomeScreenTab get currentHomeTab => _currentHomeTab;

  set currentHomeTab(HomeScreenTab tab) {
    _currentHomeTab = tab;
    notifyListeners();
  }
}
