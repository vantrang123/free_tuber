import 'package:mobx/mobx.dart';

import '../../data/repository/channel_repository.dart';
import '../../models/channel_statistics.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'channel_statistics_store.g.dart';

class ChannelStatisticsStore = _ChannelStatisticsStore with _$ChannelStatisticsStore;

abstract class _ChannelStatisticsStore with Store {
  // repository instance
  late ChannelRepository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _ChannelStatisticsStore(ChannelRepository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<ChannelStatisticsModel?> emptyResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<ChannelStatisticsModel?> fetchDataFuture =
      ObservableFuture<ChannelStatisticsModel?>(emptyResponse);

  @observable
  ChannelStatisticsModel? statistics;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchDataFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getChannelStatistics(String videoId) async {
    final future = _repository.getChannelStatistics(videoId);
    fetchDataFuture = ObservableFuture(future);

    future.then((data) {
      this.statistics = data;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
