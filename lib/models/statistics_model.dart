class StatisticsModel {
  String? viewCount;
  String? likeCount;
  String? dislikeCount;
  String? favoriteCount;
  String? commentCount;

  StatisticsModel(
      {this.viewCount,
      this.likeCount,
      this.dislikeCount,
      this.favoriteCount,
      this.commentCount});

  factory StatisticsModel.fromJson(Map<String, dynamic> item) {
    return StatisticsModel(
        viewCount: item['statistics']['viewCount'],
        likeCount: item['statistics']['likeCount'],
        dislikeCount: item['statistics']['dislikeCount'],
        favoriteCount: item['statistics']['favoriteCount'],
        commentCount: item['statistics']['commentCount']);
  }

  Map<String, dynamic> toMap() => {
        "viewCount": viewCount,
        "likeCount": likeCount,
        "dislikeCount": dislikeCount,
        "favoriteCount": favoriteCount,
        "commentCount": commentCount,
      };
}
