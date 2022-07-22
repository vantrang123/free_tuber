import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../constants/app_theme.dart';
import '../constants/strings.dart';
import '../data/repository/channel_repository.dart';
import '../data/repository/video_repository.dart';
import '../di/components/service_locator.dart';
import '../provider/audio_control.dart';
import '../provider/home_tab.dart';
import '../provider/manager.dart';
import '../provider/video_control.dart';
import '../provider/video_duration_change.dart';
import '../stores/explore/explore_store.dart';
import '../stores/player/player_store.dart';
import '../stores/video/channel_statistics_store.dart';
import '../stores/video/channel_store.dart';
import '../stores/video/related_2_video_store.dart';
import '../stores/video/video_another_store.dart';
import '../stores/video/video_music_store.dart';
import '../stores/video/video_sports_store.dart';
import '../stores/video/video_store.dart';
import '../stores/video/video_entertainment_store.dart';
import '../utils/routes/routes.dart';
import 'home/home.dart';

class MyApp extends StatelessWidget {
  final VideoStore _videoStore = VideoStore(getIt<VideoRepository>());
  final VideoEntertainmentStore _videoTrendingStore =
      VideoEntertainmentStore(getIt<VideoRepository>());
  final ExploreStore _exploreStore = ExploreStore();
  final PlayerStore _playerStore = PlayerStore();
  final VideoMusicStore _musicStore = VideoMusicStore(getIt<VideoRepository>());
  final VideoSportsStore _moviesStore =
      VideoSportsStore(getIt<VideoRepository>());
  final VideoAnotherStore _anotherStore =
      VideoAnotherStore(getIt<VideoRepository>());
  final Related2VideoStore _related2videoStore = Related2VideoStore(getIt<VideoRepository>());
  final ChannelStore _channelStore = ChannelStore(getIt<ChannelRepository>());
  final ChannelStatisticsStore _channelStatisticsStore = ChannelStatisticsStore(getIt<ChannelRepository>());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<VideoStore>(create: (_) => _videoStore),
        Provider<VideoEntertainmentStore>(create: (_) => _videoTrendingStore),
        Provider<ExploreStore>(create: (_) => _exploreStore),
        Provider<PlayerStore>(create: (_) => _playerStore),
        Provider<VideoMusicStore>(create: (_) => _musicStore),
        Provider<VideoSportsStore>(create: (_) => _moviesStore),
        Provider<VideoAnotherStore>(create: (_) => _anotherStore),
        Provider<Related2VideoStore>(create: (_) => _related2videoStore),
        Provider<ChannelStore>(create: (_) =>_channelStore),
        Provider<ChannelStatisticsStore>(create: (_) =>_channelStatisticsStore),
        ChangeNotifierProvider<HomeTabProvider>(
            create: (context) => HomeTabProvider()),
        ChangeNotifierProvider<ManagerProvider>(
            create: (context) => ManagerProvider()),
        ChangeNotifierProvider<VideoControlProvider>(
            create: (context) => VideoControlProvider()),
        ChangeNotifierProvider<AudioControlProvider>(
            create: (context) => AudioControlProvider()),
        ChangeNotifierProvider<VideoDurationChange>(
            create: (context) => VideoDurationChange()),
      ],
      child: Observer(
          name: 'global-observer',
          builder: (context) {
            return MaterialApp(
              color: Theme.of(context).scaffoldBackgroundColor,
              debugShowCheckedModeBanner: false,
              title: Strings.appName,
              theme: themeDataDark,
              routes: Routes.routes,
              home: SafeArea(
                  child: WillPopScope(
                      child: HomeScreen(),
                      onWillPop: () {
                        return Future.value(true);
                      })
              ),
            );
          }),
    );
  }
}
