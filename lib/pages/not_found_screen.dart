import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: AppBar().preferredSize.height,
          padding: const EdgeInsets.all(12),
          child: const Image(
            image: AssetImage('assets/images/emezen-logo.png'),
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
