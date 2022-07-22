import 'dart:async';

import '../../models/channel_model.dart';
import '../network/apis/avatar_api.dart';


class AvatarRepository {

  // api objects
  final AvatarApi _avatarApi;

  // constructor
  AvatarRepository(this._avatarApi);

  // Get: ---------------------------------------------------------------------
  Future<ChannelModel> getAvatarChannel(String channelId) async {
    return await _avatarApi.getAvatarChannel(channelId).then((avatarModel) {
      return avatarModel;
    }).catchError((error) => throw error);
  }
}
