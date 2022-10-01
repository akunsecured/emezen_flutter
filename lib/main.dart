import 'package:emezen/model/enums.dart';
import 'package:emezen/network/api_service.dart';
import 'package:emezen/pages/auth_screen.dart';
import 'package:emezen/pages/home_screen.dart';
import 'package:emezen/pages/not_found_screen.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const EmezenApp());
}

class EmezenApp extends StatelessWidget {
  const EmezenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ApiService>(
      create: (_) => ApiService(),
      child: MaterialApp(
        title: 'Emezen',
        theme: ThemeData(
            primarySwatch: AppTheme.primarySwatch,
            appBarTheme:
                AppBarTheme(color: AppTheme.appBarColor, centerTitle: true)),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
            case '/auth':
              final args = settings.arguments as AuthMethod;
              return MaterialPageRoute(builder: (context) => AuthScreen(args));
            default:
              return MaterialPageRoute(
                  builder: (context) => const NotFoundScreen());
          }
        },
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => const NotFoundScreen()),
      ),
    );
  }
}
