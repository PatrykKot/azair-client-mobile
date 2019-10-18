import 'package:flutter/material.dart';

class StringField extends StatefulWidget {
  final Function onChange;
  final String label;

  StringField({this.onChange, this.label});

  @override
  _StringFieldState createState() => _StringFieldState();
}

class _StringFieldState extends State<StringField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      widget.onChange(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: widget.label));
  }
}
