import 'package:flutter/cupertino.dart';
import 'package:flutter_moviedb_app/model/movie_response.dart';
import 'package:flutter_moviedb_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieListByGenreBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMOvieByGenre(int idGenre) async {
    MovieResponse response = await _repository.getMovieByGenre(idGenre);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final movieByGenreBloc = MovieListByGenreBloc();
