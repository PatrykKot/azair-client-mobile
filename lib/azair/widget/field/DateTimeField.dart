import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeField extends StatefulWidget {
  final String label;
  final Function onChange;

  DateTimeField({this.label, this.onChange});

  @override
  _DateTimeFieldState createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
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
      final time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (time != null) {
        final localDate = date.toLocal();
        final resultDateTime = DateTime(localDate.year, localDate.month,
            localDate.day, time.hour, time.minute);

        _controller.text =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(resultDateTime);
        widget.onChange(resultDateTime);
      }
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
        icon: Icon(Icons.date_range),
        onPressed: pickDate,
      )
    ]);
  }
}
