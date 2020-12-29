import 'package:flutter_moviedb_app/model/movie.dart';

class MovieResponse {
  final List<Movie> movies;
  final String error;

  MovieResponse({this.movies, this.error});

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
        movies:
            (json['results'] as List).map((e) => Movie.fromJson(e)).toList(),
        error: "");
  }

  factory MovieResponse.withError(String error) {
    return MovieResponse(
      movies: List(),
      error: error
    );
  }
}
