import '../../../../constants/strings.dart';
import '../../../../models/content_details_model.dart';
import '../../../../models/statistics_model.dart';
import '../../../../models/video_list.dart';
import '../../../../models/video_list_search.dart';
import '../../constants/endpoints.dart';
import '../../dio_client.dart';

class VideoApi {
  // dio instance
  final DioClient _dioClient;

  VideoApi(this._dioClient);

  String nextPageTrending = '';
  String nextPageVideos = '';

  /// Returns list of trending in response
  Future<VideoList> getVideosTrending(bool isRefresh, String categoryId) async {
    if (isRefresh == true) {
      nextPageTrending = '';
    }
    try {
      Map<String, String> parameters = {
        'part': 'snippet',
        'maxResults': '10',
        'chart': 'mostPopular',
        'videoCategoryId': categoryId,
        'pageToken': nextPageTrending,
        'key': Strings.apikey,
        'regionCode': "VN",
      };
      final res = await _dioClient.get(Endpoints.getVideosTrending,
          queryParameters: parameters);
      nextPageTrending = res['nextPageToken'] ?? '';
      return VideoList.fromJson(res['items']);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  /// Returns list of videos in response
  Future<VideoListSearch> getVideos(String query, bool isRefresh) async {
    if (isRefresh == true) {
      nextPageVideos = '';
    }
    try {
      Map<String, String> parameters = {
        'part': 'snippet',
        'maxResults': '10',
        'q': query,
        'type': 'video',
        'order': 'relevance',
        'pageToken': nextPageVideos,
        'key': Strings.apikey,
        'regionCode': "VN"
      };
      final res = await _dioClient.get(Endpoints.getVideosSearch,
          queryParameters: parameters);
      nextPageVideos = res['nextPageToken'] ?? '';
      return VideoListSearch.fromJson(res['items']);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<StatisticsModel> getStatisticsVideo(String videoId) async {
    try {
      Map<String, String> parameters = {
        'part': 'statistics',
        'id': videoId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getVideosTrending,
          queryParameters: parameters);
      return StatisticsModel.fromJson(res['items'][0]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<ContentDetailsModel> getContentDetails(String videoId) async {
    try {
      Map<String, String> parameters = {
        'part': 'contentDetails,statistics',
        'id': videoId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getVideosTrending,
          queryParameters: parameters);
      return ContentDetailsModel.fromJson(res['items'][0]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  /// Returns list of videos in response
  Future<VideoListSearch> getVideosRelated(
      String videoId, bool isRefresh) async {
    if (isRefresh == true) {
      nextPageVideos = '';
    }
    try {
      Map<String, String> parameters = {
        'part': 'snippet',
        'relatedToVideoId': videoId,
        'maxResults': '10',
        'type': 'video',
        'order': 'relevance',
        'pageToken': nextPageVideos,
        'key': Strings.apikey,
        'regionCode': "VN"
      };
      final res = await _dioClient.get(Endpoints.getVideosSearch,
          queryParameters: parameters);
      nextPageVideos = res['nextPageToken'] ?? '';
      return VideoListSearch.fromJson(res['items']);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<VideoListSearch> getVideosChannel(
      String channelId, bool isRefresh) async {
    if (isRefresh == true) {
      nextPageVideos = '';
    }
    try {
      Map<String, String> parameters = {
        'part': 'snippet',
        'id': channelId,
        'key': Strings.apikey
      };
      final res = await _dioClient.get(Endpoints.getChannel,
          queryParameters: parameters);
      nextPageVideos = res['nextPageToken'] ?? '';
      return VideoListSearch.fromJson(res['items']);
    } catch (e) {
      print("getStatisticsChannelError: " + e.toString());
      throw e;
    }
  }
}
