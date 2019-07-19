> 使用Flutter开发一款App是一件非常愉快的事情，其出色的性能、跨多端以及数量众多的原生组件都是我们选择Flutter的理由！今天我们就来使用Flutter开发一款电影类的App，先看下App的截图。

![App截图](http://qiniu.tbmao.com/flutterfluttermovie.jpg)

### 从main.dart开始
在Flutter里main.dart是应用开始的地方:
``` dart
import 'package:flutter/material.dart';
import 'package:movie/utils/router.dart' as router;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '电影',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}
```
一般的，在Flutter中管理路由有两种方式，一种是直接使用`Navigator.of(context).push()`，这种方式比较适合非常简单的应用，随着应用的不断发展，逻辑越来越多，推荐使用具名路由来管理应用，本文也是使用的这种方式。直接将路由挂在`MaterialApp`的`onGenerateRoute`字段上即可，具体的路由定义放在了单独的文件中进行管理`utils/router.dart`:
``` dart
import 'package:flutter/material.dart';
import 'package:movie/screens/home.dart';
import 'package:movie/screens/detail.dart';
import 'package:movie/screens/videoPlayer.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Home());
    case 'detail':
      var arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => MovieDetail(id: arguments));
    case 'video':
      var arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => VideoPage(url: arguments));
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
```
真是像极了前端的路由定义，先将组件import进来，然后在各自的路由中return即可。

### 首页
在首页中使用TabBar来展示"正在热映"和"TOP250":
``` dart
import 'package:flutter/material.dart';
import 'package:movie/screens/hot.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: '正在热映'),
            Tab(text: 'TOP250'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Hot(),
          Hot(history: true),
        ],
      ),
    );
  }
}

```
两个页面的布局是一样的，只有数据是不同的，所以我们复用这个页面`Hot`,传入`history`参数来代表是否为Top250页面

### 复用的Hot组件
- 在这个组件中，通过history字段来区分成两个页面。
- 在页面`initState`的生命周期中，请求数据，再进行相应的展示。
- 下拉刷新的功能是使用的RefreshIndicator组件，在其`onRefresh`中进行下拉时的逻辑处理。
- Flutter没有直接提供上拉加载的组件，但是也是很容易实现，通过`ListView`的controller来做判断即可：当前滚动的位置是否到达最大滚动位置`_scrollController.position.pixels == _scrollController.position.maxScrollExtent`
- 为了获得良好的用户体验，Tab来回切换的时候，我们不希望页面重新渲染，Flutter提供了混入类AutomaticKeepAliveClientMixin，重载`wantKeepAlive`即可，下面是完整的代码:
``` dart
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

```

### 电影的详情页面
点击单条电影时使用`Navigator.pushNamed(context, 'detail', arguments: data['id']);`即可跳转详情页，在详情页中通过`id`再请求接口获取详情:
``` dart
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
          ? Center(child: CircularProgressIndicator(),)
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

```
在详情页面中，我们封装了一些组件，这样能让项目更加容易阅读和维护，组件的具体实现就不详细介绍了，都是一些常用的原生组件，这些组件分别是：
- `widgets/detail/detailTop.dart` 页面顶部的电影概述
- `widgets/detail/rateing.dart` 评分组件
- `widgets/detail/actors.dart` 演员表
- `widgets/detail/photos.dart` 剧照
- `widgets/detail/comments.dart` 评论组件

### 真实数据来自哪里？
应用中的数据都是从豆瓣开发者api中拉取的，分别是，正在热映`in_theaters`，top250`top250`和电影详情`subject/id`三个接口,请求这些接口是需要`apikey`的，为了大家能方便请求数据，我将`apikey`上传到了github上，还请大家温柔点，不要将这个`apikey`干爆了。

### 相关链接
[源码仓库](https://github.com/xch1029/movie)
[博客地址](http://jser.tech/2019/07/19/flutter-movie)
[掘金地址](https://juejin.im/post/5d31ea42f265da1bbe5e3ea7)
