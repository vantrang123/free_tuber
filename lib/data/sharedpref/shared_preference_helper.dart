import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  VideoPlayerController? get lastVideoController {
    final value = _sharedPreference.getString(Preferences.last_video_controller);
    return value == "" || value == null ? null : (jsonDecode(value) as VideoPlayerController);
  }

  void saveLastVideoController(VideoPlayerController data) {
    // _sharedPreference.setString(Preferences.last_video_controller, jsonEncode(data));
  }
}
