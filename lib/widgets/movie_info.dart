import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_movies_detail_bloc.dart';
import 'package:flutter_moviedb_app/model/movie_detail.dart';
import 'package:flutter_moviedb_app/model/movie_detail_response.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;

class MovieInfo extends StatefulWidget {
  final int id;
  MovieInfo({Key key, @required this.id}) : super(key: key);
  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  final int id;
  _MovieInfoState(this.id);

  @override
  void initState() {
    super.initState();
    moviesDetailBloc..getMovieDetail(id);
  }

  @override
  void dispose() {
    super.dispose();
    moviesDetailBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: moviesDetailBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieDetailResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _errorWidget(snapshot.data.error, context);
          }
          return _movieDetailWidget(snapshot.data, context);
        } else if (snapshot.hasError) {
          return _errorWidget(snapshot.error, context);
        } else {
          return _loadingWidget();
        }
      },
    );
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

  Widget _movieDetailWidget(MovieDetailResponse data, BuildContext context) {
    MovieDetail detail = data.movieDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BUDGET",
                    style: TextStyle(
                        color: style.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    detail.budget.toString() + " USD",
                    style: TextStyle(
                        color: style.Colors.secondColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DURATION",
                    style: TextStyle(
                        color: style.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    detail.runtime.toString() + " min",
                    style: TextStyle(
                        color: style.Colors.secondColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RELEASE DATE",
                    style: TextStyle(
                        color: style.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    detail.releaseDate.toString(),
                    style: TextStyle(
                        color: style.Colors.secondColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("GENRES", style: TextStyle(
                color: style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0
              ),),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 30.0,
                padding: EdgeInsets.only(top: 5.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: detail.genres.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.white
                            )
                          ),
                          child: Text(
                            detail.genres[i].name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 9.0
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
