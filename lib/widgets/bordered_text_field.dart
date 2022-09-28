import 'package:flutter/material.dart';

class BorderedTextField extends StatefulWidget {
  final String _hintText;
  final TextEditingController _controller;
  final TextInputType _inputType;

  const BorderedTextField(this._controller, this._hintText, this._inputType,
      {Key? key})
      : super(key: key);

  @override
  State<BorderedTextField> createState() => _BorderedTextFieldState();
}

class _BorderedTextFieldState extends State<BorderedTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: TextFormField(
        keyboardType: widget._inputType,
        controller: widget._controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: widget._hintText, border: const OutlineInputBorder()),
      ),
    );
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
