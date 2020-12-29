import 'package:flutter/material.dart';
import 'package:flutter_moviedb_app/bloc/get_casts_bloc.dart';
import 'package:flutter_moviedb_app/model/cast.dart';
import 'package:flutter_moviedb_app/model/cast_response.dart';
import 'package:flutter_moviedb_app/style/theme.dart' as style;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Casts extends StatefulWidget {
  final int id;
  Casts({Key key, @required this.id}) : super(key: key);

  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;
  _CastsState(this.id);

  @override
  void initState() {
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose() {
    super.dispose();
    castsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "CASTS",
            style: TextStyle(
                color: style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<CastResponse>(
            stream: castsBloc.subject.stream,
            builder: (context, AsyncSnapshot<CastResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _errorWidget(snapshot.data.error, context);
                }
                return _castsWidget(snapshot.data, context);
              } else if (snapshot.hasError) {
                return _errorWidget(snapshot.error, context);
              } else {
                return _loadingWidget();
              }
            })
      ],
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

  Widget _castsWidget(CastResponse data, BuildContext context) {
    List<Cast> casts = data.casts;
    return Container(
      height: 130.0,
      padding: EdgeInsets.only(left: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
        itemBuilder: (context, i) {
          return Container(
            padding: EdgeInsets.only(top: 10.0, right: 10.0),
            width: 100.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (casts[i].img != null)
                    ? Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w300/" +
                                        casts[i].img))),
                      )
                    : Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: style.Colors.secondColor),
                        child: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                        ),
                      ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  casts[i].name,
                  maxLines: 2,
                  style: TextStyle(
                      height: 1.4,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9.0),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  casts[i].character,
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                      color: style.Colors.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 7.0),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
