import 'package:mobx/mobx.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploreYT;

part 'explore_store.g.dart';

class ExploreStore = _ExploreStore with _$ExploreStore;

abstract class _ExploreStore with Store {
  // store variables:-----------------------------------------------------------
  static ObservableFuture<String?> emptyVideoResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<String?> fetchVideosFuture =
      ObservableFuture<String?>(emptyVideoResponse);

  @observable
  String? videoStreamUrl;

  @observable
  String? audioStreamUrl;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchVideosFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getVideoStreamUrl(String videoId) async {
    var yt = exploreYT.YoutubeExplode();
    var id = exploreYT.VideoId(videoId);
    var manifest = await yt.videos.streamsClient.getManifest(id);
    var streamInfo = manifest.video;
    print("Day la link video: ${streamInfo[2].url.toString()}");
    this.videoStreamUrl = streamInfo[2].url.toString();
    this.audioStreamUrl = manifest.audio[1].url.toString();
    print("Day la link audio: ${manifest.audio[1].url.toString()}");
    yt.close();
  }
}
