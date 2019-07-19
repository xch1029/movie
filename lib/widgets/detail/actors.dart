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
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                image,
                width: 100,
              ),
            ),
            Text(name),
            Text(action,style: TextStyle(fontSize: 12,color: Colors.grey),),
          ],
        ),
      );
    }

    List actorsList = [
      ...directors.map((item) {
        item['director'] = true;
        return item;
      }),
      ...casts.map((item) {
        item['director'] = false;
        return item;
      }),
    ];

    return Column(
      children: <Widget>[
        ListTile(
          title: Text('演职人员'),
          trailing: Text('全部>'),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actorsList.length,
            itemBuilder: (BuildContext context, int index) {
              return actorItem(
                actorsList[index]['avatars']['small'],
                actorsList[index]['name'],
                actorsList[index]['director'] ? '导演' : '主演',
              );
            },
          ),
        ),
      ],
    );
  }
}
