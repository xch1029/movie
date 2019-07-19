import 'package:flutter/material.dart';

class Photos extends StatelessWidget {
  final List photos;
  const Photos({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('剧照'),
          trailing: Text('全部剧照'),
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              photos.length,
              (int index) => Container(
                padding: EdgeInsets.all(5),
                child: Image.network(
                  photos[index]['thumb'],
                  width: 180,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
