import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/video_model.dart';
import '../stores/video/channel_statistics_store.dart';
import '../stores/video/channel_store.dart';
import 'avatar_channel.dart';

class ChannelInfo extends StatelessWidget {
  final Video video;

  ChannelInfo({required this.video});

  @override
  Widget build(BuildContext context) {
    ChannelStore channelStore = Provider.of<ChannelStore>(context, listen: false);
    if (video.channel == null) {
      channelStore.getChannel(video.channelId ?? "");
    }
    return Observer(builder: (context) {
      if (channelStore.channel != null && channelStore.channel?.id == video.channelId) video.channel = channelStore.channel;
      return InkWell(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: AvatarChannel(url: video.channel?.thumbnailUrl),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.channel?.title ?? "",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1!.color,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Product Sans',
                              fontSize: 16,
                            ),
                          ),
                          _statisticsChannel(context, video)
                        ],
                      ),
                    ))
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _statisticsChannel(BuildContext context, Video video) {
    ChannelStatisticsStore channelStatisticsStore =
        Provider.of<ChannelStatisticsStore>(context, listen: false);
    if (video.channel?.channelStatisticsModel == null) channelStatisticsStore.getChannelStatistics(video.channelId ?? "");
    return Observer(builder: (context) {
      video.channel?.channelStatisticsModel = channelStatisticsStore.statistics;
      return Text(
        "${NumberFormat.compact().format(double.parse(video.channel?.channelStatisticsModel?.subscriberCount ?? "0"))} subs",
        style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.8),
            fontFamily: "Product Sans",
            fontSize: 12,
            letterSpacing: 0.2),
      );
    });
  }
}
