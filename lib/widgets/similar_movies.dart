import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_movies_similar_bloc.dart';
import 'package:flutter_moviedb_app/model/movie.dart';
import 'package:flutter_moviedb_app/model/movie_response.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SimilarMoviesAdapter extends StatefulWidget {
  final int id;
  SimilarMoviesAdapter({Key key, @required this.id}) : super(key: key);

  @override
  _SimilarMoviesAdapterState createState() => _SimilarMoviesAdapterState(id);
}

class _SimilarMoviesAdapterState extends State<SimilarMoviesAdapter> {
  final int id;
  _SimilarMoviesAdapterState(this.id);

  @override
  void initState() {
    super.initState();
    similarMovieBloc..getSimilarMovies(id);
  }

  @override
  void dispose() {
    super.dispose();
    similarMovieBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "SIMILAR MOVIES",
            style: TextStyle(
                color: style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieResponse>(
            stream: similarMovieBloc.subject.stream,
            builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _errorWidget(snapshot.data.error, context);
                }
                return _topMoviesWidget(snapshot.data, context);
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

Widget _topMoviesWidget(MovieResponse data, BuildContext context) {
  List<Movie> movies = data.movies;
  if (movies.length == 0) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text("no movies on this genre")],
      ),
    );
  } else {
    return Container(
      height: 270.0,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, position) {
            return Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 10.0,
              ),
              child: Column(
                children: [
                  (movies[position].poster == null)
                      ? Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                              color: style.Colors.secondColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              shape: BoxShape.rectangle),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                EvaIcons.filmOutline,
                                color: Colors.white,
                                size: 50.0,
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w200" +
                                          movies[position].poster),
                                  fit: BoxFit.cover)),
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 120.0,
                    child: Text(
                      movies[position].title,
                      style: TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        movies[position].rating.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      RatingBar.builder(
                        itemSize: 8.0,
                        initialRating:
                            double.parse(movies[position].rating) / 2,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          EvaIcons.star,
                          color: style.Colors.secondColor,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      )
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
