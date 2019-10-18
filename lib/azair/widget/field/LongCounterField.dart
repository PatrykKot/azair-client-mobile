import 'package:flutter/material.dart';

class LongCounterField extends StatefulWidget {
  final Function onChange;
  final String label;
  final int value;
  final int min;
  final int max;

  LongCounterField({this.onChange, this.label, this.value, this.max, this.min});

  @override
  _LongCounterFieldState createState() => _LongCounterFieldState();
}

class _LongCounterFieldState extends State<LongCounterField> {
  @override
  void initState() {
    super.initState();
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
          height: 10,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  final value = widget.value;
                  if (value > widget.min) {
                    widget.onChange(value - 1);
                  }
                },
                icon: CircleAvatar(
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.black45,
                ),
              ),
              Text(
                widget.value.toString(),
                style: TextStyle(fontSize: 30),
              ),
              IconButton(
                onPressed: () {
                  final value = widget.value;
                  if (value < widget.max) {
                    widget.onChange(value + 1);
                  }
                },
                icon: CircleAvatar(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.black45,
                ),
              ),
            ],
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
      ],
    );
  }
}
