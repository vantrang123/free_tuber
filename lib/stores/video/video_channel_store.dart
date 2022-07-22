import 'package:mobx/mobx.dart';

import '../../data/repository/video_repository.dart';
import '../../models/video_list_search.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'video_channel_store.g.dart';

class VideoChannelStore = _VideoChannelStore with _$VideoChannelStore;

abstract class _VideoChannelStore with Store {
  // repository instance
  late VideoRepository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _VideoChannelStore(VideoRepository repository)
      : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<VideoListSearch?> emptyVideoResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<VideoListSearch?> fetchVideosFuture =
      ObservableFuture<VideoListSearch?>(emptyVideoResponse);

  @observable
  VideoListSearch? videoListSearch;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchVideosFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideosChannel(String channelId, bool isRefresh) async {
    final future = _repository.getVideosChannel(channelId, isRefresh);
    fetchVideosFuture = ObservableFuture(future);

    future.then((videoList) {
      this.videoListSearch = isRefresh == true
          ? videoList
          : (this.videoListSearch?..videos?.addAll(videoList.videos ?? []));
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
