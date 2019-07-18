import 'package:flutter/material.dart';

class Actors extends StatelessWidget {
  final List directors;
  final List casts;
  const Actors({Key key, this.directors, this.casts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget actorItem(image, name, action) {
      return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Image.network(
              image,
              width: 100,
            ),
            Text(name),
            Text(action),
          ],
        ),
      );
    }

    List actorsList = [...directors, ...casts];

    return Column(
      children: <Widget>[
        ListTile(title: Text('演职人员'), trailing: Text('全部>'),),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actorsList.length,
            itemBuilder: (BuildContext context, int index) {
              return actorItem(actorsList[index]['avatars']['small'],
                  actorsList[index]['name'], '导演');
            },
          ),
        ),
      ],
    );
  }
}
