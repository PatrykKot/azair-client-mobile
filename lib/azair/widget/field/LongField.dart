import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LongField extends StatefulWidget {
  final Function onChange;
  final String label;
  final int initialValue;

  LongField({this.onChange, this.label, this.initialValue});

  @override
  _LongFieldState createState() => _LongFieldState();
}

class _LongFieldState extends State<LongField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue.toString();

    _controller.addListener(() {
      try {
        widget.onChange(int.parse(_controller.text));
      } catch (ex) {
        widget.onChange(null);
      }
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
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: false),
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: widget.label),
    );
  }
}
