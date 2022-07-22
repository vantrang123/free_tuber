import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local/datasources/video/video_datasource.dart';
import '../../data/local/hive_service.dart';
import '../../data/network/apis/channel_api.dart';
import '../../data/network/apis/videos/video_api.dart';
import '../../data/network/dio_client.dart';
import '../../data/repository/channel_repository.dart';
import '../../data/repository/video_repository.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../events/my_event_bus.dart';
import '../../stores/error/error_store.dart';
import '../../stores/explore/explore_store.dart';
import '../../stores/player/player_store.dart';
import '../../stores/video/channel_statistics_store.dart';
import '../../stores/video/channel_store.dart';
import '../../stores/video/related_2_video_store.dart';
import '../../stores/video/video_music_store.dart';
import '../../stores/video/video_sports_store.dart';
import '../../stores/video/video_store.dart';
import '../../stores/video/video_entertainment_store.dart';
import '../../ui/player/audio_manager.dart';
import '../module/local_module.dart';
import '../module/network_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // factories:-----------------------------------------------------------------
  getIt.registerFactory(() => ErrorStore());

  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<Database>(() => LocalModule.provideDatabase());
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(
      NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerLazySingleton<MyEventBus>(() => MyEventBus());

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(VideoApi(getIt<DioClient>()));
  getIt.registerSingleton(ChannelApi(getIt<DioClient>()));

  // data sources
  getIt.registerSingleton(VideoDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(HiveService());

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(VideoRepository(
    getIt<VideoApi>(),
    getIt<SharedPreferenceHelper>(),
    getIt<VideoDataSource>(),
  ));
  getIt.registerSingleton(ChannelRepository(
    getIt<ChannelApi>(),
  ));

  // stores
  getIt.registerSingleton(VideoStore(getIt<VideoRepository>()));
  getIt.registerSingleton(ExploreStore());
  getIt.registerSingleton(PlayerStore());
  getIt.registerSingleton(VideoEntertainmentStore(getIt<VideoRepository>()));
  getIt.registerSingleton(VideoMusicStore(getIt<VideoRepository>()));
  getIt.registerSingleton(VideoSportsStore(getIt<VideoRepository>()));
  getIt.registerSingleton(Related2VideoStore(getIt<VideoRepository>()));
  getIt.registerSingleton(ChannelStore(getIt<ChannelRepository>()));
  getIt.registerSingleton(ChannelStatisticsStore(getIt<ChannelRepository>()));

  //service
  getIt.registerLazySingleton<AudioManager>(() => AudioManager());
}
