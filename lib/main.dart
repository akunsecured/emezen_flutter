import 'package:emezen/model/enums.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/pages/auth_screen.dart';
import 'package:emezen/pages/home_screen.dart';
import 'package:emezen/pages/not_found_screen.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(EmezenApp());
}

class EmezenApp extends StatelessWidget {
  EmezenApp({Key? key}) : super(key: key);

  late final GoRouter _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
            routes: <GoRoute>[
              GoRoute(
                  name: 'login',
                  path: 'login',
                  pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const AuthScreen(AuthMethod.login))),
              GoRoute(
                  name: 'register',
                  path: 'register',
                  pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const AuthScreen(AuthMethod.register))),
            ],
            name: 'home',
            path: '/',
            pageBuilder: (context, state) =>
                MaterialPage(key: state.pageKey, child: const HomeScreen())),
      ],
      errorPageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const NotFoundScreen()));

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp.router(
        title: 'Emezen',
        theme: ThemeData(
            primarySwatch: AppTheme.primarySwatch,
            appBarTheme:
                AppBarTheme(color: AppTheme.appBarColor, centerTitle: true)),
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
      ),
    );
  }
}
