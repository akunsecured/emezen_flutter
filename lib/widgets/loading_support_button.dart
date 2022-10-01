import 'package:flutter/material.dart';

class LoadingSupportButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final Color? buttonColor;
  final Color? progressIndicatorColor;
  final Function()? onPressed;

  const LoadingSupportButton(
      {Key? key,
      required this.isLoading,
      required this.text,
      this.buttonColor,
      this.progressIndicatorColor,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: buttonColor != null
            ? ElevatedButton.styleFrom(primary: buttonColor)
            : null,
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: progressIndicatorColor ?? Colors.black))
            : const Text('Sign in'),
      );
}
