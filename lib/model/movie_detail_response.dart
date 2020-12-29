import 'package:flutter_moviedb_app/model/movie_detail.dart';

class MovieDetailResponse {
  final MovieDetail movieDetail;
  final String error;

  MovieDetailResponse({this.movieDetail, this.error});

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailResponse(
        movieDetail: MovieDetail.fromJson(json), error: "");
  }

  factory MovieDetailResponse.withError(String error) {
    return MovieDetailResponse(
        movieDetail: MovieDetail.fromJson(null), 
        error: error
      );
  }
}
