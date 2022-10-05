import 'package:emezen/model/enums.dart';
import 'package:emezen/pages/auth_screen.dart';
import 'package:emezen/pages/home_screen.dart';
import 'package:emezen/pages/not_found_screen.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final String? accessToken;
  final AuthProvider authProvider;

  AppRouter({this.accessToken, required this.authProvider});

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
      routes: <GoRoute>[
        GoRoute(
            routes: <GoRoute>[
              GoRoute(
                  name: 'login',
                  path: 'login',
                  pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: AuthScreen(AuthMethod.login, extras: state.extra)),
                  redirect: (state) {
                    if (accessToken != null) {
                      authProvider
                          .isLoggedIn(accessToken: accessToken)
                          .then((loggedIn) {
                        if (loggedIn) {
                          return state.namedLocation('home');
                        }
                      });
                    }

                    return state.namedLocation('login');
                  }),
              GoRoute(
                  name: 'register',
                  path: 'register',
                  pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child:
                          AuthScreen(AuthMethod.register, extras: state.extra)),
                  redirect: (state) {
                    if (accessToken != null) {
                      authProvider
                          .isLoggedIn(accessToken: accessToken)
                          .then((loggedIn) {
                        if (loggedIn) {
                          return state.namedLocation('home');
                        }
                      });
                    }

                    return state.namedLocation('register');
                  }),
            ],
            name: 'home',
            path: '/',
            pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child:
                    HomeScreen(accessToken: accessToken, extras: state.extra))),
      ],
      errorPageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: NotFoundScreen(state.error)));
}