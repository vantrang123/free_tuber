
import 'video_seach_model.dart';

class VideoListSearch {
  List<VideoSearch>? videos;

  VideoListSearch({
    this.videos,
  });

  factory VideoListSearch.fromJson(List<dynamic> json) {
    List<VideoSearch> videos = <VideoSearch>[];
    videos = json.map((video) => VideoSearch.fromMap(video)).toList();

    return VideoListSearch(
      videos: videos,
    );
  }
}
