import 'package:flutter_moviedb_app/model/cast.dart';

class CastResponse {
  final List<Cast> casts;
  final String error;

  CastResponse({this.casts, this.error});

  factory CastResponse.fromJson(Map<String, dynamic> json) {
    return CastResponse(
        casts: (json['cast'] as List).map((e) => Cast.fromJson(e)).toList(),
        error: "");
  }

  factory CastResponse.withError(String error) {
    return CastResponse(
        casts: List(),
        error: error);
  }
}
