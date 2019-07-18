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
