import 'package:mobx/mobx.dart';

import '../../data/repository/video_repository.dart';
import '../../models/video_list.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'video_music_store.g.dart';

class VideoMusicStore = _VideoMusicStore with _$VideoMusicStore;

abstract class _VideoMusicStore with Store {
  // repository instance
  late VideoRepository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _VideoMusicStore(VideoRepository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<VideoList?> emptyVideoResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<VideoList?> fetchVideosFuture =
  ObservableFuture<VideoList?>(emptyVideoResponse);

  @observable
  VideoList? videoList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchVideosFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideosMusic(bool isRefresh) async {
    final future = _repository.getVideosMusic(isRefresh);
    fetchVideosFuture = ObservableFuture(future);

    future.then((videoList) {
      this.videoList = isRefresh == true
          ? videoList
          : (this.videoList?..videos?.addAll(videoList.videos ?? []));
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
