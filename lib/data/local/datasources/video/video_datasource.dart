import 'package:sembast/sembast.dart';

import '../../../../models/video_list.dart';
import '../../../../models/video_model.dart';
import '../../constants/db_constants.dart';

class VideoDataSource {
  final _videoStore = intMapStoreFactory.store(DBConstants.STORE_NAME);
  final Database _db;

  VideoDataSource(this._db);

  Future<int> insert(Video video) async =>
      await _videoStore.add(_db, video.toMap());

  Future<int> count() async => await _videoStore.count(_db);

  Future<VideoList> getVideosFromDb() async {
    print('Loading from database');
    var videosList;

    final recordSnapshots = await _videoStore.find(_db);

    if (recordSnapshots.length > 0) {
      videosList = VideoList(
          videos: recordSnapshots.map((snapshot) {
        final video = Video.fromMap(snapshot.value);
        return video;
      }).toList());
    }

    return videosList;
  }

  Future<int> update(Video video) async {
    final finder = Finder(filter: Filter.byKey(video.id));
    return await _videoStore.update(_db, video.toMap(), finder: finder);
  }

  Future<int> delete(Video video) async {
    final finder = Finder(filter: Filter.byKey(video.id));
    return await _videoStore.delete(_db, finder: finder);
  }

  Future deleteAll() async {
    await _videoStore.drop(_db);
  }
}
