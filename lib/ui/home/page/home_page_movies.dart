import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../stores/video/video_sports_store.dart';
import '../../../utils/error.dart';
import '../../components/streams_large_thumbnail.dart';

class HomePageSports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_handleErrorMessage(context), _buildTrendingContent(context)],
    );
  }

  Widget _buildTrendingContent(BuildContext context) {
    final VideoSportsStore _moviesStore =
        Provider.of<VideoSportsStore>(context, listen: false);
    if (!_moviesStore.loading && _moviesStore.videoList == null ||
        _moviesStore.videoList?.videos?.isEmpty == true) {
      _moviesStore.getVideosSports(true);
    }
    return Observer(builder: (context) {
      return Material(
          child: StreamsLargeThumbnailView(
        infoItems: _moviesStore.videoList?.videos ?? [],
        onReachingListEnd: () {},
      ));
    });
  }

  Widget _handleErrorMessage(BuildContext context) {
    final VideoSportsStore _moviesStore =
        Provider.of<VideoSportsStore>(context, listen: false);
    return Observer(
      builder: (context) {
        if (_moviesStore.errorStore.errorMessage.isNotEmpty) {
          return ErrorUtils.showErrorMessage(
              context, _moviesStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }
}
