import 'package:flutter_moviedb_app/model/genre.dart';

class GenreResponse {
  final List<Genre> genres;
  final String error;

  GenreResponse({this.genres, this.error});

  factory GenreResponse.fromJson(Map<String, dynamic> json) {
    return GenreResponse(
        genres:
            (json['genres'] as List).map((e) => Genre.fromJson(e)).toList(),
        error: ""
      );
  }

  factory GenreResponse.withError(String error) {
    return GenreResponse(
      genres: List(),
      error: error
    );
  }
}
