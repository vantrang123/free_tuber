import 'package:flutter/material.dart';
import 'package:free_tuber/ui/channel/channel_detail.dart';

import '../../models/video_model.dart';
import '../../ui/home/home.dart';
import '../../ui/player/player.dart';
import '../../ui/search/search.dart';
import '../../ui/trending/trending.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String player = '/player';
  static const String trending = '/trending';
  static const String search = '/search';
  static const String channel = '/channel';

  static final routes = <String, WidgetBuilder>{
    player: (BuildContext context) => PlayerScreen(
        video: ModalRoute.of(context)?.settings.arguments as Video),
    channel: (BuildContext context) => ChannelPageDetail(
        video: ModalRoute.of(context)?.settings.arguments as Video),
    trending: (BuildContext context) => TrendingScreen(),
    home: (BuildContext context) => HomeScreen(),
    search: (BuildContext context) => SearchScreen(/*keyword: ModalRoute.of(context)?.settings.arguments as String*/),
  };
}
