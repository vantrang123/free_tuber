
import '../../../constants/strings.dart';
import '../../../models/channel_model.dart';
import '../../../models/channel_statistics.dart';
import '../constants/endpoints.dart';
import '../dio_client.dart';

class ChannelApi {
  // dio instance
  final DioClient _dioClient;

  ChannelApi(this._dioClient);

  /// Returns list of trending in response
  Future<ChannelModel> getChannel(String channelId) async {
    try {
      Map<String, String> parameters = {
        'part': 'snippet',
        'id': channelId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getChannel,
          queryParameters: parameters);
      return ChannelModel.fromJson(res['items'][0]);
    } catch (e) {
      print("getChannelError: "+e.toString());
      throw e;
    }
  }

  Future<ChannelStatisticsModel> getStatisticsChannel(String channelId) async {
    try {
      Map<String, String> parameters = {
        'part': 'statistics',
        'id': channelId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getChannel,
          queryParameters: parameters);
      return ChannelStatisticsModel.fromJson(res['items'][0]);
    } catch (e) {
      print("getStatisticsChannelError: "+e.toString());
      throw e;
    }
  }
}
