import 'package:emezen/network/auth_service.dart';
import 'package:emezen/network/user_service.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/router/app_router.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  setPathUrlStrategy();
  runApp(EmezenApp(
    sharedPreferences: sharedPreferences,
  ));
}

class EmezenApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const EmezenApp({Key? key, required this.sharedPreferences})
      : super(key: key);

  @override
  State<EmezenApp> createState() => _EmezenAppState();
}

class _EmezenAppState extends State<EmezenApp> {
  late final AuthService _authService;
  late final UserService _userService;
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _userService = UserService();
    _authProvider = AuthProvider(
        authService: _authService,
        userService: _userService,
        sharedPreferences: widget.sharedPreferences);
  }

  Future<String?> _getCurrentAccessToken() async {
    bool hasToken = await _authProvider.isLoggedIn();
    if (hasToken) {
      return await _authProvider.getAccessToken();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _getCurrentAccessToken(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        final String? accessToken = snapshot.data;

        return MultiProvider(
          providers: [
            Provider<AuthService>(create: (_) => _authService),
            Provider<UserService>(create: (_) => _userService),
            ChangeNotifierProvider<AuthProvider>(create: (_) => _authProvider),
            Provider(
                create: (_) => AppRouter(
                    accessToken: accessToken, authProvider: _authProvider))
          ],
          child: Builder(
            builder: (context) {
              final GoRouter goRouter =
                  Provider.of<AppRouter>(context, listen: false).router;

              return MaterialApp.router(
                title: "Emezen",
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primarySwatch: AppTheme.primarySwatch,
                    appBarTheme: AppBarTheme(
                        color: AppTheme.appBarColor, centerTitle: true)),
                routeInformationParser: goRouter.routeInformationParser,
                routeInformationProvider: goRouter.routeInformationProvider,
                routerDelegate: goRouter.routerDelegate,
              );
            },
          ),
        );
      });
}
