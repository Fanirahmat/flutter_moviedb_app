import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_genre_bloc.dart';
import 'package:flutter_moviedb_app/model/genre.dart';
import 'package:flutter_moviedb_app/model/genre_response.dart';
import 'package:flutter_moviedb_app/widgets/genre_list.dart';

class GenreAdapter extends StatefulWidget {
  @override
  _GenreAdapterState createState() => _GenreAdapterState();
}

class _GenreAdapterState extends State<GenreAdapter> {
  @override
  void initState() {
    super.initState();
    genreBloc..getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
        stream: genreBloc.subject.stream,
        builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _errorWidget(snapshot.data.error, context);
            }
            return _genreWidget(snapshot.data, context);
          } else if (snapshot.hasError) {
            return _errorWidget(snapshot.error, context);
          } else {
            return _loadingWidget();
          }
        });
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

  Widget _genreWidget(GenreResponse data, BuildContext context) {
    List<Genre> genres = data.genres;
    if (genres.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("no genres")],
        ),
      );
    } else {
      return GenresList(genres: genres);
    }
  }
