import 'package:flutter_moviedb_app/model/movie_response.dart';
import 'package:flutter_moviedb_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMovie() async {
    MovieResponse response = await _repository.getMovies();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final movieBloc = MovieListBloc();
