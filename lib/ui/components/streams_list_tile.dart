import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../data/repository/video_repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/content_details_model.dart';
import '../../models/statistics_model.dart';
import '../../models/video_model.dart';
import '../../models/video_seach_model.dart';
import '../../stores/video/related_2_video_store.dart';
import '../animations/fade_in.dart';
import 'shimmer_container.dart';

class StreamsListTile extends StatelessWidget {
  final Video video;
  final Function(dynamic, int) onTap;
  bool isFirstLoad;
  final bool removePhysics;
  final bool topPadding;

  // final Function(dynamic) onDelete;
  final scaffoldKey;

  StreamsListTile(
      {required this.video,
      required this.onTap,
      this.isFirstLoad = true,
      this.removePhysics = false,
      this.topPadding = true,
      // required this.onDelete,
      this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final Related2VideoStore _relatedStore =
        Provider.of<Related2VideoStore>(context, listen: false);
    if (isFirstLoad && video.videosRelated == null) {
      _relatedStore.getVideosRelated(video.id!, true);
      isFirstLoad = false;
    }
    return Observer(builder: (context) {
      video.videosRelated = _relatedStore.videoListSearch;
      final listData = video.videosRelated?.videos ?? List.empty();
      return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: listData.isNotEmpty
              ? ListView.builder(
                  physics: removePhysics
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    VideoSearch video = listData[index];
                    if (video.id == null)
                      return SizedBox();
                    else
                      return FadeInTransition(
                        duration: Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: () => onTap(video, index),
                          child: Container(
                            color: Colors.transparent,
                            margin: EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: topPadding
                                    ? index == 0
                                        ? 12
                                        : 0
                                    : 0,
                                bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: FadeInImage(
                                            fadeInDuration:
                                                Duration(milliseconds: 300),
                                            placeholder:
                                                MemoryImage(kTransparentImage),
                                            image: NetworkImage(
                                                video.thumbnailUrl ?? ""),
                                            fit: BoxFit.fitWidth,
                                              imageErrorBuilder:
                                                  (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return ShimmerContainer(
                                                  height: 50,
                                                  width: 50,
                                                  borderRadius: BorderRadius.circular(100),
                                                );
                                              }
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          margin: EdgeInsets.all(6),
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: _textDuration(video),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
                                        child: Text(
                                          video.title ?? "",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Product Sans',
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8),
                                        child: _statisticsDetail(video),
                                      ),
                                    ],
                                  ),
                                ),
                                /*StreamsPopupMenu(
                          listData: video,
                          onDelete: onDelete != null
                            ? (item) => onDelete(item)
                            : null,
                          scaffoldKey: scaffoldKey,
                        )*/
                              ],
                            ),
                          ),
                        ),
                      );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: index == 0 ? 12 : 0,
                          bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerContainer(
                            height: 80,
                            width: 150,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerContainer(
                                  height: 15,
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(10),
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, top: 4, bottom: 8),
                                ),
                                ShimmerContainer(
                                  height: 15,
                                  width: 150,
                                  borderRadius: BorderRadius.circular(10),
                                  margin: EdgeInsets.only(left: 8),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ));
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
                fontSize: 8),
          );
        });
  }

  Widget _statisticsDetail(Video video) {
    final VideoRepository _videoRepository = getIt<VideoRepository>();
    return FutureBuilder(
        future: video.statisticsModel == null ? _videoRepository.getStatisticsVideo(video.id!) : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            video.statisticsModel = snapshot.data as StatisticsModel;
          }
          return Text(
            (video.channelTitle ?? "") +
                " • " +
                "${NumberFormat.compact().format(double.parse(video.statisticsModel?.viewCount ?? "0"))}" +
                " Views",
            style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.8),
                fontFamily: "Product Sans",
                fontSize: 12,
                letterSpacing: 0.2),
            overflow: TextOverflow.clip,
            maxLines: 1,
          );
        });
  }
}
