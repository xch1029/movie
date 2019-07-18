import 'package:flutter/material.dart';

class Rate extends StatelessWidget {
  final count;
  final rating;
  const Rate({Key key, this.count, this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 计算星占比
    List calcRateList() {
      var totalRate = rating['details'].values.reduce((a, b) => a + b);
      return List.generate(5, (int index) {
        return {
          'title': '${5 - index}星',
          'value': rating['details']['${5 - index}'] / (totalRate == 0 ? 1 :totalRate),
        };
      });
    }

    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
            children: calcRateList()
                .map((item) => Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Text(item['title']),
                        Expanded(
                          flex: 2,
                          child: LinearProgressIndicator(
                            value: item['value'],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text((100 * item['value']).toStringAsFixed(2)+ '%'),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              Text(rating['average'].toString()),
              Text(count.toString()),
            ],
          ),
        ),
      ],
    );
  }
}
