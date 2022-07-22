
import '../../../constants/strings.dart';
import '../../../models/channel_model.dart';
import '../constants/endpoints.dart';
import '../dio_client.dart';

class AvatarApi {
  // dio instance
  final DioClient _dioClient;

  AvatarApi(this._dioClient);

  /// Returns list of trending in response
  Future<ChannelModel> getAvatarChannel(String channelId) async {
    try {
      Map<String, String> parameters = {
        'id': channelId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getChannel,
          queryParameters: parameters);
      return ChannelModel.fromJson(res['items'][0]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
