import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_movies_video_bloc.dart';
import 'package:flutter_moviedb_app/model/movie.dart';
import 'package:flutter_moviedb_app/model/video.dart';
import 'package:flutter_moviedb_app/model/video_response.dart';
import 'package:flutter_moviedb_app/screens/video_player.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;
import 'package:flutter_moviedb_app/widgets/casts.dart';
import 'package:flutter_moviedb_app/widgets/movie_info.dart';
import 'package:flutter_moviedb_app/widgets/similar_movies.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen({Key key, @required this.movie}) : super(key: key);
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;
  _MovieDetailScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    movieVideoBloc..getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideoBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.Colors.mainColor,
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: FloatingPosition(right: 20.0),
          floatingWidget: StreamBuilder<VideoResponse>(
            stream: movieVideoBloc.subject.stream,
            builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _errorWidget(snapshot.data.error, context);
                }
                return _videoWidget(snapshot.data, context);
              } else if (snapshot.hasError) {
                return _errorWidget(snapshot.error, context);
              } else {
                return _loadingWidget();
              }
            },
          ),
          expandedHeight: 200.0,
          slivers: [
            SliverAppBar(
              backgroundColor: style.Colors.mainColor,
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  (movie.title.length) > 40
                      ? movie.title.substring(0, 37) + "..."
                      : movie.title,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original" +
                                      movie.backPoster))),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0)
                          ])),
                    )
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(0.0),
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        movie.rating.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      RatingBar.builder(
                        itemSize: 8.0,
                        initialRating: double.parse(movie.rating) / 2,
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 20.0),
                  child: Text(
                    "OVERVIEW",
                    style: TextStyle(
                        color: style.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    movie.overview,
                    style: TextStyle(
                        color: Colors.white, fontSize: 12.0, height: 1.5),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                MovieInfo(id: movie.id),
                Casts(id: movie.id),
                SimilarMoviesAdapter(id: movie.id)
              ])),
            )
          ],
        );
      }),
    );
  }
}

Widget _loadingWidget() {
  return Container();
}

Widget _errorWidget(String error, BuildContext context) {
  return Center(
    child: Column(
      children: [Text("$error")],
    ),
  );
}

Widget _videoWidget(VideoResponse data, BuildContext context) {
  List<Video> videos = data.videos;
  return FloatingActionButton(
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                controller: YoutubePlayerController(initialVideoId: videos[0].key,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                ))
              )
          )
      );
    },
    backgroundColor: style.Colors.secondColor,
    child: Icon(Icons.play_arrow),
  );
}
