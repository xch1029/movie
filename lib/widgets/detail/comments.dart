import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final List comments;
  const Comments({Key key, this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget commentItem(data) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(data['author']['avatar'])),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(data['author']['name'],
                          style: TextStyle(fontSize: 16)),
                      Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Icon(Icons.favorite,color: Colors.redAccent,size: 16,),
                          Text(data['useful_count'].toString()),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '给这部作品打了' + data['rating']['value'].toString() + '星',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(data['content']),
                  Text(data['created_at'],
                      style: TextStyle(fontSize: 12, color: Colors.grey))
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(comments.length, (int index) {
        return commentItem(comments[index]);
      }),
    );
  }
}
