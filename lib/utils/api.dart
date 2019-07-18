import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

getMovieList() async {
  const url = 'https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8D%97%E4%BA%AC&start=0&count=10';
  var res = await http.get(url);
  if (res.statusCode == 200) {
    var jsonRes = convert.jsonDecode(res.body);
    return jsonRes['subjects'];
  } else {
    print("Request failed with status: ${res.statusCode}.");
  }
}

getMovieDetail(id) async {
  var url = 'https://api.douban.com/v2/movie/subject/$id?apikey=0b2bdeda43b5688921839c8ecb20399b';
  var res = await http.get(url);
  if (res.statusCode == 200) {
    return convert.jsonDecode(res.body);
  } else {
    print("Request failed with status: ${res.statusCode}.");
  }
}