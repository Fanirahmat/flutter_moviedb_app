import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_persons_bloc.dart';
import 'package:flutter_moviedb_app/model/person.dart';
import 'package:flutter_moviedb_app/model/person_response.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonAdapter extends StatefulWidget {
  @override
  _PersonAdapterState createState() => _PersonAdapterState();
}

class _PersonAdapterState extends State<PersonAdapter> {
  @override
  void initState() {
    super.initState();
    personBloc..getPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "TRENDING PERSONS ON THIS WEEK",
            style: TextStyle(
                color: style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<PersonResponse>(
            stream: personBloc.subject.stream,
            builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _errorWidget(snapshot.data.error, context);
                }
                return _personWidget(snapshot.data, context);
              } else if (snapshot.hasError) {
                return _errorWidget(snapshot.error, context);
              } else {
                return _loadingWidget();
              }
            })
      ],
    );
  }
}

Widget _loadingWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(),
          ),
        )
      ],
    ),
  );
}

Widget _errorWidget(String error, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$error",
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}

Widget _personWidget(PersonResponse data, BuildContext context) {
  List<Person> persons = data.persons;
  return Container(
    height: 130.0,
    padding: EdgeInsets.only(
      left: 10.0,
    ),
    child: ListView.builder(
        itemCount: persons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Container(
            width: 100.0,
            padding: EdgeInsets.only(top: 10.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (persons[i].profileImg == null)
                    ? Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: style.Colors.secondColor),
                        child: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w200" +
                                      persons[i].profileImg),
                              fit: BoxFit.cover),
                        ),
                      ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  persons[i].name,
                  maxLines: 2,
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 9.0
                  ),
                ),
                 SizedBox(
                  height: 3.0,
                ),
                Text("trending for ${persons[i].known}",style: TextStyle(
                  color: style.Colors.titleColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 7.0
                ),)
              ],
            ),
          );
        }),
  );
}
