
import 'channel_model.dart';
import 'content_details_model.dart';
import 'statistics_model.dart';
import 'video_list_search.dart';

class Video {
  String? id;
  String? title;
  String? thumbnailUrl;
  String? channelTitle;
  String? publishedAt;
  String? channelId;
  String? uploaderUrl;
  String? uploaderName;
  ChannelModel? channel;
  StatisticsModel? statisticsModel;
  ContentDetailsModel? contentDetailsModel;
  VideoListSearch? videosRelated;
  Duration? lastDuration;
  String? author;
  String? uploadDate;
  String? description;
  String? duration;


  Video(
      {this.id,
      this.title,
      this.thumbnailUrl,
      this.channelTitle,
      this.publishedAt,
      this.channelId,
      this.uploaderUrl,
      this.uploaderName,
      this.channel,
      this.statisticsModel,
      this.contentDetailsModel});

  // pass in the individual results from searchresult['items']
  factory Video.fromMap(Map<String, dynamic> item) {
    return Video(
        id: item['id'],
        title: item['snippet']['title'],
        thumbnailUrl: item['snippet']['thumbnails']['high']['url'],
        // thumbnailUrl: item['snippet']['thumbnails']['medium']['url'],
        channelTitle: item['snippet']['channelTitle'],
        publishedAt: item['snippet']['publishedAt'],
        channelId: item['snippet']['channelId'],
        uploaderUrl: "",
        uploaderName: "");
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "thumbnailUrl": thumbnailUrl,
        "channelTitle": channelTitle,
        "publishedAt": publishedAt,
        "channelId": channelId,
        "uploaderUrl": '',
        "uploaderName": "",
        "avatarModel": channel,
        "statisticsModel": statisticsModel,
        "contentDetailsModel": contentDetailsModel
      };
}
