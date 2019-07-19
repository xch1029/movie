import 'package:flutter/material.dart';
import 'package:movie/widgets/detail/detailTop.dart';
import 'package:movie/widgets/detail/rateing.dart';
import 'package:movie/widgets/detail/actors.dart';
import 'package:movie/widgets/detail/photos.dart';
import 'package:movie/widgets/detail/comments.dart';
import 'package:movie/utils/api.dart' as api;

class MovieDetail extends StatefulWidget {
  final id;
  MovieDetail({Key key, this.id}) : super(key: key);

  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  var _data = {};

  @override
  void initState() {
    super.initState();
    this.init();
  }

  init() async {
    var res = await api.getMovieDetail(widget.id);
    setState(() {
      _data = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _data.isEmpty
          ? null
          : SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    MovieDetailTop(data: _data),
                    Rate(count: _data['ratings_count'], rating: _data['rating']),
                    Container(padding: EdgeInsets.all(10),child: Text(_data['summary'])),
                    Actors(directors: _data['directors'], casts: _data['casts']),
                    Photos(photos: _data['photos'],),
                    Comments(comments: _data['popular_comments']),
                  ],
                ),
              ),
            ),
    );
  }
}
