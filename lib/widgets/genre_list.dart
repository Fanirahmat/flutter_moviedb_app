import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:flutter_moviedb_app/model/genre.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;
import 'package:flutter_moviedb_app/widgets/genre_movies.dart';

class GenresList extends StatefulWidget {
  final List<Genre> genres;
  GenresList({Key key, @required this.genres}) : super(key: key);

  @override
  _GenresListState createState() => _GenresListState(genres);
}

class _GenresListState extends State<GenresList>
    with SingleTickerProviderStateMixin {
  final List<Genre> genres;
  _GenresListState(this.genres);

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: genres.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        movieByGenreBloc..drainStream();
        
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307.0,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: style.Colors.mainColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: style.Colors.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: style.Colors.secondColor,
                indicatorWeight: 3.0,
                unselectedLabelColor: style.Colors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Text(
                      genre.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            preferredSize: Size.fromHeight(50.0),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: genres.map((Genre gen) {
              return GenreMovies(genreid: gen.id);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
