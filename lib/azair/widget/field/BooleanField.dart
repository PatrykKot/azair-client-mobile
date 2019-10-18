import 'package:flutter/material.dart';

class BooleanField extends StatefulWidget {
  final Function onChange;
  final String label;

  BooleanField({this.onChange, this.label});

  @override
  _BooleanFieldState createState() => _BooleanFieldState();
}

class _BooleanFieldState extends State<BooleanField> {
  var value = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<bool>(
      onChanged: (value) {
        setState(() {
          this.value = value;
        });

        widget.onChange(value);
      },
      value: value,
      items: [
        DropdownBooleanItem(text: 'Tak', value: true),
        DropdownBooleanItem(text: 'Nie', value: false)
      ].map((item) {
        return DropdownMenuItem(
            child: Text(item.text), value: item.value);
      }).toList(),
      decoration: InputDecoration(labelText: widget.label),
    );
  }
}

class DropdownBooleanItem {
  bool value;
  String text;

  DropdownBooleanItem({this.value, this.text});
}
