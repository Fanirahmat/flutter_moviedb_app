import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;
import 'package:flutter_moviedb_app/widgets/genre_adapter.dart';
import 'package:flutter_moviedb_app/widgets/now_playing_adapter.dart';
import 'package:flutter_moviedb_app/widgets/person_adapter.dart';
import 'package:flutter_moviedb_app/widgets/top_movies_adapter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: style.Colors.mainColor,
        centerTitle: true,
        leading: Icon(EvaIcons.menu2Outline, color: Colors.white,),
        title: Text("Movie DB App"),
        actions: [
          IconButton(icon: Icon(EvaIcons.searchOutline, color: Colors.white,), onPressed: null)
        ],
      ),
      body: ListView(
        children: [
          NowPlayingAdapter(),
          GenreAdapter(),
          PersonAdapter(),
          TopMoviesAdapter()
        ],
      ),
    );
  }
}