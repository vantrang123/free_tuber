import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../stores/video/video_entertainment_store.dart';
import '../../../utils/error.dart';
import '../../components/streams_large_thumbnail.dart';

class HomePageEntertainment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_handleErrorMessage(context), _buildTrendingContent(context)],
    );
  }

  Widget _buildTrendingContent(BuildContext context) {
    final VideoEntertainmentStore _entertainmentStore =
        Provider.of<VideoEntertainmentStore>(context, listen: false);
    if (!_entertainmentStore.loading && _entertainmentStore.videoList == null ||
        _entertainmentStore.videoList?.videos?.isEmpty == true) {
      _entertainmentStore.getVideosTrending(true);
    }
    return Observer(builder: (context) {
      return Material(
          child: StreamsLargeThumbnailView(
        infoItems: _entertainmentStore.videoList?.videos ?? [],
        onReachingListEnd: () {},
      ));
    });
  }

  Widget _handleErrorMessage(BuildContext context) {
    final VideoEntertainmentStore _musicStore =
        Provider.of<VideoEntertainmentStore>(context, listen: false);
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
