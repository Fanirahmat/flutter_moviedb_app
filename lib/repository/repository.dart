import 'package:dio/dio.dart';
import 'package:flutter_moviedb_app/model/cast_response.dart';
import 'package:flutter_moviedb_app/model/genre_response.dart';
import 'package:flutter_moviedb_app/model/movie_detail_response.dart';
import 'package:flutter_moviedb_app/model/movie_response.dart';
import 'package:flutter_moviedb_app/model/person_response.dart';
import 'package:flutter_moviedb_app/model/video_response.dart';

class MovieRepository {
  final String apiKey = "e6b7d42d5a9eda503364216b0bc91f01";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();

  var getPopularMovieUrl = "$mainUrl/movie/top_rated";
  var getMovieUrl = "$mainUrl/discover/movie";
  var getPlayingUrl = "$mainUrl/movie/now_playing";
  var getGenreUrl = "$mainUrl/genre/movie/list";
  var getPersonUrl = "$mainUrl/trending/person/week";
  var getDetailMovieUrl = "$mainUrl/movie";

  Future<MovieResponse> getMovies() async {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1};

    try {
      Response response =
          await _dio.get(getPopularMovieUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception occured : $error stackTrace $stackTrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getNowPlayingMovies() async {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1};

    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception occured : $error stackTrace $stackTrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<GenreResponse> getGenre() async {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1};

    try {
      Response response = await _dio.get(getGenreUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception occured : $error stackTrace $stackTrace");
      return GenreResponse.withError("$error");
    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {
      "api_key": apiKey,
    };

    try {
      Response response = await _dio.get(getPersonUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception occured : $error stackTrace $stackTrace");
      return PersonResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovieByGenre(int idGenre) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
      "page": 1,
      "with_genres": idGenre
    };

    try {
      Response response = await _dio.get(getMovieUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception occured : $error stackTrace $stackTrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieDetailResponse> getDetailMovie(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
    };

    try {
      Response response = await _dio.get(getDetailMovieUrl + "/$id", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (error, stackTrace){
      print("Exception occured : $error stackTrace $stackTrace");
      return MovieDetailResponse.withError("$error");
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
    };

    try {
      Response response = await _dio.get(getDetailMovieUrl + "/$id" + "/credits", queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stackTrace){
      print("Exception occured : $error stackTrace $stackTrace");
      return CastResponse.withError("$error");
    }
  }

  Future<MovieResponse> getSimilarMovie(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
    };

    try {
      Response response = await _dio.get(getDetailMovieUrl + "/$id" + "/similar", queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace){
      print("Exception occured : $error stackTrace $stackTrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<VideoResponse> getMovieVideos(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US",
    };

    try {
      Response response = await _dio.get(getDetailMovieUrl + "/$id" + "/videos", queryParameters: params);
      return VideoResponse.fromJson(response.data);
    } catch (error, stackTrace){
      print("Exception occured : $error stackTrace $stackTrace");
      return VideoResponse.withError("$error");
    }
  }

  

}
