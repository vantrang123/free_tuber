import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/repository/channel_repository.dart';
import '../../data/repository/video_repository.dart';
import '../../models/channel_model.dart';
import '../../models/content_details_model.dart';
import '../../models/statistics_model.dart';
import '../../models/video_model.dart';
import '../../utils/date_time_extension.dart'; // <--- import the file you just create
import '../../di/components/service_locator.dart';
import '../../utils/routes/routes.dart';
import '../../widgets/avatar_channel.dart';
import '../animations/fade_in.dart';
import 'thumbnail.dart';

class StreamsLargeThumbnailView extends StatelessWidget {
  final List<dynamic> infoItems;
  final bool shrinkWrap;
  final Function(dynamic)? onDelete;
  final bool allowSaveToFavorites;
  final bool allowSaveToWatchLater;
  final Function? onReachingListEnd;
  final scaffoldKey;

  StreamsLargeThumbnailView({
    required this.infoItems,
    this.shrinkWrap = false,
    this.onDelete,
    this.allowSaveToFavorites = true,
    this.allowSaveToWatchLater = true,
    this.onReachingListEnd,
    this.scaffoldKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (infoItems.isNotEmpty) {
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = 200.0;
          if (maxScroll - currentScroll <= delta) onReachingListEnd!();
          return true;
        },
        child: ListView.builder(
            addAutomaticKeepAlives: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: kToolbarHeight * 2),
            itemCount: infoItems.length,
            itemBuilder: (context, index) {
              dynamic infoItem = infoItems[index];
              return FadeInTransition(
                duration: Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: 16,
                      top: index == 0 ? 12 : 0,
                      left: 12,
                      right: 12),
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.player, arguments: infoItem);
                      },
                      child: false
                          ? _channelWidget(context, infoItem)
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _thumbnailWidget(infoItem)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: _infoItemDetails(context, infoItem),
                                )
                              ],
                            )),
                ),
              );
            }),
      );
    } else {
      return ListView.builder(
        itemCount: infoItems.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 12 : 0),
            child: _shimmerTile(context),
          );
        },
      );
    }
  }

  Widget _channelWidget(BuildContext context, infoItem) {
    return Container();
  }

  Widget _thumbnailWidget(infoItem) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Thumbnail(ratio: 16 / 9, url: infoItem.thumbnailUrl),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
              margin: EdgeInsets.only(right: 10, bottom: 10),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(3)),
              child: _textDuration(infoItem)),
        ),
        if (false)
          Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            height: 25,
            child: Center(
              child: Icon(EvaIcons.musicOutline, color: Colors.white, size: 20),
            ),
          )
      ],
    );
  }

  Widget _infoItemDetails(BuildContext context, infoItem) {
    return Row(
      children: [
        _avatarChannel(context, infoItem as Video),
        SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${infoItem.title}",
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Product Sans',
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                _statisticsDetail(context, infoItem),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _shimmerTile(context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12, right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Shimmer.fromColors(
                baseColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                highlightColor: Theme.of(context).cardColor,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.6),
                  highlightColor: Theme.of(context).cardColor,
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.6),
                        highlightColor: Theme.of(context).cardColor,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                      SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.6),
                        highlightColor: Theme.of(context).cardColor,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _avatarChannel(BuildContext context, Video video) {
    final ChannelRepository _channelRepository = getIt<ChannelRepository>();
    return FutureBuilder(
      future: video.channel == null ? _channelRepository.getChannel(video.channelId ?? "") : null,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          video.channel = snapshot.data as ChannelModel;
        return AvatarChannel(url: video.channel?.thumbnailUrl);
      },
    );
  }

  Widget _statisticsDetail(BuildContext context, Video video) {
    final VideoRepository _videoRepository = getIt<VideoRepository>();
    return FutureBuilder(
        future: video.statisticsModel == null ? _videoRepository.getStatisticsVideo(video.id!) : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            video.statisticsModel = snapshot.data as StatisticsModel;
          }
          return Text(
            "${video.channelTitle}" +
                ("${" • " + NumberFormat.compact().format(double.parse(video.statisticsModel?.viewCount ?? '0')) + " views"}"
                    " ${video.publishedAt == null ? "" : " • " + '${video.publishedAt ?? '0'}'.timeAgo()}"),
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.color
                    ?.withOpacity(0.8),
                fontFamily: 'Product Sans'),
          );
        });
  }

  Widget _textDuration(Video video) {
    final VideoRepository _videoRepository = getIt<VideoRepository>();
    var duration = IsoDuration.parse('${video.contentDetailsModel?.duration ?? "PT0M0S"}');

    return FutureBuilder(
      future: video.contentDetailsModel == null ? _videoRepository.getContentDetails(video.id!) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          video.contentDetailsModel = snapshot.data as ContentDetailsModel;
          duration =
              IsoDuration.parse('${video.contentDetailsModel!.duration!}');
        }
        return Text(
          "${duration.minutes.ceil()}:" +
              "${duration.seconds.ceil() >= 10 ? duration.seconds.ceil() : "0${duration.seconds.ceil()}"}",
          style: TextStyle(
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 10),
        );
      },
    );
  }
}
