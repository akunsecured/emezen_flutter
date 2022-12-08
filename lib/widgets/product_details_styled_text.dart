import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class ProductDetailsStyledText extends StatelessWidget {
  final String text;

  const ProductDetailsStyledText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: text,
      tags: {
        'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
        'i': StyledTextTag(style: const TextStyle(fontStyle: FontStyle.italic)),
        'u': StyledTextTag(
            style: const TextStyle(decoration: TextDecoration.underline)),
        'h1': StyledTextTag(
            style: const TextStyle(fontSize: 24.0)),
        'h2': StyledTextTag(
            style: const TextStyle(fontSize: 20.0)),
        'h3': StyledTextTag(
            style: const TextStyle(fontSize: 16.0)),
      },
    );
  }
}
