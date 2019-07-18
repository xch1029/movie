import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final List comments;
  const Comments({Key key, this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget commentItem(data) {
      return Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(data['author']['avatar']),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(data['author']['name']),
                    Text('点赞' + data['useful_count'].toString()),
                  ],
                ),
                Text('给这部作品打了' + data['rating']['value'].toString() + '星'),
                Text(data['content']),
                Text(data['created_at'])
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: List.generate(comments.length, (int index) {
        return commentItem(comments[index]);
      }),
    );
  }
}
