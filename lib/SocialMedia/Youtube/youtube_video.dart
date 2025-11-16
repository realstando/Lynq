/// Model class representing a YouTube video with its metadata
class YouTubeVideo {
  final String videoId;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishedAt;
  final String duration;
  final String viewCount;

  /// Constructor to create a YouTubeVideo instance
  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
    required this.duration,
    required this.viewCount,
  });

  /// Factory constructor to create a YouTubeVideo from JSON
  /// Returns empty strings as defaults for missing fields
  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      videoId: json['videoId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      channelTitle: json['channelTitle'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      duration: json['duration'] ?? '',
      viewCount: json['viewCount'] ?? '',
    );
  }

  /// Converts the YouTubeVideo instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'channelTitle': channelTitle,
      'publishedAt': publishedAt,
      'duration': duration,
      'viewCount': viewCount,
    };
  }
}
