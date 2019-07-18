import 'package:flutter/material.dart';
import 'package:movie/utils/api.dart' as api;
import 'package:movie/widgets/movieItem.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _movieList = [];

  @override
  void initState() {
    super.initState();
    this.init();
  }

  init() async {
    List movieList = await api.getMovieList();
    setState(() {
      _movieList = movieList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('正在热映'),
      ),
      body: ListView.builder(
        itemCount: this._movieList.length,
        itemBuilder: (BuildContext context, int index) =>
            MovieItem(data: this._movieList[index]),
      ),
    );
  }
}
