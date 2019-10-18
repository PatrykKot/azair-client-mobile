import 'package:azair_client/azair/model/AirportModel.dart';
import 'package:azair_client/azair/page/AirportPickerPage.dart';
import 'package:flutter/material.dart';

class AirportPicker extends StatefulWidget {
  final List<AirportModel> airports;
  final String label;

  AirportPicker({this.airports, this.label});

  @override
  _AirportPickerState createState() => _AirportPickerState();
}

class _AirportPickerState extends State<AirportPicker> {
  onClick() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AirportPickerPage(airports: widget.airports)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.label,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: onClick,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[],
            ),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
