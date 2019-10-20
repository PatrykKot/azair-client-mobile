import 'package:flutter/material.dart';

class LongCounterField extends StatefulWidget {
  final Function onChange;
  final String label;
  final int value;
  final int min;
  final int max;
  final IconData icon;

  LongCounterField(
      {this.onChange, this.label, this.value, this.max, this.min, this.icon});

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(widget.icon),
            Padding(
              padding: EdgeInsets.only(right: 4),
            ),
            Text(
              widget.label,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Transform.scale(
                scale: 0.9,
                child: CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      final value = widget.value;
                      if (value > widget.min) {
                        widget.onChange(value - 1);
                      }
                    },
                    icon: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(
                widget.value.toString(),
                style: TextStyle(fontSize: 25),
              ),
              Transform.scale(
                scale: 0.9,
                child: CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      final value = widget.value;
                      if (value < widget.max) {
                        widget.onChange(value + 1);
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
