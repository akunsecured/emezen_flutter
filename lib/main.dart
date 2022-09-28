import 'package:emezen/pages/home_screen.dart';
import 'package:emezen/pages/not_found_screen.dart';
import 'package:emezen/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const EmezenApp());
}

class EmezenApp extends StatelessWidget {
  const EmezenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emezen',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          appBarTheme:
              AppBarTheme(color: Colors.blueGrey.shade900, centerTitle: true)),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => const RegisterScreen());
          default:
            return MaterialPageRoute(
                builder: (context) => const NotFoundScreen());
        }
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const NotFoundScreen()),
    );
  }
}
