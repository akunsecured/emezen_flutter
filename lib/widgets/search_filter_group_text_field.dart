import 'package:flutter/material.dart';

class SearchFilterGroupTextField extends StatelessWidget {
  final String text;

  const SearchFilterGroupTextField(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
