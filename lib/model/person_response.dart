import 'package:flutter_moviedb_app/model/person.dart';

class PersonResponse {
  final List<Person> persons;
  final String error;

  PersonResponse({this.persons, this.error});

  factory PersonResponse.fromJson(Map<String, dynamic> json) {
    return PersonResponse(
        persons:
            (json['results'] as List).map((e) => Person.fromJson(e)).toList(),
        error: ""
        );
  }

  factory PersonResponse.withError(String error) {
    return PersonResponse(
      persons: List(),
      error: error
    );
  }
}
