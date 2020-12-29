import 'package:flutter_moviedb_app/model/genre.dart';

class MovieDetail {
  final int id;
  final bool adult;
  final int budget;
  final List<Genre> genres;
  final String releaseDate;
  final int runtime;

  MovieDetail( 
      {this.id,
      this.adult,
      this.budget,
      this.genres,
      this.releaseDate,
      this.runtime});

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      adult: json['adult'],
      budget: json['budget'],
      genres: (json['genres'] as List).map((e) => Genre.fromJson(e)).toList(),
      releaseDate: json['release_date'],
      runtime: json['runtime']
    );
  }
}
