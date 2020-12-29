import 'package:flutter_moviedb_app/model/person_response.dart';
import 'package:flutter_moviedb_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class PersonListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonResponse> _subject =
      BehaviorSubject<PersonResponse>();

  getPerson() async {
    PersonResponse response = await _repository.getPersons();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<PersonResponse> get subject => _subject;
}

final personBloc = PersonListBloc();
