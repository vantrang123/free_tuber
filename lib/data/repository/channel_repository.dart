
import '../../models/channel_model.dart';
import '../../models/channel_statistics.dart';
import '../network/apis/channel_api.dart';

class ChannelRepository {
  // api objects
  final ChannelApi _api;

  // constructor
  ChannelRepository(this._api);

  // Get: ---------------------------------------------------------------------
  Future<ChannelModel> getChannel(String channelId) async {
    return await _api.getChannel(channelId).then((avatarModel) {
      return avatarModel;
    }).catchError((error) => throw error);
  }

  Future<ChannelStatisticsModel> getChannelStatistics(String channelId) async {
    return await _api.getStatisticsChannel(channelId).then((avatarModel) {
      return avatarModel;
    }).catchError((error) => throw error);
  }
}
