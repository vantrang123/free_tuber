
import 'video_model.dart';

class VideoList {
  List<Video>? videos;

  VideoList({
    this.videos,
  });

  factory VideoList.fromJson(List<dynamic> json) {
    List<Video> videos = <Video>[];
    videos = json.map((video) => Video.fromMap(video)).toList();

    return VideoList(
      videos: videos,
    );
  }
}
