import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const apikey = '0b2bdeda43b5688921839c8ecb20399b';
// 正在上映或者历史top
getMovieList({history=false,start=0,count=10}) async {
  var url =
      'https://api.douban.com/v2/movie/${history ? 'top250' : 'in_theaters'}?apikey=$apikey&city=%E5%8D%97%E4%BA%AC&start=$start&count=$count';
  var res = await http.get(url);
  if (res.statusCode == 200) {
    return convert.jsonDecode(res.body);
  } else {
    print("Request failed with status: ${res.statusCode}.");
  }
}

getMovieDetail(id) async {
  var url = 'https://api.douban.com/v2/movie/subject/$id?apikey=$apikey';
  var res = await http.get(url);
  if (res.statusCode == 200) {
    return convert.jsonDecode(res.body);
  } else {
    print("Request failed with status: ${res.statusCode}.");
  }
}
