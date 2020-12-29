import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_now_playing_bloc.dart';
import 'package:flutter_moviedb_app/model/movie.dart';
import 'package:flutter_moviedb_app/model/movie_response.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;

class NowPlayingAdapter extends StatefulWidget {
  @override
  _NowPlayingAdapterState createState() => _NowPlayingAdapterState();
}

class _NowPlayingAdapterState extends State<NowPlayingAdapter> {
  @override
  void initState() {
    super.initState();
    nowPlayingMoviesBloc..getMovie();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _errorWidget(snapshot.data.error, context);
          }
          return _nowPlayingWidget(snapshot.data, context);
        } else if (snapshot.hasError) {
          return _errorWidget(snapshot.error, context);
        } else {
          return _loadingWidget();
        }
      },
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
      children: [Text("$error", style: TextStyle(color: Colors.white),)],
    ),
  );
}

Widget _nowPlayingWidget(MovieResponse data, BuildContext context) {
  List<Movie> movies = data.movies;
  if (movies.length == 0) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text("no movies")],
      ),
    );
  } else {
    return Container(
      height: 220,
      child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8.0,
          padding: EdgeInsets.all(5.0),
          indicatorColor: style.Colors.titleColor,
          indicatorSelectorColor: style.Colors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.take(5).length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original" +
                                      movies[index].backPoster),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                style.Colors.mainColor.withOpacity(1.0),
                                style.Colors.mainColor.withOpacity(0.0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.0, 0.9])),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Icon(FontAwesomeIcons.playCircle, color: style.Colors.secondColor, size: 40.0,)
                    ),
                    Positioned(
                      bottom: 30.0,
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0,right: 10.0),
                        width: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movies[index].title, style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                            ),)
                          ],
                        ),
                      )
                    )
                  ],
                );
              }),
          length: movies.take(5).length),
    );
  }
}
