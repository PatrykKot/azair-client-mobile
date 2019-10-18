import 'package:azair_client/azair/model/ResultModel.dart';
import 'package:flutter/material.dart';

class ResultTile extends StatelessWidget {
  final ResultModel result;

  ResultTile({this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(result.fromFlight.from),
                Text(result.fromFlight.to),
                SizedBox(height: 15),
                Text(result.lengthOfStay),
                SizedBox(height: 15),
                Text(result.toFlight.from),
                Text(result.toFlight.to)
              ],
            ),
            Container(
              child: Text(
                result.price,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
