import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../models/video_model.dart';
import '../../stores/video/video_entertainment_store.dart';
import '../../utils/routes/routes.dart';

class TrendingScreen extends StatefulWidget {
  @override
  _Trending createState() => _Trending();
}

class _Trending extends State<TrendingScreen> {
  late VideoEntertainmentStore _videoTrendingStore;
  int _searchLimit = 40;

  bool _buttonFlag = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _videoTrendingStore = Provider.of<VideoEntertainmentStore>(context);

    if (!_videoTrendingStore.loading) {
      _videoTrendingStore.getVideosTrending(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending"),
        leading: false ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ) : Container(),
      ),
      body: _buildBody(),
      floatingActionButton: Visibility(
        // play all the songs listed in the search, starting with the first video
        visible: _buttonFlag,
        child: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () {
            // Queue queue = new Queue(0, _videoItem);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => MusicPlayerPage(queue: queue)),
            // );
          },
        ),
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return Column(
          children: <Widget>[
            _videoTrendingStore.videoList != null &&
                    _videoTrendingStore.videoList!.videos!.length > 0
                ? NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollDetails) {
                      if (!_videoTrendingStore.loading &&
                          _videoTrendingStore.videoList!.videos!.length !=
                              _searchLimit &&
                          scrollDetails.metrics.pixels ==
                              scrollDetails.metrics.maxScrollExtent) {
                        if (!_videoTrendingStore.loading) {
                          _videoTrendingStore.getVideosTrending(false);
                        }
                      }
                      return false;
                    },
                    child: Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: _videoTrendingStore.videoList!.videos!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Video video = _videoTrendingStore.videoList!.videos![index];
                          return _buildVideo(video, index);
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor, // Red
                        ),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  _buildVideo(Video video, int index) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Image.network(video.thumbnailUrl!),
          title: Text(video.title!),
          subtitle: Text(video.channelTitle != null ? video.channelTitle! : ""),
          trailing: Icon(Icons.more_vert),
          onTap: () {
            Navigator.pushNamed(context, Routes.player,
                arguments: video.id);
          },
        ),
      ),
    );
  }
}
