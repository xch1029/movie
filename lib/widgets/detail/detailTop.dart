import 'package:flutter/material.dart';

class MovieDetailTop extends StatelessWidget {
  final data;
  const MovieDetailTop({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 130,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'video',
                  arguments: data['trailer_urls'][0]);
            },
            child: Stack(children: <Widget>[
              Image.network(
                data['images']['small'],
                width: 100,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 40,
                ),
              )
            ]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(data['original_title']),
              Text(data['aka'][0]),
              Text(data['genres'].join(', ')),
              Text('中国大陆 / ' +
                  data['mainland_pubdate'] +
                  ' / ' +
                  data['durations'][0]),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: data['wish_count'].toString(),
                    ),
                    TextSpan(text: '人想看')
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
