import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coding_prog/SocialMedia/Youtube/youtube_video.dart';

class YouTubeService {
  // You'll need to get your own API key from Google Cloud Console
  // https://console.cloud.google.com/
  // Enable YouTube Data API v3 and create credentials
  static const String API_KEY = 'AIzaSyD-3KZf9mtleSA9B98WjnRAu-y55kpb3GI';
  static const String BASE_URL = 'https://www.googleapis.com/youtube/v3';

  Future<List<YouTubeVideo>> searchVideos(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$BASE_URL/search?part=snippet&q=$query&type=video&maxResults=20&key=$API_KEY',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<YouTubeVideo> videos = [];

        for (var item in data['items']) {
          final videoId = item['id']['videoId'];

          // Get video details for duration and view count
          final detailsResponse = await http.get(
            Uri.parse(
              '$BASE_URL/videos?part=contentDetails,statistics&id=$videoId&key=$API_KEY',
            ),
          );

          if (detailsResponse.statusCode == 200) {
            final detailsData = json.decode(detailsResponse.body);
            if (detailsData['items'].isNotEmpty) {
              final videoDetails = detailsData['items'][0];

              videos.add(
                YouTubeVideo(
                  videoId: videoId,
                  title: item['snippet']['title'],
                  description: item['snippet']['description'],
                  thumbnailUrl: item['snippet']['thumbnails']['high']['url'],
                  channelTitle: item['snippet']['channelTitle'],
                  publishedAt: _formatDate(item['snippet']['publishedAt']),
                  duration: _formatDuration(
                    videoDetails['contentDetails']['duration'],
                  ),
                  viewCount: _formatViewCount(
                    videoDetails['statistics']['viewCount'],
                  ),
                ),
              );
            }
          }
        }

        return videos;
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  String _formatDuration(String duration) {
    // Convert ISO 8601 duration (PT1H2M10S) to readable format (1:02:10)
    duration = duration.replaceAll('PT', '');

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (duration.contains('H')) {
      hours = int.parse(duration.split('H')[0]);
      duration = duration.split('H')[1];
    }

    if (duration.contains('M')) {
      minutes = int.parse(duration.split('M')[0]);
      duration = duration.split('M')[1];
    }

    if (duration.contains('S')) {
      seconds = int.parse(duration.split('S')[0]);
    }

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _formatViewCount(String count) {
    int views = int.parse(count);

    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    } else {
      return '$views views';
    }
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    Duration difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }
}
