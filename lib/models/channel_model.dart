
import 'channel_statistics.dart';

class ChannelModel {
  String? id;
  String? title;
  String? thumbnailUrl;
  String? description;
  ChannelStatisticsModel? channelStatisticsModel;

  ChannelModel(
      {this.id,
      this.title,
      this.thumbnailUrl,
      this.description,
      this.channelStatisticsModel});

  factory ChannelModel.fromJson(Map<String, dynamic> item) {
    return ChannelModel(
      id: item['id'],
      title: item['snippet']['title'],
      thumbnailUrl: item['snippet']['thumbnails']['default']['url'],
      description: item['snippet']['description'],
    );
  }

  Map<String, dynamic> toMap() => {
        "thumbnailUrl": thumbnailUrl,
      };
}
