import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final String label;
  final Function onChange;

  DateField({this.label, this.onChange});

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(0),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      _controller.text = DateFormat('yyyy-MM-dd').format(date);
      widget.onChange(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Flexible(
        child: TextField(
            enabled: false,
            controller: _controller,
            decoration: InputDecoration(labelText: widget.label)),
      ),
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: pickDate,
      )
    ]);
  }
}
