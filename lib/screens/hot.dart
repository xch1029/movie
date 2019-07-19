import 'package:flutter/material.dart';
import 'package:movie/utils/api.dart' as api;
import 'package:movie/widgets/movieItem.dart';

class Hot extends StatefulWidget {
  final bool history;
  Hot({Key key, this.history = false}) : super(key: key);

  _HotState createState() => _HotState();
}

class _HotState extends State<Hot> with AutomaticKeepAliveClientMixin {
  List _movieList = [];
  int start = 0;
  int total = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMore();
      }
    });
    this.query(init: true);
  }

  query({bool init = false}) async {
    Map res = await api.getMovieList(
        history: widget.history, start: init ? 0 : this.start);
    var start = res['start'];
    var total = res['total'];
    var subjects = res['subjects'];
    setState(() {
      if (init) {
        this._movieList = subjects;
      } else {
        this._movieList.addAll(subjects);
      }
      this.start = start + 10;
      this.total = total;
    });
  }

  Future<Null> _onRefresh() async {
    await this.query(init: true);
  }

  getMore() {
    if (start < total) {
      query();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: this._movieList.length,
        itemBuilder: (BuildContext context, int index) =>
            MovieItem(data: this._movieList[index]),
      ),
    );
  }
}
