import 'package:mobx/mobx.dart';

import '../../data/repository/video_repository.dart';
import '../../models/video_list.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'video_entertainment_store.g.dart';

class VideoEntertainmentStore = _VideoEntertainmentStore with _$VideoEntertainmentStore;

abstract class _VideoEntertainmentStore with Store {
  // repository instance
  late VideoRepository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _VideoEntertainmentStore(VideoRepository repository) : this._repository = repository;

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
  Future getVideosTrending(bool isRefresh) async {
    final future = _repository.getVideosTrendingEntertainment(isRefresh);
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
