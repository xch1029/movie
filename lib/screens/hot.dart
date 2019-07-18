import 'package:flutter/material.dart';
import 'package:movie/utils/api.dart' as api;
import 'package:movie/widgets/movieItem.dart';

class Hot extends StatefulWidget {
  final bool history;
  Hot({Key key, this.history=false}) : super(key: key);

  _HotState createState() => _HotState();
}

class _HotState extends State<Hot> with AutomaticKeepAliveClientMixin {
  List _movieList = [];

  @override
  void initState() {
    super.initState();
    this.init();
  }

  init() async {
    List movieList = await api.getMovieList(widget.history);
    setState(() {
      _movieList = movieList;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: this._movieList.length,
      itemBuilder: (BuildContext context, int index) =>
          MovieItem(data: this._movieList[index]),
    );
  }
}
