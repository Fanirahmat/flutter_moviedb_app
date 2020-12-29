class Movie {
  final int id;
  final String popularity;
  final String title;
  final String backPoster;
  final String poster;
  final String overview;
  final String rating;

  Movie(
      {this.id,
      this.popularity,
      this.title,
      this.backPoster,
      this.poster,
      this.overview,
      this.rating}
  );

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      popularity: json['popularity'].toString(),
      title: json['title'],
      backPoster: json['backdrop_path'],
      poster: json['poster_path'],
      overview: json['overview'],
      rating: json['vote_average'].toString()
    );
  }
}
