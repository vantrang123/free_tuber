import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../stores/video/video_music_store.dart';
import '../../../utils/error.dart';
import '../../components/streams_large_thumbnail.dart';

class HomePageMusic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_handleErrorMessage(context), _buildTrendingContent(context)],
    );
  }

  Widget _buildTrendingContent(BuildContext context) {
    final VideoMusicStore _musicStore =
        Provider.of<VideoMusicStore>(context, listen: false);
    if (!_musicStore.loading && _musicStore.videoList == null ||
        _musicStore.videoList?.videos?.isEmpty == true) {
      _musicStore.getVideosMusic(true);
    }
    return Observer(builder: (context) {
      return Material(
          child: StreamsLargeThumbnailView(
        infoItems: _musicStore.videoList?.videos ?? [],
        onReachingListEnd: () {},
      ));
    });
  }

  Widget _handleErrorMessage(BuildContext context) {
    final VideoMusicStore _musicStore =
        Provider.of<VideoMusicStore>(context, listen: false);
    return Observer(
      builder: (context) {
        if (_musicStore.errorStore.errorMessage.isNotEmpty) {
          return ErrorUtils.showErrorMessage(
              context, _musicStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }
}
