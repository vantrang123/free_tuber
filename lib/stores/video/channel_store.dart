import 'package:mobx/mobx.dart';

import '../../data/repository/channel_repository.dart';
import '../../models/channel_model.dart';
import '../../utils/dio/dio_error_util.dart';
import '../error/error_store.dart';

part 'channel_store.g.dart';

class ChannelStore = _ChannelStore with _$ChannelStore;

abstract class _ChannelStore with Store {
  // repository instance
  late ChannelRepository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _ChannelStore(ChannelRepository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<ChannelModel?> emptyResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<ChannelModel?> fetchDataFuture =
      ObservableFuture<ChannelModel?>(emptyResponse);

  @observable
  ChannelModel? channel;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchDataFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getChannel(String videoId) async {
    final future = _repository.getChannel(videoId);
    fetchDataFuture = ObservableFuture(future);

    future.then((data) {
      this.channel = data;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
