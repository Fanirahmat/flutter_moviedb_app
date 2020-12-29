import 'package:flutter_moviedb_app/model/video.dart';

class VideoResponse {
  final List<Video> videos;
  final String error;

  VideoResponse({this.videos, this.error});

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
      videos: (json['results'] as List).map((e) => Video.fromJson(e)).toList(),
      error: ""
    );
  }

  factory VideoResponse.withError(String error) {
    return VideoResponse(
      videos:List(),
      error: error
    );
  }
}
